//
//  TagButton.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/12/31.
//

import SwiftUI

struct TagButton: View {
    let title: String
    @Binding var isSelected: Bool

    var action: () -> Void

    var body: some View {
        Button(action: {
            withAnimation { isSelected.toggle() }
            action()
        }) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 12))
            }
            .padding(.horizontal, 8)
            .frame(height: 24)
            .foregroundColor(.white)
            .background(isSelected ? Color.green : Color.gray)
            .cornerRadius(5)
        }
    }
}
