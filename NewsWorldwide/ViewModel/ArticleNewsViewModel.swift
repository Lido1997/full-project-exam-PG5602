//
//  ArticleNewsViewModel.swift
//  NewsWorldwide
//

import SwiftUI

/// Enum representing the current state of data fetching
enum DataFetchPhase<T> {
    case empty
    case success(T)
    case failure(Error)
}

/// ViewModel for managing articles and fetching from the API
@MainActor
class ArticleNewsViewModel: ObservableObject {
    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var selectedCategory: Category = .general
    @Published var searchQuery = ""
    @Published var selectedSortOption: SortOption = .relevance {
        didSet {
            applySorting() /// Reapply sorting whenever sort option changes
        }
    }

    private let newsAPI = NewsAPI.shared
    private var originalArticles: [Article] = []

    /// Fetch articles based on the selected category
    func loadArticles() async {
        phase = .empty
        do {
            let articles = try await newsAPI.fetch(from: selectedCategory)
            originalArticles = articles
            applySorting()
        } catch {
            phase = .failure(error)
        }
    }

    /// Search for articles based on the search query and sorting option
    func searchArticles() async {
        let trimmedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }

        phase = .empty /// Reset the phase to indicate loading
        do {
            let articles = try await newsAPI.search(for: trimmedQuery, sortOption: selectedSortOption)
            originalArticles = articles
            applySorting()
        } catch {
            phase = .failure(error)
        }
    }

    /// Apply the selected sorting option to the articles
    private func applySorting() {
        guard !originalArticles.isEmpty else {
            phase = .empty
            return
        }

        let sortedArticles = sortArticles(originalArticles)
        phase = .success(sortedArticles)
    }

    /// Sort articles based on the selected sorting option
    private func sortArticles(_ articles: [Article]) -> [Article] {
        switch selectedSortOption {
        case .relevance:
            return originalArticles
        case .popularity:
            return articles.sorted { $0.source.name > $1.source.name }
        case .publishedAt:
            return articles.sorted { $0.publishedAt > $1.publishedAt }
        }
    }
}


