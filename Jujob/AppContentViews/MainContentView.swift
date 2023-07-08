//
//  MainContentView.swift
//  Quotes
//
//  Created by Apps4World on 10/8/20.
//

import SwiftUI

/// Custom presentation mode
enum PresentationType: Identifiable {
    case photoPicker
    case fontPicker
    case categoryPicker
    case tutorial
    case purchases
    var id: Int { hashValue }
}

/// Guide alerts
enum GuideAlert: String, Identifiable {
    case deleteHolidayPhoto
    case deleteCustomWidget
    var id: Int { hashValue }
}

/// Main screen for the app
struct MainContentView: View {
    @ObservedObject var manager: WidgetManager
    @State private var actionSheet: PresentationType?
    @State private var guideAlert: GuideAlert?
    private let previewSize = UIScreen.main.bounds.width/1.3
    
    var body: some View {
        ZStack {
            //            Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)).edgesIgnoringSafeArea(.all)
            TutorialButton
            VStack(alignment: .center) {
                HeaderView.padding()
                ScrollView {
                    LazyHStack {
                        WidgetSizePreview(manager: manager)
                    }
                }
                EditingToolsView.padding(.top, 10)
            }
        }
        .sheet(item: $actionSheet, content: { item in
            switch item {
            case .photoPicker:
                LocalPhotoGallery(manager: manager)
            case .tutorial:
                TutorialContentView()
            case .fontPicker:
                FontsListView(manager: manager)
            case .categoryPicker:
                CategoriesListView(manager: manager)
            case .purchases:
                Text("premium")
            }
        })
        .onAppear {
            primaryColor = manager.gradientColors.first!
            secondaryColor = manager.gradientColors.last!
            textAlignmentIndex = manager.contentAlignment.indexValue
            refreshIntervalIndex = manager.refreshInterval.indexValue
        }
    }
    
