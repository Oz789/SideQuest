//
//  SQPillStyle.swift
//  SideQuest
//
//  Created by Osvaldo Mosso on 1/12/26.
//

//MARK: These will be redesigned
import SwiftUI

struct SQPillStyle: Equatable {
    let background: Color
    let foreground: Color
}

struct SQPill: View {
    let text: String
    let style: SQPillStyle

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(style.background)
            .foregroundStyle(style.foreground)
            .clipShape(Capsule())
            .accessibilityLabel(text)
    }
}

#Preview {
    VStack(spacing: 10) {
        SQPill(text: "Too Far", style: .init(background: .gray.opacity(0.25), foreground: .gray))
        SQPill(text: "Nearby", style: .init(background: .yellow.opacity(0.25), foreground: .orange))
        SQPill(text: "Ready", style: .init(background: .green.opacity(0.25), foreground: .green))
    }
    .padding()
}
