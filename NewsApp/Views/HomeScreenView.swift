//
//  HomeScreenView.swift
//  NewsApp
//
//  Created by Kaan Çakır on 20.01.2025.
//

import SwiftUI

struct HomeScreenView: View {
    @State private var searchText: String = ""
    @StateObject private var viewModel = NewsViewModel()
    @State private var filterOpen: Bool = false
    @State private var selectedDate: Date?
    @State private var showCalendar: Bool = false
    @State private var favoriteStatus: [String: Bool] = [:]
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
                                            .foregroundColor(showCalendar ? .blue : .black)
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
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundColor(filterOpen ? .blue : .black)
                                .font(.title)
                                .padding(.trailing, 20)
                        }
                    }
                    
                    // MARK: Content
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.articles.isEmpty {
                        VStack {
                            Text("No news available for the selected day.")
                                .font(.headline)
                                .padding()
                            Button("Reset Date") {
                                selectedDate = nil
                                viewModel.fetchNews(forDate: nil, forFilter: nil)
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // MARK: List with Swipe
                        List {
                            ForEach(viewModel.articles.filter { article in
                                searchText.isEmpty
                                || article.title.lowercased().contains(searchText.lowercased())
                            }) { article in
                                let isFavoritedBinding = Binding<Bool>(
                                    get: { favoriteStatus[article.id, default: false] },
                                    set: { favoriteStatus[article.id] = $0 }
                                )
                                
                                NavigationLink(destination: NewsDetailView(article: article, isFavorited: isFavoritedBinding, saveAction: { viewModel.saveFavouritedNews(article: $0) },deleteAction: { viewModel.deleteFavouritedArticle(articleID: $0) })
                                ) {
                                    NewsRowView(
                                        article: article,
                                        isFavorited: isFavoritedBinding,
                                        saveAction: { viewModel.saveFavouritedNews(article: $0) },
                                        deleteAction: { viewModel.deleteFavouritedArticle(articleID: $0) }
                                    )
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button {
                                        isFavoritedBinding.wrappedValue.toggle()
                                        if isFavoritedBinding.wrappedValue {
                                            viewModel.saveFavouritedNews(article: article)
                                        } else {
                                            viewModel.deleteFavouritedArticle(articleID: article.id)
                                        }
                                    } label: {
                                        Label(isFavoritedBinding.wrappedValue ? "Unfavorite" :"Favorite", systemImage:
                                                isFavoritedBinding.wrappedValue
                                              ? "star.slash"
                                              : "star.fill"
                                        )
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
            .navigationTitle("News")
        }
        .onAppear {
            viewModel.fetchNews(forDate: selectedDate, forFilter: selectedFilter)
            
            let favouritedArticles = viewModel.fetchFavoritedArticles()
            favoriteStatus = Dictionary(
                uniqueKeysWithValues: favouritedArticles.compactMap { article in
                    guard let id = article.id else { return nil }
                    return (id, true)
                }
            )
        }
        .onChange(of: selectedFilter) { newFilter in
            viewModel.fetchNews(forDate: selectedDate, forFilter: selectedFilter)
        }
        .onChange(of: selectedDate) { newFilter in
            viewModel.fetchNews(forDate: selectedDate, forFilter: selectedFilter)
        }
    }
}


#Preview {
    HomeScreenView()
}