    /// Tutorial button
    private var TutorialButton: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    actionSheet = .tutorial
                }, label: {
                    Image(systemName: "questionmark.square.dashed").resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                })
            }
            .padding()
            Spacer()
        }
    }
    
    /// Main header text view
    private var HeaderView: some View {
        VStack {
            Text("오늘의 주접")
                .font(.largeTitle).bold()
            Text("왜 우리애 기죽이고 그래요!\n스스로를 격려해 줄 한마디를 골라주세요!")
                .font(.headline)
                .foregroundColor(.secondary)
        }.multilineTextAlignment(.center)
    }
    
    /// Editing tools container view
    private var EditingToolsView: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Spacer(minLength: 30)
                BackgroundGradient
                FontStyle
                QuoteSettings
                Spacer(minLength: 50)
            }
        }
        .padding([.leading, .trailing], 30)
        .foregroundColor(.white)
        .background(RoundedCorner(radius: 35, corners: [.topLeft, .topRight]).foregroundColor(Color(#colorLiteral(red: 0.1350388601, green: 0.1350388601, blue: 0.1350388601, alpha: 1))))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // MARK: - Background Gradient and Image
    @State private var primaryColor: Color = Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
    @State private var secondaryColor: Color = Color(#colorLiteral(red: 0.9529411793, green: 0.5576358299, blue: 0.1333333403, alpha: 1))
    private var BackgroundGradient: some View {
        VStack {
            createSectionHeader(title: "배경색상")
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    ColorPicker("그라데이션 색", selection: $primaryColor).onChange(of: primaryColor, perform: { value in
                        manager.selectedBackgroundColor = [value, secondaryColor]
                    })
                    ColorPicker("", selection: $secondaryColor).labelsHidden().onChange(of: secondaryColor, perform: { value in
                        manager.selectedBackgroundColor = [primaryColor, value]
                    })
                }
                Divider().background(Color.white)
                HStack {
                    Text("배경이미지")
                    Spacer()
                    
                    Button(action: {
                        manager.backgroundImageName = ""
                    }, label: {
                        Image(systemName: "trash.circle").resizable().aspectRatio(contentMode: .fit)
                    })
                    .frame(width: 25, height: 25)
                    .padding(.trailing, 15)
                    
                    Button(action: {
                        
                        actionSheet = .photoPicker
                        //                        if manager.isPremiumUser {
                        //
                        //                        } else {
                        //                            actionSheet = .purchases
                        //                        }
                    }, label: {
                        VStack {
                            if !manager.backgroundImageName.isEmpty {
                                Image(uiImage: UIImage(named: manager.backgroundImageName)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(10)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        .frame(width: 45, height: 30)
                        .contentShape(Rectangle()).clipped()
                    })
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))))
        }
    }
    
    // MARK: - Font Style, Text Color and Text Alignment
    @State private var textAlignmentIndex: Int = 1
    private var FontStyle: some View {
        VStack {
            createSectionHeader(title: "폰트 스타일")
            VStack(spacing: 20) {
                HStack {
                    Text("폰트")
                    Spacer()
                    Button(action: {
                        actionSheet = .fontPicker
                    }, label: {
                        Text(manager.selectedFont).bold()
                    })
                }
                Divider().background(Color.white)
                HStack {
                    Text("행간")
                    Spacer()
                        .frame(width: 70)
                    Slider(value: $manager.selectedTextLineSpacing, in: 0...40)
                        
                }
                Divider().background(Color.white)
                ColorPicker("글자 색", selection: $manager.selectedTextColor)
                Divider().background(Color.white)
                Picker("", selection: $textAlignmentIndex, content: {
                    ForEach(0..<TextAlignment.allCases.count, content: { index in
                        Text(index == 1 ? "중앙" : index == 0 ? "왼쪽" : "오른쪽")
                    })
                })
                .onChange(of: textAlignmentIndex, perform: { value in
                    manager.contentAlignment = value == 0 ? .leading : value == 1 ? .center : .trailing
                })
                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color(#colorLiteral(red: 0.6965066386, green: 0.6965066386, blue: 0.6965066386, alpha: 1))))
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))))
        }
        .padding(.top, 30)
    }
    
    // MARK: - Show Author, Change quote category and other settings
    @State private var refreshIntervalIndex: Int = 0
    private var QuoteSettings: some View {
        VStack {
            createSectionHeader(title: "설정")
            VStack(spacing: 20) {
                //                HStack {
                //                    Text("카테고리")
                //                    Spacer()
                //                    Button(action: {
                //                        actionSheet = .categoryPicker
                //                    }, label: {
                //                        Text(manager.currentQuoteCategory.rawValue.capitalized).bold()
                //                    })
                //                }
                //                Divider().background(Color.white)
                Toggle("제안한 사람", isOn: $manager.showQuoteAuthor)
                Divider().background(Color.white)
                VStack {
                    HStack {
                        Text("새로고침 주기")
                        Spacer()
                    }
                    Picker("", selection: $refreshIntervalIndex, content: {
                        ForEach(0..<RefreshInterval.allCases.count, content: { index in
                            Text(RefreshInterval.allCases[index].rawValue)
                        })
                    })
                    .onChange(of: textAlignmentIndex, perform: { value in
                        manager.contentAlignment = value == 0 ? .leading : value == 1 ? .center : .trailing
                    })
                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color(#colorLiteral(red: 0.6965066386, green: 0.6965066386, blue: 0.6965066386, alpha: 1))))
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()
                }
                Divider().background(Color.white)
                Button(action: {
                    manager.loadNextQuote()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).foregroundColor(.blue)
                        Text("다음 주접보기").bold().padding()
                    }
                })
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))))
        }
        .padding(.top, 30)
    }
}

// MARK: - Helper functions
extension MainContentView {
    private func createSectionHeader(title: String) -> some View {
        HStack {
            Text(title.uppercased()).font(.system(size: 15)).fontWeight(.bold).padding(.leading, 15)
            Spacer()
        }
        .foregroundColor(Color(#colorLiteral(red: 0.9488552213, green: 0.9487094283, blue: 0.9693081975, alpha: 1)))
    }
}

// MARK: - Render preview UI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainContentView(manager: WidgetManager())
            MainContentView(manager: WidgetManager())
                .previewDevice("iPhone 7")
        }
    }
}
