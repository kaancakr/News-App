//
//  FavouritesView.swift
//  NewsApp
//
//  Created by Kaan Çakır on 20.01.2025.
//

import SwiftUI

struct FavouritesView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var searchText: String = ""
    @State private var favoritedArticles: [FavouritedNews] = []
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: Search Bar
                TextField("Search favorites...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // MARK: Favorited Articles List
                if favoritedArticles.isEmpty {
                    Text("No favorites yet.")
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                } else {
                    List {
                        let filteredArticles = favoritedArticles.filter { article in
                            searchText.isEmpty
                            || (article.title?.lowercased().contains(searchText.lowercased()) ?? false)
                        }
                        
                        ForEach(filteredArticles, id: \.id) { favArticle in
                            let newsArticle = convertToArticle(from: favArticle)
                            
                            NavigationLink(
                                destination: NewsDetailView(
                                    article: newsArticle,
                                    isFavorited: .constant(true),
                                    saveAction: { viewModel.saveFavouritedNews(article: $0) },
                                    deleteAction: { id in
                                        viewModel.deleteFavouritedArticle(articleID: id)
                                        loadFavoritedArticles()
                                    }
                                )
                            ) {
                                NewsRowView(
                                    article: newsArticle,
                                    isFavorited: .constant(true),
                                    saveAction: { viewModel.saveFavouritedNews(article: $0) },
                                    deleteAction: { id in
                                        viewModel.deleteFavouritedArticle(articleID: id)
                                        loadFavoritedArticles()
                                    }
                                )
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    if let id = favArticle.id {
                                        viewModel.deleteFavouritedArticle(articleID: id)
                                        loadFavoritedArticles()
                                    }
                                } label: {
                                    Label("Unfavorite", systemImage: "star.slash")
                                }
                                .tint(.yellow)
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    
                }
            }
            .onAppear {
                loadFavoritedArticles()
            }
            .navigationTitle("Favorites")
        }
    }
    
    private func loadFavoritedArticles() {
        favoritedArticles = viewModel.fetchFavoritedArticles()
    }
    
    private func convertToArticle(from favouritedNews: FavouritedNews) -> Article {
        Article(
            source: Source(id: nil, name: "Unknown Source"),
            author: favouritedNews.author ?? "",
            title: favouritedNews.title ?? "Untitled",
            description: favouritedNews.content ?? "No description available.",
            url: favouritedNews.url ?? "",
            urlToImage: favouritedNews.urlToImage,
            publishedAt: favouritedNews.publishedDate ?? Date(),
            content: favouritedNews.content,
            popularity: 0
        )
    }
}

#Preview {
    FavouritesView()
}
