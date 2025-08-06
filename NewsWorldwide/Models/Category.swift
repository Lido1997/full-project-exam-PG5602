//
//  Category.swift
//  NewsWorldwide
//

import Foundation
import SwiftData

// Category Enum
enum Category: String, CaseIterable {
    case general
    case business
    case technology
    case entertainment
    case sports
    case science
    case health
    
    var text: String {
        if self == .general {
            return "Latest News"
        }
        return rawValue.capitalized
    }
}

extension Category: Identifiable {
    var id: Self { self }
}

// CetegoryEntity Model
@Model
final class CategoryEntity {
    @Attribute(.unique) var name: String
    var articles: [SavedArticle]

    init(name: String) {
        self.name = name
        self.articles = []
    }
}
