//
//  FontsListView.swift
//  Quotes
//
//  Created by Apps4World on 10/10/20.
//

import SwiftUI

/// Shows a list of fonts for the user to select from
struct FontsListView: View {
    @ObservedObject var manager: WidgetManager
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            List {
                ForEach(manager.fonts, id: \.self) { font in
                    let locked = manager.isFontLocked(font)
                    let selected = manager.displayFont == font
                    Button {
                        if locked {
                            // 앞 3종 뒤는 Pro — 글꼴 목록을 페이월로 바꿔 띄운다 (미리보기를 이 글꼴로 그린다)
                            JujobPro.shared.present(.font(font))
                        } else {
                            presentation.wrappedValue.dismiss()
                            manager.selectedFont = font
                        }
                    } label: {
                        HStack {
                            Text(font).font(.custom(font, size: 22, relativeTo: .title2))
                            Spacer()
                            if locked {
                                ProBadge()
                            } else {
                                Image(systemName: selected ? "largecircle.fill.circle" : "circle")
                                    .resizable().aspectRatio(contentMode: .fit)
                                    .frame(width: 25)
                                    .accessibilityHidden(true)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(selected ? .isSelected : [])
                }
            }
            .environment(\.defaultMinListRowHeight, 50)
            .navigationTitle("Select a font")
        }
    }
}

// MARK: - Render preview UI
struct FontsListView_Previews: PreviewProvider {
    static var previews: some View {
        FontsListView(manager: WidgetManager())
    }
}
