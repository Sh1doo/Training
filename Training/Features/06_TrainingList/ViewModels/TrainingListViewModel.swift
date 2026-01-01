//
//  TrainingListViewModel.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/12/22.
//

import Foundation

@MainActor
class TrainingListViewModel: ObservableObject {
    @Published var selectedSmallCategory: BodyCategory = .none
    @Published var trainingMenus: [TrainingMenu] = []
    @Published var isFavoriteArray: [String: Bool] = [:]
    @Published var isFetched = false
    
    let service = TrainingListService()
    
    // カレンダー関連
    let calendar = Calendar.current
    
    /// 選択されたカテゴリ内のメニュー一覧
    var filteredMenus: [TrainingMenu] {
        trainingMenus
            .filter { $0.category == selectedSmallCategory }
            .sorted { $0.favorite > $1.favorite }
    }

    /// トレーニングメニュー一覧をFireStoreから取得
    func fetchTrainingMenus() async {
        #if DEBUG
        self.trainingMenus = TrainingMenu.mock
        #else
        Task {
            do {
                trainingMenus = try await service.fetchTrainingMenus()
                self.isFetched = true
            } catch {
                print("Error getting documents: \(error)")
            }
        }
        #endif
    }
    
    /// 大カテゴリに応じた小カテゴリ配列を返す
    /// - Parameter category: 大カテゴリ
    /// - Returns: 小カテゴリ配列
    func SwitchCategories(category: BodyCategory) -> [BodyCategory] {
        if category == .upperbody {
            return BodyCategory.upperCategories
        } else {
            return BodyCategory.lowerCategories
        }
    }

    /// メニューのお気に入り状態切り替え
    /// - Parameter menu: トレーニングメニュー
    func toggleFavorite(menu: TrainingMenu) {

        var isFirstFavorite = false
        if ( isFavoriteArray[menu.name.rawValue] == nil ) {
            isFirstFavorite = true
        }

        // お気に入り状態の更新
        do {
            try service.updateFavoriteState(trainingName: menu.name.rawValue, isFavorite: !(isFavoriteArray[menu.name.rawValue] ?? true))
        } catch {
            print("Realm update favorite state error: \(error)")
        }
        
        // 初めての追加でなければお気に入り数は更新しない
        if !isFirstFavorite { return }
        
        // お気に入り数の更新
        Task {
            do {
                try await service.updateFavoriteCount(trainingName: menu.name.rawValue)
            } catch {
                print("Firestore update favorite count error: \(error)")
            }
        }
    }
    
    /// お気に入り状態一覧の読み込み
    ///
    /// [RealmDB] FavoriteTrainingObject
    func loadFavorite() {
        trainingMenus.forEach { menu in
            isFavoriteArray[menu.name.rawValue] = service.isFavorite(trainingName: menu.name.rawValue)
        }
    }
}
