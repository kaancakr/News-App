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
        VStack {
            // Search bar
            TextField("Search favorites...", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            // List of favorited articles
            ScrollView {
                LazyVStack(spacing: 15) {
                    let filteredArticles = favoritedArticles.filter { article in
                        searchText.isEmpty || (article.title?.lowercased().contains(searchText.lowercased()) ?? false)
                    }

                    ForEach(filteredArticles, id: \.id) { article in
                        let newsArticle = convertToArticle(from: article)

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
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
        .onAppear {
            loadFavoritedArticles()
        }
    }

    private func loadFavoritedArticles() {
        favoritedArticles = viewModel.fetchFavoritedArticles()
    }

    private func convertToArticle(from favouritedNews: FavouritedNews) -> Article {
        return Article(
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
