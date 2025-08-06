//
//  NewsWorldwideApp.swift
//  NewsWorldwide
//

import SwiftUI
import SwiftData

@main
struct NewsWorldwideApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    private let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: SavedArticle.self, CategoryEntity.self)
            initializeCategories(context: container.mainContext)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }

    private func initializeCategories(context: ModelContext) {
        let predefinedCategories = ["General", "Business", "Technology", "Entertainment", "Sports", "Health", "Science"]

        let request = FetchDescriptor<CategoryEntity>()
        let existingCategories = try? context.fetch(request).map { $0.name }

        for category in predefinedCategories where !(existingCategories?.contains(category) ?? false) {
            let newCategory = CategoryEntity(name: category)
            context.insert(newCategory)
        }

        do {
            try context.save()
        } catch {
            print("Failed to initialize categories: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(SavedArticleViewModel(context: container.mainContext)) /// Share model in environment
                .modelContainer(container)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}


