import SwiftUI

struct NewsDetailView: View {
    let article: Article
    @Binding var isFavorited: Bool
    @Environment(\.presentationMode) var presentationMode
    var saveAction: (Article) -> Void
    var deleteAction: (String) -> Void
    
    @State private var selectedTab: Tab = .description
    
    enum Tab {
        case description
        case source
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Text("News")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {
                    isFavorited.toggle()
                    if isFavorited {
                        saveAction(article)
                    } else {
                        deleteAction(article.id)
                    }
                }) {
                    Image(systemName: isFavorited ? "star.fill" : "star")
                        .foregroundColor(isFavorited ? .yellow : .gray)
                        .font(.title3)
                }
            }
            .padding()
            
            // Article Metadata
            VStack(alignment: .leading, spacing: 5) {
                Text(article.title)
                    .font(.title2)
                    .lineLimit(2)
                    .padding(.bottom, 5)
                    .fontWeight(.bold)
                
                Text("Author: \(article.author ?? "Unknown")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Published On: \(formattedDate(article.publishedAt))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Tab Selector
            HStack {
                Button(action: {
                    selectedTab = .description
                }) {
                    Text("Description")
                        .font(.headline)
                        .fontWeight(selectedTab == .description ? .bold : .regular)
                        .foregroundColor(selectedTab == .description ? .blue : .gray)
                        .padding(.bottom, 5)
                }
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    selectedTab = .source
                }) {
                    Text("Source")
                        .font(.headline)
                        .fontWeight(selectedTab == .source ? .bold : .regular)
                        .foregroundColor(selectedTab == .source ? .blue : .gray)
                        .padding(.bottom, 5)
                }
                .frame(maxWidth: .infinity)
            }
            .overlay(
                Rectangle()
                    .frame(height: 3)
                    .foregroundColor(.blue)
                    .offset(x: selectedTab == .description ? -UIScreen.main.bounds.width / 2 : UIScreen.main.bounds.width / 2, y: 10),
                alignment: .bottom
            )
            .padding(.top, 20)
            
            // Content
            if selectedTab == .description {
                VStack(alignment: .leading, spacing: 10) {
                    if let imageUrl = article.imageURL {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                        }
                    }
                    
                    Text(article.description ?? "No description available.")
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(20)
                }
                .padding(.top, 20)
            } else if selectedTab == .source {
                VStack {
                    WebView(url: article.articleURL ?? URL(string: "https://www.example.com")!)
                        .padding(20)
                    Spacer()
                    
                    Text("Source: \(article.source.name)")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
