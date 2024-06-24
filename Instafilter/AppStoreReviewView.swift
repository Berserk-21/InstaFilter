//
//  AppStoreReviewView.swift
//  Instafilter
//
//  Created by Berserk on 24/06/2024.
//

import SwiftUI
import StoreKit

struct AppStoreReviewView: View {
    
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        Button("Leave review") {
            // Prefer calling requestReview after the user has performed important tasks.
            requestReview()
        }
    }
}

#Preview {
    AppStoreReviewView()
}
