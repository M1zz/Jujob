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
                            Button {
                                manager.backgroundImageName = manager.localImages[row][item].accessibilityIdentifier!
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(uiImage: manager.localImages[row][item])
                                    .resizable().aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width/2 - 30, height: UIScreen.main.bounds.width/2)
                                    .clipped()
                                    .cornerRadius(20)
                            }
                            .buttonStyle(.plain)
                            // 사진에 이름이 없어 "배경이미지 3" 처럼 순서로 부른다
                            .accessibilityLabel(Text("배경이미지") + Text(verbatim: " \(row * 2 + item + 1)"))
                        })
                    }
                })
                Spacer(minLength: 80)
            }
            .padding(5)
        }
    }
}
