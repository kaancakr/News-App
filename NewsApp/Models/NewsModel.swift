//
//  NewsModel.swift
//  NewsApp
//
//  Created by Kaan Çakır on 20.01.2025.
//

import Foundation

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int?
    let articles: [Article]
    let code: String?
    let message: String?
}

struct Article: Codable, Equatable, Identifiable {
    var id: String {
        return url
    }
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
    let popularity: Int?
    
    var authorText: String {
        author ?? "Unknown Author"
    }
    var descriptionText: String {
        description ?? "No description available."
    }
    var articleURL: URL? {
        URL(string: url)
    }
    var imageURL: URL? {
        guard let urlToImage = urlToImage else { return nil }
        return URL(string: urlToImage)
    }
}

extension Article {
    static var previewData: [Article] {
        let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")
        let data = try! Data(contentsOf: previewDataURL!)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let apiResponse = try! jsonDecoder.decode(NewsResponse.self, from: data)
        return apiResponse.articles
    }
}

struct Source: Codable, Equatable {
    let id: String?
    let name: String
}
