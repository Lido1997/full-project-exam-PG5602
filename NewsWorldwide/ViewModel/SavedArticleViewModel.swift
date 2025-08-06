//
//  SavedArticleViewModel.swift
//  NewsWorldwide
//

import SwiftUI
import SwiftData

@MainActor
class SavedArticleViewModel: ObservableObject {
    @Published var savedArticles: [SavedArticle] = []
    private var context: ModelContext!

    init(context: ModelContext) {
        self.context = context
        fetchSavedArticles()
    }

    /// Fetch all saved articles
    func fetchSavedArticles() {
        let request = FetchDescriptor<SavedArticle>()
        do {
            savedArticles = try context.fetch(request)
        } catch {
            print("Failed to fetch articles: \(error.localizedDescription)")
        }
    }

    /// Fetch all categories
    func getAllCategories() -> [String] {
        let request = FetchDescriptor<CategoryEntity>()
        do {
            let categories = try context.fetch(request)
            return categories.map { $0.name }
        } catch {
            print("Failed to fetch categories: \(error.localizedDescription)")
            return []
        }
    }

    /// Check if the article is already saved
    func isSaved(for article: Article) -> Bool {
        return savedArticles.contains { $0.id == article.id }
    }

    /// Find or create category
    func saveArticle(article: Article, to categoryName: String) {
        let category = fetchOrCreateCategory(named: categoryName)
        
        let savedArticle = SavedArticle(
            id: article.id,
            title: article.title,
            url: article.url,
            publishedAt: article.publishedAt,
            category: category,
            urlToImage: article.urlToImage,
            description: article.descriptionText,
            author: article.authorText,
            sourceName: article.source.name,
            savedAt: Date() // Sett tidspunktet for lagring
        )
        context.insert(savedArticle) /// Save the article to the database
        category.articles.append(savedArticle) /// Add the article to the category
        saveChanges()
        fetchSavedArticles() /// Refresh the list of saved articles
    }



    private func fetchOrCreateCategory(named name: String) -> CategoryEntity {
        let request = FetchDescriptor<CategoryEntity>(predicate: #Predicate { $0.name == name })
        
        /// Return existing category if found
        if let existingCategory = try? context.fetch(request).first {
            return existingCategory
        } else {
            /// Create and save a new category if it doesn't exist
            let newCategory = CategoryEntity(name: name)
            context.insert(newCategory)
            saveChanges()
            return newCategory
        }
    }

    /// Remove article from database
    func deleteArticle(_ article: SavedArticle) {
        context.delete(article)
        saveChanges()
        fetchSavedArticles()
    }

    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
