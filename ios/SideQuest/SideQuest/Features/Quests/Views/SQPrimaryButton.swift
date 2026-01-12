//
//  SQPrimaryButton.swift
//  SideQuest
//
//  Created by Osvaldo Mosso on 1/12/26.
//

import SwiftUI

// MARK: these will be redesigned 
struct SQPrimaryButton: View {
    let title: String
    let systemImage: String?
    let isEnabled: Bool
    let tint: Color
    let action: () -> Void

    init(
        title: String,
        systemImage: String? = nil,
        isEnabled: Bool = true,
        tint: Color = .accentColor,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isEnabled = isEnabled
        self.tint = tint
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.85)
        .accessibilityHint(isEnabled ? "Activates the action." : "Disabled until requirements are met.")
    }
}

#Preview {
    VStack(spacing: 12) {
        SQPrimaryButton(title: "Complete SideQuest", systemImage: "checkmark.circle.fill", tint: .green) {}
        SQPrimaryButton(title: "Get Closer", systemImage: "lock.fill", isEnabled: false, tint: .gray) {}
    }
    .padding()
}
