//
//  ArticleListView.swift
//  NewsWorldwide
//

import SwiftUI

struct ArticleListView: View {
    let articles: [Article]
    @State private var selectedArticle: Article?

    @EnvironmentObject var savedArticleViewModel: SavedArticleViewModel

    var body: some View {
        List {
            ForEach(articles) { article in
                ArticleRowView(article: article)
                    .padding(.vertical, 9)
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        selectedArticle = article
                    }
            }
            .listRowInsets(EdgeInsets()) 
        }
        .listStyle(.plain)
        .sheet(item: $selectedArticle) { article in
            ArticleDetailView(article: article, onClose: {
                selectedArticle = nil
            })
            .environmentObject(savedArticleViewModel)
        }
    }
}


