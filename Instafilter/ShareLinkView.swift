//
//  ShareLinkView.swift
//  Instafilter
//
//  Created by Berserk on 24/06/2024.
//

import SwiftUI

struct ShareLinkView: View {
    var body: some View {
        ShareLink(item: URL(string: "https://hackingwithswift.com")!, subject: Text("Learn Swift here"), message: Text("Check out the 100 days of SwiftUI"))
            .padding()
        ShareLink(item: URL(string: "https://hackingwithswift.com")!) {
            Label("Spread the word !", systemImage: "swift")
        }
        .padding()
        
        let rollerCoaster = Image(.rollerCoasterBitcoin)
        ShareLink(item: rollerCoaster, preview: SharePreview("Roller Coaster", image: rollerCoaster)) {
            Label("Click to share", systemImage: "swift")
        }
    }
}

#Preview {
    ShareLinkView()
}
