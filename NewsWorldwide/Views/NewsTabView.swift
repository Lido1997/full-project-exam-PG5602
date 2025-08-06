//
//  NewsTabView.swift
//  NewsWorldwide
//

import SwiftUI

struct NewsTabView: View {
    @StateObject var articleNewsViewModel = ArticleNewsViewModel()
    @State private var isSearchSheetPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                ArticleListView(articles: articles)
                    .overlay(overlayView)
                    .refreshable {
                        await loadTask()
                    }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    searchButton
                    sortButton
                    if articleNewsViewModel.searchQuery.isEmpty {
                        categoryButton
                    } else {
                        cancelButton
                    }
                }
            }
            .sheet(isPresented: $isSearchSheetPresented) {
                SearchSheetView(articleNewsViewModel: articleNewsViewModel)
            }
            .onAppear {
                if case .empty = articleNewsViewModel.phase {
                    Task {
                        await loadTask()
                    }
                }
            }
        }
    }
    
    /// Property for the current articles to display
    private var articles: [Article] {
        if case .success(let articles) = articleNewsViewModel.phase {
            return articles
        } else {
            return []
        }
    }
    
    /// Fetch articles based on the current search or category
    private func loadTask() async {
        if articleNewsViewModel.searchQuery.isEmpty {
            await articleNewsViewModel.loadArticles()
        } else {
            await articleNewsViewModel.searchArticles()
        }
    }
    
    /// Dynamic navigation title based on search or category
    private var navigationTitle: String {
        if !articleNewsViewModel.searchQuery.isEmpty {
            return "Results for '\(articleNewsViewModel.searchQuery)'"
        }
        return articleNewsViewModel.selectedCategory.text
    }
    
    /// Overlay for handling empty, error, or no results states
    private var overlayView: some View {
        switch articleNewsViewModel.phase {
        case .empty:
            return AnyView(
                EmptyPlaceholderView(
                    message: "No Articles Found",
                    info: "",
                    image: Image(systemName: "square.stack.3d.up.slash")
                )
            )
        case .success(let articles) where articles.isEmpty:
            return AnyView(
                EmptyPlaceholderView(
                    message: "No Articles Found",
                    info: "",
                    image: Image(systemName: "square.stack.3d.up.slash")
                )
            )
        case .failure(let error):
            return AnyView(
                RetryView(
                    text: error.localizedDescription,
                    retryAction: {
                        Task {
                            await loadTask()
                        }
                    }
                )
            )
        default:
            return AnyView(EmptyView())
        }
    }
    
    /// Category selection menu
    private var categoryButton: some View {
        Menu {
            ForEach(Category.allCases, id: \.self) { category in
                Button(action: {
                    articleNewsViewModel.selectedCategory = category
                    articleNewsViewModel.searchQuery = ""
                    Task {
                        await loadTask()
                    }
                }) {
                    HStack {
                        Text(category.text)
                        if articleNewsViewModel.selectedCategory == category {
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

    /// Cancel button to clear search query
    private var cancelButton: some View {
        Button("Cancel") {
            articleNewsViewModel.searchQuery = ""
            Task {
                await articleNewsViewModel.loadArticles()
            }
        }
        .foregroundColor(.red)
    }

    /// Sorting options menu
    private var sortButton: some View {
        Menu {
            ForEach(SortOption.allCases) { option in
                Button(action: {
                    articleNewsViewModel.selectedSortOption = option
                }) {
                    HStack {
                        Text(option.rawValue)
                        if articleNewsViewModel.selectedSortOption == option {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .imageScale(.large)
        }
    }

    /// Search button to open the search modal
    private var searchButton: some View {
        Button(action: {
            isSearchSheetPresented = true
        }) {
            Image(systemName: "magnifyingglass")
                .imageScale(.large)
        }
    }
}
