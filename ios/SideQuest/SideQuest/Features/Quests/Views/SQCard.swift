//
//  SQCard.swift
//  SideQuest
//
//  Created by Osvaldo Mosso on 1/12/26.
//

//MARK: These will be redesigned
import SwiftUI

struct SQCard<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(.separator).opacity(0.35), lineWidth: 1)
            )
    }
}

#Preview {
    SQCard {
        VStack(alignment: .leading, spacing: 8) {
            Text("Card Title").font(.headline)
            Text("Card content goes here.").font(.subheadline).foregroundStyle(.secondary)
        }
    }
    .padding()
}
