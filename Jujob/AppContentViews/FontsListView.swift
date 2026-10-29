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
                ForEach(0..<manager.fonts.count, content: { index in
                    Button {
                        presentation.wrappedValue.dismiss()
                        manager.selectedFont = manager.fonts[index]
                    } label: {
                        HStack {
                            Text(manager.fonts[index]).font(.custom(manager.fonts[index], size: 22, relativeTo: .title2))
                            Spacer()
                            Image(systemName: manager.selectedFont == manager.fonts[index] ? "largecircle.fill.circle" : "circle")
                                .resizable().aspectRatio(contentMode: .fit)
                                .frame(width: 25)
                                .accessibilityHidden(true)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(manager.selectedFont == manager.fonts[index] ? .isSelected : [])
                })
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
