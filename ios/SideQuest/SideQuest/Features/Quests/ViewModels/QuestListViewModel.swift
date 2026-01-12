//
//  QuestListViewModel.swift
//  SideQuest
//
//  Created by Osvaldo Mosso on 1/12/26.
//


import Foundation

@MainActor
final class QuestListViewModel: ObservableObject {

    // MARK: - Published Output (for Views)

    @Published private(set) var questCards: [QuestCardModel] = []

    // MARK: - Source of Truth

    private var quests: [Quest] = [] {
        didSet { rebuildCards() }
    }

    // Temporary: lets you see the UI pipeline without location services.
    // Later this gets replaced by real proximity + dwell + bonuses engines.
    private let mockStates: [QuestProximityState] = [.active, .near, .far]

    init() {
        // For now, seed some example data so the screen works immediately.
        self.quests = Self.seedQuests()
        rebuildCards()
    }

    // MARK: - Intent(s)

    func completeQuest(id: UUID) {
        // For now: remove it from the list.
        // Later: mark as completed in persistence + trigger XP award, streak updates, etc.
        quests.removeAll { $0.id == id }
    }
}

// MARK: - Mapping (Quest -> QuestCardModel)

private extension QuestListViewModel {
    func rebuildCards() {
        questCards = quests.enumerated().map { index, quest in
            let state = mockStates[index % mockStates.count]

            // Fake distance text just so UI looks real; later computed from GPS.
            let distanceText: String = {
                switch state {
                case .active: return "120 m"
                case .near: return "360 m"
                case .far: return "1.2 mi"
                }
            }()

            // Fake dwell values for previewing the locked/ready behavior.
            let showsDwell = (state == .active) && quest.completionRules.minimumDwellSeconds > 0
            let dwellProgress = showsDwell ? 0.62 : 0.0
            let dwellRemaining = showsDwell ? "0:42" : ""

            // Temporary bonuses display (replace with Bonus engine later)
            let totalXP: Int = {
                switch state {
                case .active: return Int(Double(quest.baseXP) * 1.8)   // pretend bonus
                case .near: return quest.baseXP
                case .far: return Int(Double(quest.baseXP) * 3.0)     // pretend triple
                }
            }()

            let bonusXP = max(totalXP - quest.baseXP, 0)

            // Button states mimic your rules:
            // - far/near locked
            // - active locked until dwell is satisfied (we're showing it locked here)
            let isCompleteEnabled = (state == .active) && (!showsDwell) // if dwell required, keep locked in mock
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
