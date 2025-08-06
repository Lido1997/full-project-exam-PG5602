//
//  SearchArticleViewModel.swift
//  NewsWorldwide
//

import SwiftUI

/// Sort options for articles
enum SortOption: String, CaseIterable, Identifiable {
    case relevance = "Relevance"
    case popularity = "Popularity"
    case publishedAt = "Newest"
    
    var id: String { rawValue }
}

@MainActor
class SearchArticleViewModel: ObservableObject {
    
    @Published var dataFetchPhase: DataFetchPhase<[Article]> = .empty
    @Published var searchQuery = ""
    @Published var selectedSortOption: SortOption = .relevance
    
    private let newsAPI = NewsAPI.shared
    
    /// Sort articles based on the selected sorting option
    func sortArticles(_ articles: [Article]) -> [Article] {
        switch selectedSortOption {
        case .relevance:
            return articles /// Default order
        case .popularity:
            return articles.sorted { $0.source.name > $1.source.name } 
        case .publishedAt:
            return articles.sorted { $0.publishedAt > $1.publishedAt }
        }
    }

    /// Search for articles using the query and sort them
    func searchArticle() async {
        if Task.isCancelled { return }
        
        let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        dataFetchPhase = .empty
        
        if searchQuery.isEmpty {
            return
        }
        
        do {
            let articles = try await newsAPI.search(for: searchQuery, sortOption: selectedSortOption)
            let sortedArticles = sortArticles(articles)
            if Task.isCancelled { return }
            dataFetchPhase = .success(sortedArticles)
        } catch {
            if Task.isCancelled { return }
            dataFetchPhase = .failure(error)
        }
    }

}


