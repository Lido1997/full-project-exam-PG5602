//
//  ContentView.swift
//  NewsWorldwide
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            SavedArticleTabView()
                .tabItem {
                    Label("My Articles", systemImage: "bookmark")
                }
            
            NewsTabView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            SettingsTabView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
