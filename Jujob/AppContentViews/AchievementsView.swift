//
//  AchievementsView.swift
//  Jujob
//
//  Created by hyunho lee on 2024/11/24.
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var preferencesManager = UserPreferencesManager.shared
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.1350388601, green: 0.1350388601, blue: 0.1350388601, alpha: 1))
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 25) {
                        StreakSection
                        AchievementsSection
                    }
                    .padding()
                }
            }
            .navigationTitle("나의 기록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    private var StreakSection: some View {
        VStack(spacing: 15) {
            Text("연속 기록")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 20) {
                StreakCard(
                    title: "현재 연속",
                    value: "\(preferencesManager.dailyStreak.currentStreak)",
                    icon: "flame.fill",
                    color: .orange
                )

                StreakCard(
                    title: "최고 기록",
                    value: "\(preferencesManager.dailyStreak.longestStreak)",
                    icon: "star.fill",
                    color: .yellow
                )
            }

            StreakCard(
                title: "총 확인 일수",
                value: "\(preferencesManager.dailyStreak.totalDaysViewed)",
                icon: "calendar",
                color: .blue
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
        )
    }

    private var AchievementsSection: some View {
        VStack(spacing: 15) {
            Text("업적")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(preferencesManager.achievements) { achievement in
                AchievementCard(achievement: achievement)
            }
        }
    }
}

struct StreakCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(#colorLiteral(red: 0.1764705926, green: 0.1921568662, blue: 0.2078431398, alpha: 1)))
        )
    }
}

struct AchievementCard: View {
    let achievement: Achievement

    private var formattedDate: String? {
        guard let date = achievement.unlockedDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)

                Image(systemName: achievement.isUnlocked ? "trophy.fill" : "lock.fill")
                    .font(.system(size: 28))
                    .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(achievement.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(achievement.isUnlocked ? .white : .gray)

                Text(achievement.description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                if achievement.isUnlocked, let date = formattedDate {
                    Text(date)
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                }
            }

            Spacer()

            if !achievement.isUnlocked {
                Text("\(achievement.requirement)일")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(achievement.isUnlocked ? Color.yellow.opacity(0.5) : Color.clear, lineWidth: 2)
        )
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}
