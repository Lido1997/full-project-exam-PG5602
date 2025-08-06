//
//  EmptyPlaceholderView.swift
//  NewsWorldwide
//

import SwiftUI

struct EmptyPlaceholderView: View {
    
    let message: String
    let info: String
    let image: Image?
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            if let image = self.image {
                image
                    .imageScale(.large)
                    .font(.system(size: 52))
            }
            Text(message)
                .font(.title)
                .fontWeight(.bold)
            Text(info)
                .font(.subheadline)
                .foregroundStyle(.gray)
            Spacer()
        }
    }
}

struct EmptyPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlaceholderView(message: "No Bookmarks", info: "Please add articles", image: Image(systemName: "square.stack.3d.up.slash"))
    }
}
