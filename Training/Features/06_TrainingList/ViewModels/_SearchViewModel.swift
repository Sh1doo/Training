//
//  _SearchViewModel.swift
//  Training
//
//  Created by 冨岡獅堂 on 2026/01/01.
//

import SwiftUI

@MainActor
class _SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedTags: [CategoryTag] = []
    @Published var isSelected: [Bool] = Array(repeating: false, count: CategoryTag.allCases.count)

    /// 検索条件の追加・削除を切り替える
    /// - Parameter tag: タグ
    func toggleTag(_ tag: CategoryTag) {
        if let index = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
        
        // self.searchText = selectedTagsText()
    }

    private func selectedTagsText() -> String {
        // 小カテゴリが選択された場合, 大カテゴリを除外する部分もここで対応
        return selectedTags.map { $0.localized }.joined(separator: ", ")
    }

}
