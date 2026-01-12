//
//  QuestCard.swift
//  SideQuest
//
//  Created by Osvaldo Mosso on 1/12/26.
//

import Foundation


struct QuestCardModel: Identifiable, Equatable {
    let id: UUID

    // Core display
    let title: String
    let locationName: String

    // Proximity display
    let proximityState: QuestProximityState
    let distanceText: String

    // Completion display
    let isCompleteEnabled: Bool
    let completeButtonTitle: String

    // Dwell display (only relevant if proximityState == .active and dwell is required)
    let showsDwell: Bool
    let dwellProgress: Double
    let dwellRemainingText: String

    // XP display
    let baseXPText: String        
    let totalXPText: String
    let bonusXPText: String?
}

