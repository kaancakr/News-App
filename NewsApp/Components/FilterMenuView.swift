//
//  FilterMenuView.swift
//  NewsApp
//
//  Created by Kaan Çakır on 21.01.2025.
//

import SwiftUI

struct FilterMenuView: View {
    @Binding var selectedFilter: String
    @Binding var filterOpen: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "line.3.horizontal.decrease.circle")
                Text("Order by")
                    .font(.headline)
            }
            .frame(alignment: .center)
            .padding(.bottom, 10)
            Button(action: {
                selectedFilter = "None"
                filterOpen = false
            }) {
                HStack {
                    Text("None")
                    Spacer()
                    if selectedFilter == "None" {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.vertical, 5)
            Button(action: {
                selectedFilter = "Popularity"
                filterOpen = false
            }) {
                HStack {
                    Text("Popularity")
                    Spacer()
                    if selectedFilter == "Popularity" {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.vertical, 5)
            Button(action: {
                selectedFilter = "Publish at"
                filterOpen = false
            }) {
                HStack {
                    Text("Publish at")
                    Spacer()
                    if selectedFilter == "Publish at" {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(maxWidth: 200)
        .position(x: UIScreen.main.bounds.width - 140, y: 100)
        .zIndex(1)
    }
}
