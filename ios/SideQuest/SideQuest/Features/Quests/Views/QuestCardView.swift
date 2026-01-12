//
//  Views.swift
//  SideQuest
//
//  Created by Osvaldo Mosso on 1/12/26.
//

//MARK: This is just an initila demo card that will be redesigned
import SwiftUI

struct QuestCardView: View {
    let model: QuestCardModel
    let onCompleteTapped: () -> Void

    var body: some View {
        SQCard {
            VStack(alignment: .leading, spacing: 12) {
                headerRow
                metaRow
                xpRow

                if model.showsDwell {
                    dwellSection
                }

                SQPrimaryButton(
                    title: model.completeButtonTitle,
                    systemImage: model.isCompleteEnabled ? "checkmark.circle.fill" : "lock.fill",
                    isEnabled: model.isCompleteEnabled,
                    tint: model.isCompleteEnabled ? .green : .gray,
                    action: onCompleteTapped
                )
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel)
    }
}

// MARK: - Subviews

private extension QuestCardView {
    var headerRow: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(model.locationName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            SQPill(
                text: model.proximityState.displayName,
                style: pillStyle(for: model.proximityState)
            )
        }
    }

    var metaRow: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "location.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(model.distanceText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }

    var xpRow: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(model.baseXPText)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(model.totalXPText)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                if let bonus = model.bonusXPText {
                    Text(bonus)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    var dwellSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Verify you’re here")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                Text(model.dwellRemainingText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: model.dwellProgress)
        }
    }
}

// MARK: - Styling

private extension QuestCardView {
    func pillStyle(for state: QuestProximityState) -> SQPillStyle {
        switch state {
        case .far:
            return .init(background: .gray.opacity(0.25), foreground: .gray)
        case .near:
            return .init(background: .yellow.opacity(0.25), foreground: .orange)
        case .active:
            return .init(background: .green.opacity(0.25), foreground: .green)
        }
    }
}

// MARK: - Accessibility

private extension QuestCardView {
    var accessibilityLabel: String {
        var parts: [String] = []
        parts.append(model.title)
        parts.append(model.locationName)
        parts.append(model.proximityState.displayName)
        parts.append("Distance \(model.distanceText)")
        parts.append("Reward \(model.totalXPText)")
        if model.showsDwell {
            parts.append("Verification \(model.dwellRemainingText) remaining")
        }
        return parts.joined(separator: ", ")
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: 12) {
            QuestCardView(
                model: QuestCardModel(
                    id: UUID(),
                    title: "Drop off package",
                    locationName: "UPS Store • Main St",
                    proximityState: .active,
                    distanceText: "120 m",
                    isCompleteEnabled: false,
                    completeButtonTitle: "Stay Nearby",
                    showsDwell: true,
                    dwellProgress: 0.62,
                    dwellRemainingText: "0:42",
                    baseXPText: "Base 100 XP",
                    totalXPText: "180 XP",
                    bonusXPText: "+80 bonus"
                ),
                onCompleteTapped: {}
            )

        }
        .padding()
    }
}
