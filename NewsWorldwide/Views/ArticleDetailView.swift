//
//  ArticleDetailView.swift
//  NewsWorldwide
//

import SwiftUI

struct ArticleDetailView: View {
    @EnvironmentObject var savedArticleViewModel: SavedArticleViewModel
    @State private var selectedCategory: String = "General"
    @State private var showCategoryPicker = false
    @State private var showSafariView = false 

    let article: Article
    let onClose: () -> Void /// Close modal

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let imageURL = article.imageURL {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                fatalError()
                            }
                        }
                        .frame(maxHeight: 300)
                    }

                    Text(article.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    /// Author and source
                    HStack {
                        if !article.authorText.isEmpty {
                            Text(article.authorText)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(article.sourceName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Text(article.descriptionText)
                        .font(.body)

                    Text(article.captionText)
                        .foregroundColor(.secondary)
                        .font(.caption)

                    Button(action: {
                        showSafariView = true
                    }) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Read Full Article")
                        }
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $showSafariView) {
                        SafariView(url: article.articleURL)
                    }

                    /// Save or Remove button
                    if savedArticleViewModel.isSaved(for: article) {
                        Button(action: {
                            if let savedArticle = savedArticleViewModel.savedArticles.first(where: { $0.id == article.id }) {
                                savedArticleViewModel.deleteArticle(savedArticle)
                                onClose() /// Close modal
                            }
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Remove from 'My Articles'")
                            }
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    } else {
                        Button {
                            showCategoryPicker.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "bookmark")
                                Text("Save Article")
                            }
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .sheet(isPresented: $showCategoryPicker) {
                            VStack {
                                Picker("Select Category", selection: $selectedCategory) {
                                    ForEach(savedArticleViewModel.getAllCategories().sorted { $0 == "General" || $0 < $1 }, id: \.self) { category in
                                        Text(category).tag(category)
                                    }
                                }
                                .pickerStyle(.wheel)

                                HStack {
                                    Button("Cancel") {
                                        showCategoryPicker = false
                                    }
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .padding()

                                    Spacer()

                                    Button("Save") {
                                        savedArticleViewModel.saveArticle(article: article, to: selectedCategory)
                                        showCategoryPicker = false
                                        onClose()
                                    }
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Article Details")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        onClose()
                    }
                }
            }
        }
    }
}
