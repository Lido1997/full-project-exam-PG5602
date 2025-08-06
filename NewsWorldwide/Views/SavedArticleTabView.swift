//
//  SavedArticleTabView.swift
//  NewsWorldwide
//

import SwiftUI

struct SavedArticleTabView: View {
    @EnvironmentObject var savedArticleViewModel: SavedArticleViewModel
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "All"
    @State private var selectedArticle: Article?

    var body: some View {
        let articles = self.filteredArticles

        NavigationView {
            VStack {
                List {
                    ForEach(articles) { article in
                        ArticleRowView(article: article) /// Displays each article in a row/
                            .onTapGesture {
                                selectedArticle = article /// Opens the article in detail view
                            }
                    }
                    .onDelete(perform: deleteArticle) /// Swipe to delete
                }
                .listStyle(.plain)
                .overlay(overlayView(isEmpty: articles.isEmpty))
                .sheet(item: $selectedArticle) { article in
                    ArticleDetailView(article: article, onClose: {
                        selectedArticle = nil
                    })
                    .environmentObject(savedArticleViewModel)
                }
            }
            .navigationTitle("My Articles")
            .navigationBarItems(trailing: combinedCategoryButton) /// Category filter button
        }
        .searchable(text: $searchText) /// Search bar to filter articles
    }

    private var combinedCategoryButton: some View {
        HStack {
            Text("(\(selectedCategory))")
                .font(.footnote)
                .foregroundColor(.secondary)
            Menu {
                Button(action: {
                    selectedCategory = "All"
                }) {
                    HStack {
                        Text("All")
                        if selectedCategory == "All" {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                ForEach(savedArticleViewModel.getAllCategories(), id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        HStack {
                            Text(category)
                            if selectedCategory == category {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: "list.bullet")
                    .imageScale(.large)
            }
        }
    }


    private var filteredArticles: [Article] {
        let saved = savedArticleViewModel.savedArticles

        let mappedArticles = saved.map {
            Article(
                source: Source(name: $0.sourceName),
                title: $0.title,
                url: $0.url,
                publishedAt: $0.publishedAt,
                author: $0.author,
                description: $0.descriptionText,
                urlToImage: $0.urlToImage
            )
        }

        let sortedArticles = mappedArticles.sorted { $0.publishedAt > $1.publishedAt }

        let filteredByCategory = selectedCategory == "All" ? sortedArticles : sortedArticles.filter {
            $0.source.name.lowercased() == selectedCategory.lowercased()
        }

        /// Filters articles based on search text
        if searchText.isEmpty {
            return filteredByCategory
        } else {
            return filteredByCategory.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                ($0.description?.lowercased() ?? "").contains(searchText.lowercased())
            }
        }
    }

    /// Delete article from storage
    private func deleteArticle(at offsets: IndexSet) {
        for index in offsets {
            let articleToDelete = filteredArticles[index]
            if let savedArticle = savedArticleViewModel.savedArticles.first(where: { $0.id == articleToDelete.id }) {
                savedArticleViewModel.deleteArticle(savedArticle)
            }
        }
    }


    @ViewBuilder
    func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            EmptyPlaceholderView(
                message: "No saved articles",
                info: "Please fetch articles from News-tab",
                image: Image(systemName: "square.stack.3d.up.slash")
            )
        }
    }
}
