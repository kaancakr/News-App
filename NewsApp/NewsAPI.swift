import Foundation
import Moya

enum NewsAPI {
    case fetchNews(parameters: [String: String])
}

extension NewsAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2")!
    }
    
    var path: String {
        switch self {
        case .fetchNews:
            return "/everything"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchNews:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .fetchNews(parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchNews:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer 933f079b9e174b468eabdf56c67dd14d"
            ]
        }
    }
    
    var sampleData: Data {
        return """
        {
            "status": "ok",
            "totalResults": 1,
            "articles": [
                {
                    "source": { "name": "Example" },
                    "author": "Author Name",
                    "title": "Example News Title",
                    "description": "This is an example news description.",
                    "url": "https://example.com",
                    "urlToImage": "https://example.com/image.jpg",
                    "publishedAt": "2023-01-01T00:00:00Z",
                    "content": "This is the content of the example news."
                }
            ]
        }
        """.data(using: .utf8)!
    }
}
