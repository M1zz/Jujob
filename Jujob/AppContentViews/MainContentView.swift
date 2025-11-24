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
    case moodSelection
    case favorites
    case history
    case achievements
    case userNameSetting
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
            VStack(alignment: .center, spacing: 0) {
                HeaderView
                    .padding(.horizontal)
                    .padding(.top)

                Spacer()

                // 프리뷰를 가운데 배치
                WidgetSizePreview(manager: manager)
                    .frame(height: UIScreen.main.bounds.height * 0.3)

                Spacer()

                EditingToolsView
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
            case .moodSelection:
                MoodSelectionView(manager: manager)
            case .favorites:
                FavoritesView(widgetManager: manager)
            case .history:
                HistoryView(widgetManager: manager)
            case .achievements:
                AchievementsView()
            case .userNameSetting:
                UserNameSettingView()
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
                    Image(systemName: "info.circle")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
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
                NewFeatures
                Spacer(minLength: 40)
                DetailedSettings
                Spacer(minLength: 50)
            }
        }
        .padding([.leading, .trailing], 30)
        .foregroundColor(.white)
        .background(RoundedCorner(radius: 35, corners: [.topLeft, .topRight]).foregroundColor(Color(#colorLiteral(red: 0.1350388601, green: 0.1350388601, blue: 0.1350388601, alpha: 1))))
        .edgesIgnoringSafeArea(.bottom)
    }

    // MARK: - New Features Section
    private var NewFeatures: some View {
        VStack {
            // 헤더 + 카테고리 배지
            HStack {
                Text("내 주접 관리".uppercased())
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .padding(.leading, 15)
                    .foregroundColor(Color(#colorLiteral(red: 0.9488552213, green: 0.9487094283, blue: 0.9693081975, alpha: 1)))

                Spacer()

                // 카테고리 배지
                HStack(spacing: 6) {
                    Text(manager.currentQuoteCategory.emoji)
                        .font(.system(size: 14))
                    Text(manager.currentQuoteCategory.displayName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.15))
                )
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .padding(.trailing, 15)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                FeatureButton(
                    icon: "face.smiling",
                    title: "기분 선택",
                    color: .blue
                ) {
                    actionSheet = .moodSelection
                }

                FeatureButton(
                    icon: "star.fill",
                    title: "즐겨찾기",
                    color: .yellow
                ) {
                    actionSheet = .favorites
                }

                FeatureButton(
                    icon: "clock.fill",
                    title: "히스토리",
                    color: .green
                ) {
                    actionSheet = .history
                }

                FeatureButton(
                    icon: "trophy.fill",
                    title: "나의 기록",
                    color: .orange
                ) {
                    actionSheet = .achievements
                }

                FeatureButton(
                    icon: "person.circle",
                    title: "이름 설정",
                    color: .purple
                ) {
                    actionSheet = .userNameSetting
                }

                FeatureButton(
                    icon: "arrow.right.circle.fill",
                    title: "다음 주접",
                    color: .cyan
                ) {
                    manager.loadNextQuote()
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))))
        }
    }

    // MARK: - Detailed Settings Section
    private var DetailedSettings: some View {
        VStack(spacing: 30) {
            VStack {
                createSectionHeader(title: "상세 설정")
                Text("위젯 모양과 글꼴을 세밀하게 조정하세요")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .padding(.top, 2)
            }

            BackgroundGradient
            FontStyle
            QuoteSettings
        }
    }

    // MARK: - Background Gradient and Image
    @State private var primaryColor: Color = Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
    @State private var secondaryColor: Color = Color(#colorLiteral(red: 0.9529411793, green: 0.5576358299, blue: 0.1333333403, alpha: 1))
    private var BackgroundGradient: some View {
        VStack {
            HStack {
                Text("배경 설정")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 10)

            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    ColorPicker("그라데이션 색", selection: $primaryColor).onChange(of: primaryColor) {  _, newValue in
                        manager.selectedBackgroundColor = [newValue, secondaryColor]
                    }
                    ColorPicker("", selection: $secondaryColor).labelsHidden().onChange(of: secondaryColor) { _, newValue in
                        manager.selectedBackgroundColor = [primaryColor, newValue]
                    }
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
            HStack {
                Text("폰트 설정")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 10)

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
                TextAlignmentPicker(selection: $textAlignmentIndex, manager: manager)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))))
        }
    }

    // MARK: - Show Author, Change quote category and other settings
    @State private var refreshIntervalIndex: Int = 0
    private var QuoteSettings: some View {
        VStack {
            HStack {
                Text("위젯 설정")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 10)

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
                    .onChange(of: refreshIntervalIndex) { _, newValue in
                        manager.refreshInterval = RefreshInterval.allCases[newValue]
                    }
                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color(#colorLiteral(red: 0.6965066386, green: 0.6965066386, blue: 0.6965066386, alpha: 1))))
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))))
        }
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

// MARK: - Feature Button Component
struct FeatureButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)

                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(#colorLiteral(red: 0.1764705926, green: 0.1921568662, blue: 0.2078431398, alpha: 1)))
            )
        }
    }
}

// MARK: - Text Alignment Picker Component
struct TextAlignmentPicker: View {
    @Binding var selection: Int
    @ObservedObject var manager: WidgetManager

    private let bgColor = Color(#colorLiteral(red: 0.6965066386, green: 0.6965066386, blue: 0.6965066386, alpha: 1))

    var body: some View {
        VStack {
            Picker("", selection: $selection) {
                Text("왼쪽").tag(0)
                Text("중앙").tag(1)
                Text("오른쪽").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(bgColor))
            .onChange(of: selection, perform: { value in
                manager.contentAlignment = value == 0 ? .leading : value == 1 ? .center : .trailing
            })
        }
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
