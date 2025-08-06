//
//  SavedArticle.swift
//  NewsWorldwide
//

import Foundation
import SwiftData

@Model
final class SavedArticle {
    @Attribute(.unique) var id: String
    var title: String
    var url: String
    var publishedAt: Date
    var category: CategoryEntity
    var urlToImage: String?
    var descriptionText: String?
    var author: String?
    var sourceName: String
    var savedAt: Date 

    init(id: String, title: String, url: String, publishedAt: Date, category: CategoryEntity, urlToImage: String?, description: String?, author: String?, sourceName: String, savedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.url = url
        self.publishedAt = publishedAt
        self.category = category
        self.urlToImage = urlToImage
        self.descriptionText = description
        self.author = author
        self.sourceName = sourceName
        self.savedAt = savedAt
    }
}




