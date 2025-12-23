//
//  MakeTrainingListViewModel.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/12/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import RealmSwift

@MainActor
class MakeTrainingListViewModel: ObservableObject {

    @Published var isFetched = false
    @Published var dayTrainingList: [TrainingSet] = [] // 元 trainingList
    @Published var trainingMenus: [TrainingMenu] = []

    let service = MakeTrainingListService()

    init(){
        dayTrainingList = service.getTrainingLog(trainingDate: Date().slashDateString)
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
    
    /// トレーニング予定の追加
    func addTraining(menu: TrainingMenu) {
        dayTrainingList.append(
            TrainingSet(
                name: menu.name,
                category: menu.category,
                weight: 30,
                count: 10,
                set: 1
            ))
    }

    
    /// Realmへの保存
    /// - Parameters:
    ///   - date: トレーニング実施予定日時
    ///   - list: 登録するトレーニングログ
    func saveToRealm(date: Date, list: [TrainingSet]) {
        let trainingDate = date.slashDateString
        do {
            try service.saveLogToRealm(trainingDate: trainingDate, list: list)
        } catch {
            print("Saving to Realm Failed: \(error)")
        }
    }
}
