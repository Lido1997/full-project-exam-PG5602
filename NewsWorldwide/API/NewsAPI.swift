//
//  NewsAPI.swift
//  NewsWorldwide
//

import Foundation

struct NewsAPI {
    static let shared = NewsAPI() /// Singleton instance for the API
    private init() {}
    
    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    /// Retrieve API key from Keychain – crash if not found
    private var apiKey: String {
        guard let key = KeychainHelper.shared.retrieve(key: "APIKey"), !key.isEmpty else {
            fatalError("❌ API key not found in Keychain. Please set the key before running the app.")
        }
        return key
    }
    
    /// Fetch articles for a specific category
    func fetch(from category: Category) async throws -> [Article] {
        try await fetchArticles(from: generateNewsURL(from: category))
    }
    
    /// Search for articles using a query and sortOption
    func search(for query: String, sortOption: SortOption) async throws -> [Article] {
        try await fetchArticles(from: generateSearchURL(from: query, sortOption: sortOption))
    }
    
    /// Perform the network request and handle response
    private func fetchArticles(from url: URL) async throws -> [Article] {
        let (data, response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Bad Response")
        }
        switch response.statusCode {
        case 200...299:
            let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
            if apiResponse.status == "ok" {
                print("✅ Fetched Articles: \(apiResponse.articles ?? [])")
                return apiResponse.articles ?? []
            } else {
                throw generateError(description: apiResponse.message ?? "An error occurred")
            }
        default:
            throw generateError(description: "A server error occurred: \(response.statusCode) – API key may be invalid.")
        }
    }

    /// Custom error with description
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    /// URL for searching articles
    private func generateSearchURL(from query: String, sortOption: SortOption) -> URL {
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&q=\(percentEncodedString)"
        url += "&sortBy=\(sortOption.rawValue.lowercased())"
        print("🔍 Generated Search URL: \(url)")

        return URL(string: url)!
    }

    /// URL for fetching top headlines by category
    private func generateNewsURL(from category: Category) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        print("📰 Generated News URL: \(url)")
        
        return URL(string: url)!
    }
}
