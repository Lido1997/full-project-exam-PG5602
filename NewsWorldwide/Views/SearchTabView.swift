//
//  SearchTabView.swift
//  NewsWorldwide
//

import SwiftUI

struct SearchTabView: View {
    
    @StateObject var searchViewModel = SearchArticleViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                sortMenu 
                ArticleListView(articles: articles)
                    .overlay(overlayView)
                    .navigationTitle("Search NewsAPI")
            }
        }
        .searchable(text: $searchViewModel.searchQuery)
        .onChange(of: searchViewModel.searchQuery) {
            searchViewModel.dataFetchPhase = .empty
        }
        .onSubmit(of: .search, search)
    }
    
    private var sortMenu: some View {
        Menu {
            ForEach(SortOption.allCases) { option in
                Button(action: {
                    searchViewModel.selectedSortOption = option
                    search()
                }) {
                    Text(option.rawValue)
                }
            }
        } label: {
            Label("Sort by \(searchViewModel.selectedSortOption.rawValue)", systemImage: "arrow.up.arrow.down")
                .font(.headline)
        }
        .padding()
    }

    
    private var articles: [Article] {
        if case .success(let articles) = searchViewModel.dataFetchPhase {
            return articles
        } else {
            return []
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch searchViewModel.dataFetchPhase {
        case .empty:
            if !searchViewModel.searchQuery.isEmpty {
                ProgressView()
            } else {
                EmptyPlaceholderView(message: "Type to search NewsAPI", info: "", image: Image(systemName: "magnifyingglass"))
            }
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(message: "No search results", info: "Try different key-words, or check for typos", image: Image(systemName: "exclamationmark.questionmark"))
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: search)
            
        default: EmptyView()
        }
    }
    
    private func search() {
        Task {
            await searchViewModel.searchArticle()
        }
    }
}
