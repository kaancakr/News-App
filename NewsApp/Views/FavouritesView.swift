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
    @State private var filterOpen: Bool = false
    @State private var selectedDate: Date?
    @State private var showCalendar: Bool = false
    @State private var selectedFilter: String = "None"
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    // MARK: Search Bar
                    HStack {
                        TextField("Search news...", text: $searchText)
                            .padding(.leading, 30)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 10)
                                    Spacer()
                                    Button(action: {
                                        showCalendar.toggle()
                                    }) {
                                        Image(systemName: "calendar")
                                            .foregroundColor(showCalendar ? .blue : Color(.darkGray))
                                            .padding(.trailing, 10)
                                    }
                                }
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
                        Button(action: {
                            withAnimation {
                                filterOpen.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .foregroundColor(filterOpen ? .blue : Color(.darkGray))
                                .font(.title)
                                .padding(.trailing, 20)
                        }
                    }
                    
                    // MARK: Favorited Articles List
                    if favoritedArticles.isEmpty {
                        VStack {
                            Text("No news available for the selected day.")
                                .font(.headline)
                                .padding()
                            Button("Reset Date") {
                                selectedDate = nil
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                // MARK: Filter Menu
                if filterOpen {
                    FilterMenuView(selectedFilter: $selectedFilter, filterOpen: $filterOpen)
                }
                
                // MARK: Calendar Menu
                if showCalendar {
                    CalendarMenuView(selectedDate: $selectedDate, calendarOpen: $showCalendar)
                }
            }
            .onAppear {
                loadFavoritedArticles()
            }
            .onChange(of: selectedFilter) { newFilter in
                // print("Selected filter changed to: \(newFilter)")
                loadFavoritedArticles()
            }
            .onChange(of: selectedDate) { newFilter in
                loadFavoritedArticles()
            }
            .navigationTitle("Favorites")
        }
    }
    
    private func loadFavoritedArticles() {
        favoritedArticles = viewModel.fetchFavoritedArticles(forDate: selectedDate, forFilter: selectedFilter)
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
