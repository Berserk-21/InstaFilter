//
//  UnavailableView.swift
//  Instafilter
//
//  Created by Berserk on 24/06/2024.
//

import SwiftUI

struct UnavailableView: View {
    var body: some View {
        VStack {
            ContentUnavailableView("No snippets", systemImage: "swift", description: Text("You don't have any saved snippets yet."))
            
            ContentUnavailableView() {
                Label("No snippets", systemImage: "swift")
            } description: {
                Text("You don't have any saved snippets yet.")
            } actions: {
                Button("Create snippet") {
                    
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    UnavailableView()
}
