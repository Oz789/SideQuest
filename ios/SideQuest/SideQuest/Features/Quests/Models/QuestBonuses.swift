//
//  QuestBonuses.swift
//  SideQuest
//
//  Created by Osvaldo Mosso on 1/12/26.
//

import Foundation

struct QuestBonuses: Codable, Equatable {
    let multiplier: Double
    let streakBonusPercent: Int

    static let none = QuestBonuses(multiplier: 1.0, streakBonusPercent: 0)
}

// these are optional 
struct BonusEvent: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let multiplier: Double
    let start: Date
    let end: Date
}
