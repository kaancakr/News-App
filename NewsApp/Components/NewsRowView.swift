//
//  NewsRowView.swift
//  NewsApp
//
//  Created by Kaan Çakır on 20.01.2025.
//

import SwiftUI

struct NewsRowView: View {
    @State var article: Article
    @Binding var isFavorited: Bool
    var saveAction: (Article) -> Void
    var deleteAction: (String) -> Void
    
    var body: some View {
        HStack {
            if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(8)
                        .padding(.trailing)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
            }
            
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(.black)
                if let description = article.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Button(action: {
                isFavorited.toggle()
                if isFavorited {
                    saveAction(article)
                } else {
                    deleteAction(article.id)
                }
            }) {
                Image(systemName: isFavorited ? "star.fill" : "star")
                    .foregroundColor(isFavorited ? .yellow : .gray)
                    .font(.title3)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}
