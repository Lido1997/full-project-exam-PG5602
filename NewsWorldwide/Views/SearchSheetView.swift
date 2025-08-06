//
//  SearchSheetView.swift
//  NewsWorldwide
//

import SwiftUI

struct SearchSheetView: View {
    @ObservedObject var articleNewsViewModel: ArticleNewsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                /// Search field
                TextField("Search articles...", text: $articleNewsViewModel.searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onSubmit {
                        Task {
                            await performSearch()
                        }
                    }
                
                /// Sorting options
                HStack {
                    Text("Sort by:")
                        .font(.headline)
                    Spacer()
                    Picker("Sort Option", selection: $articleNewsViewModel.selectedSortOption) {
                        ForEach(SortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Search Articles")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Search") {
                        Task {
                            await performSearch()
                        }
                    }
                }
            }
        }
    }
    
    private func performSearch() async {
        await articleNewsViewModel.searchArticles()
        dismiss()
    }
}
