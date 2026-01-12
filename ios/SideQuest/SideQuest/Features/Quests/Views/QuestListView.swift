//
//  QuestListView.swift
//  SideQuest
//
//  Created by Osvaldo Mosso on 1/12/26.
//


import SwiftUI

/// Shows a list of quests using `QuestCardView`.
/// This view is intentionally thin: it renders `QuestCardModel`s from the ViewModel.
struct QuestListView: View {
    @StateObject private var viewModel = QuestListViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.questCards) { card in
                        QuestCardView(model: card) {
                            viewModel.completeQuest(id: card.id)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("SideQuests")
        }
    }
}

#Preview {
    QuestListView()
}
