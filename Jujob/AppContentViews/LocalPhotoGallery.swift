//
//  LocalPhotoGallery.swift
//  Quotes
//
//  Created by Apps4World on 10/8/20.
//

import SwiftUI

/// Shows a library of local images
struct LocalPhotoGallery: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var manager: WidgetManager
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 20) {
                ForEach(0..<manager.localImages.count, id: \.self, content: { row in
                    HStack(spacing: 20) {
                        ForEach(0..<manager.localImages[row].count, id: \.self, content: { item in
                            Image(uiImage: manager.localImages[row][item])
                                .resizable().aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width/2 - 30, height: UIScreen.main.bounds.width/2)
                                .clipped()
                                .cornerRadius(20)
                                .onTapGesture(perform: {
                                    manager.backgroundImageName = manager.localImages[row][item].accessibilityIdentifier!
                                    presentationMode.wrappedValue.dismiss()
                                })
                        })
                    }
                })
                Spacer(minLength: 80)
            }
            .padding(5)
        }
    }
}
