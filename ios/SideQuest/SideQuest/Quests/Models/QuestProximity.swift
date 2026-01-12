//
//  QuestProximity.swift
//  SideQuest
//
//  Created by Osvaldo Mosso on 1/12/26.
//

import Foundation

// MARK: - Location and Proxy
struct QuestLocation: Codable, Equatable {
    let name: String
    let latitude: Double
    let longitude: Double
}

enum QuestProximityState: String, Codable, Equatable {
    case far
    case near
    case active

    var displayName: String {
        switch self {
        case .far: return "Too Far"
        case .near: return "Nearby"
        case .active: return "Ready"
        }
    }
}

// MARK: - Completion Rules based on location and proxy

struct QuestCompletionRules: Codable, Equatable {
    let completionRadiusMeters: Double
    let minimumDwellSeconds: Int
}
