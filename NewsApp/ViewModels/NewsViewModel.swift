//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Kaan Çakır on 20.01.2025.
//

import Foundation
import Combine
import Moya
import CoreData

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var currentPage = 1
    private var hasMorePages = true
    
    private let provider = MoyaProvider<NewsAPI>()
    private var cancellables = Set<AnyCancellable>()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func saveFavouritedNews(article: Article) {
        let context = CoreDataManager.shared.context
        
        let favouritedNews = FavouritedNews(context: context)
        favouritedNews.id = article.id
        favouritedNews.title = article.title
        favouritedNews.content = article.content
        favouritedNews.publishedDate = article.publishedAt
        favouritedNews.url = article.url
        favouritedNews.author = article.author
        favouritedNews.urlToImage = article.urlToImage
        
        do {
            try context.save()
            print("Article saved as favorite.")
        } catch {
            print("Failed to save article: \(error.localizedDescription)")
        }
    }
    
    func deleteFavouritedArticle(articleID: String) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<FavouritedNews> = FavouritedNews.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", articleID)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            try context.save()
            print("Article removed from favorites.")
        } catch {
            print("Failed to delete article: \(error.localizedDescription)")
        }
    }
    
    func fetchFavoritedArticles() -> [FavouritedNews] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<FavouritedNews> = FavouritedNews.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorited articles: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchNews(forDate date: Date?, forFilter filter: String?) {
        isLoading = true
        errorMessage = nil
        
        var parameters: [String: String] = ["q": "technology"]
        if let date = date {
            let formattedDate = dateFormatter.string(from: date)
            parameters["from"] = formattedDate
        }
        
        if let filter = filter {
            switch filter {
            case "Popularity":
                parameters["sortBy"] = "popularity"
            case "publishedAt":
                parameters["sortBy"] = "publishedAt"
            case "None":
                parameters["sortBy"] = nil
            default:
                break
            }
        }
        
        //print("Fetching news with parameters: \(parameters)")
        
        provider.request(.fetchNews(parameters: parameters)) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let response):
                
                let apiResponse = String(data: response.data, encoding: .utf8)
                print(apiResponse ?? "Error occured while decoding data")
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let newsResponse = try decoder.decode(NewsResponse.self, from: response.data)
                    if newsResponse.status == "ok" {
                        self?.articles = newsResponse.articles
                        if let filter = filter {
                            self?.sortArticles(by: filter)
                        }
                    } else {
                        self?.errorMessage = newsResponse.message ?? "Unknown error"
                    }
                } catch {
                    self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            case .failure(let error):
                self?.errorMessage = "Network error: \(error.localizedDescription)"
            }
        }
    }
    
    private func sortArticles(by filter: String) {
        switch filter {
        case "Publish at":
            articles.sort { $0.publishedAt > $1.publishedAt }
        default:
            break
        }
    }
}
