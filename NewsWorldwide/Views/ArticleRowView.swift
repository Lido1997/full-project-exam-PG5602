//
//  ArticleRowView.swift
//  NewsWorldwide
//

import SwiftUI

struct ArticleRowView: View {
    @EnvironmentObject var savedArticleViewModel: SavedArticleViewModel

    let article: Article

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
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
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(article.captionText)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()
            }

            Spacer()

            Image(systemName: savedArticleViewModel.isSaved(for: article) ? "bookmark.fill" : "bookmark")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12) 
    }
}


