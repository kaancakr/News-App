//
//  CalendarMenuView.swift
//  NewsApp
//
//  Created by Kaan Çakır on 22.01.2025.
//

import SwiftUI

struct CalendarMenuView: View {
    @Binding var selectedDate: Date?
    @Binding var calendarOpen: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Select Date")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color(.darkGray))
            .cornerRadius(10, corners: [.topLeft, .topRight])
            
            DatePicker("", selection: Binding(
                get: { selectedDate ?? Date() },
                set: { selectedDate = $0 }
            ), displayedComponents: .date)
            .datePickerStyle(GraphicalDatePickerStyle())
            .labelsHidden()
            .padding()
            
            HStack {
                Button(action: { calendarOpen = false }) {
                    Text("Close")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                        .foregroundColor(.blue)
                }
                Button(action: { selectedDate = nil }) {
                    Text("Reset")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                        .foregroundColor(.blue)
                }
            }
        }
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// MARK: Helper Modifier
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
