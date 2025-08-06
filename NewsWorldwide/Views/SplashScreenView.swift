//
//  SplashScreenView.swift
//  NewsWorldwide
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var savedArticleViewModel: SavedArticleViewModel 
    @State private var isActive = false
    @State private var imageScale: CGFloat = 1.0
    @State private var imageRotation: Double = 0

    var body: some View {
        if isActive {
            ContentView()
                .environmentObject(savedArticleViewModel)
        } else {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                Image(systemName: "newspaper.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .scaleEffect(imageScale)
                    .rotationEffect(.degrees(imageRotation))
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                        ) {
                            imageScale = 2.0
                        }
                    }
                
                VStack {
                    Spacer()
                    Text("NewsWorldwide")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.bottom, 40)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

