//
//  QuestListViewModel.swift
//  SideQuest
//
//  Created by Osvaldo Mosso on 1/12/26.
//


import Foundation

@MainActor
final class QuestListViewModel: ObservableObject {
    @Published private(set) var questCards: [QuestCardModel] = []

    private var quests: [Quest] = [] {
        didSet { rebuildCards() }
    }

    private let mockStates: [QuestProximityState] = [.active, .near, .far]

    init() {
        self.quests = Self.seedQuests()
        rebuildCards()
    }

    // MARK: - Intent(s)

    func completeQuest(id: UUID) {
        quests.removeAll { $0.id == id }
    }
}

// MARK: - Mapping

private extension QuestListViewModel {
    func rebuildCards() {
        questCards = quests.enumerated().map { index, quest in
            let state = mockStates[index % mockStates.count]

            let distanceText: String = {
                switch state {
                case .active: return "120 m"
                case .near: return "360 m"
                case .far: return "1.2 mi"
                }
            }()

            let showsDwell = (state == .active) && quest.completionRules.minimumDwellSeconds > 0
            let dwellProgress = showsDwell ? 0.62 : 0.0
            let dwellRemaining = showsDwell ? "0:42" : ""
            let totalXP: Int = {
                switch state {
                case .active: return Int(Double(quest.baseXP) * 1.8)
                case .near: return quest.baseXP
                case .far: return Int(Double(quest.baseXP) * 3.0)
                }
            }()

            let bonusXP = max(totalXP - quest.baseXP, 0)
            let isCompleteEnabled = (state == .active) && (!showsDwell)
            let buttonTitle: String = {
                switch state {
                case .far: return "Too Far"
                case .near: return "Get Closer"
                case .active:
                    return isCompleteEnabled ? "Complete SideQuest" : "Stay Nearby"
                }
            }()

            return QuestCardModel(
                id: quest.id,
                title: quest.title,
                locationName: quest.location.name,
                proximityState: state,
                distanceText: distanceText,
                isCompleteEnabled: isCompleteEnabled,
                completeButtonTitle: buttonTitle,
                showsDwell: showsDwell,
                dwellProgress: dwellProgress,
                dwellRemainingText: dwellRemaining,
                baseXPText: "Base \(quest.baseXP) XP",
                totalXPText: "\(totalXP) XP",
                bonusXPText: bonusXP > 0 ? "+\(bonusXP) bonus" : nil
            )
        }
    }
}

// MARK: - Seed Data

private extension QuestListViewModel {
    static func seedQuests() -> [Quest] {
        [
            Quest(
                id: UUID(),
                title: "Drop off package",
                location: QuestLocation(name: "UPS Store • Main St", latitude: 0, longitude: 0),
                baseXP: 100,
                completionRules: QuestCompletionRules(completionRadiusMeters: 150, minimumDwellSeconds: 180),
                createdAt: Date()
            ),
            Quest(
                id: UUID(),
                title: "Return item",
                location: QuestLocation(name: "Target • Elm Ave", latitude: 0, longitude: 0),
                baseXP: 120,
                completionRules: QuestCompletionRules(completionRadiusMeters: 150, minimumDwellSeconds: 180),
                createdAt: Date()
            ),
            Quest(
                id: UUID(),
                title: "Buy groceries",
                location: QuestLocation(name: "Whole Foods • Downtown", latitude: 0, longitude: 0),
                baseXP: 80,
                completionRules: QuestCompletionRules(completionRadiusMeters: 150, minimumDwellSeconds: 0),
                createdAt: Date()
            )
        ]
    }
}
