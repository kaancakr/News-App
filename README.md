# News App

A SwiftUI news reader for iOS. It loads articles from [NewsAPI](https://newsapi.org) and saves your favourites offline with Core Data.

## Features

- **Live news feed**: articles from NewsAPI's `/v2/everything` endpoint, with thumbnails, titles, and descriptions.
- **Search**: filter the loaded articles by title as you type.
- **Date filter**: a graphical date picker that limits results to articles published from the chosen day.
- **Ordering**: sort by *Popularity* (sent to the API as `sortBy`) or by *Publish date*.
- **Favourites**: star an article, or swipe it, to save or remove it. Favourites are stored in Core Data and have their own tab with search, a date filter, and ordering.
- **Article detail**: hero image, author, and publish date. A *Description* / *Source* switcher shows either the summary or the original article in an embedded `WKWebView`.

## Tech stack

| Area | Technology |
| --- | --- |
| Language / UI | Swift 5, SwiftUI (`TabView`, `NavigationView`, `AsyncImage`, swipe actions) |
| Architecture | MVVM: `NewsViewModel` (`ObservableObject`) drives the views |
| Networking | [Moya](https://github.com/Moya/Moya) 15 on [Alamofire](https://github.com/Alamofire/Alamofire) 5, via Swift Package Manager |
| Persistence | Core Data (`FavouritedNews` entity) |
| Web content | WebKit (`WKWebView` wrapped in `UIViewRepresentable`) |

## Project structure

```
NewsApp/
├── NewsAppApp.swift        App entry point
├── NewsAPI.swift           Moya TargetType: base URL, endpoint, query parameters, headers
├── Models/                 Article / NewsResponse Codable models, CoreDataManager
├── ViewModels/             NewsViewModel: fetching news, favourites CRUD
├── Views/                  ContentView (tabs), HomeScreenView, FavouritesView, NewsDetailView
├── Components/             NewsRowView, FilterMenuView, CalendarMenuView, WebView
└── CoreData/               DataModel.xcdatamodeld and FavouritedNews managed object
```

## Getting started

### Requirements

- Xcode 16 or later. The project uses the Xcode 16 project format.
- iOS 18.0 deployment target.
- A free NewsAPI key. You can get one at [newsapi.org/register](https://newsapi.org/register).

### Setup

1. Clone the repository:
   ```sh
   git clone https://github.com/kaancakr/News-App.git
   ```
2. Open `NewsApp.xcodeproj`. Xcode resolves the Swift packages (Moya, Alamofire) automatically.
   - You don't need CocoaPods. The `Podfile` declares no pods.
   - Don't open the `.xcworkspace`. It refers to a `Pods` project that doesn't exist.
3. Add your API key. Copy the template into the app folder and put your key in it:
   ```sh
   cp Secrets.swift.example NewsApp/Secrets.swift
   ```
   `NewsApp/Secrets.swift` is gitignored, so the key stays out of version control. `NewsAPI.swift` sends it as the `Authorization: Bearer` header.
4. Choose an iOS 18 simulator or device and run (⌘R).

## Links

- [NewsAPI documentation](https://newsapi.org/docs)
- [Moya](https://github.com/Moya/Moya)
- Author: [@kaancakr](https://github.com/kaancakr)
