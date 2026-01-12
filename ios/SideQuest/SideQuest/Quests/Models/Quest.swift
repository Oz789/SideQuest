//
//  Untitled.swift
//  SideQuest
//
//  Created by Osvaldo Mosso on 1/12/26.
//

import Foundation

// Represents the ACTUAL errand the user wants to complete
struct Quest: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var location: QuestLocation
    var baseXP: Int
    var completionRules: QuestCompletionRules
    var createdAt: Date
}
