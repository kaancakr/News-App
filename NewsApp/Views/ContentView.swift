//
//  ContentView.swift
//  NewsApp
//
//  Created by Kaan Çakır on 20.01.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeScreenView().tabItem() {
                Image(systemName: "house")
                Text("Home")
            }
            FavouritesView().tabItem() {
                Image(systemName: "star")
                Text("Favourites")
            }
        }.preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
