//
//  TrainingListViewModel.swift
//  Training
//
//  Created by 冨岡獅堂 on 2025/12/22.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import RealmSwift

class TrainingListViewModel: ObservableObject {
    @Published var selectedSmallCategory: BodyCategory = .none
    @Published var dayTrainingList: [TrainingSet] = []
    @Published var trainingMenus: [TrainingMenu] = []
    @Published var isFavoriteArray: [String: Bool] = [:]
    @Published var isFetched = false
    
    let service = MakeTrainingListService()
    
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

    // トレーニングログをRealmに書き込む
//    func writeTrainingLogRealm(date: Date, trainingData: [TrainingRealmObject]){
//        try! realm.write {
//            realm.add(TrainingLogRealmObject(trainingDate: date, trainingData: trainingData, mark: categoryToMark(category: trainingList.last!.category)))
//        }
//    }
//    
    // TraininRealmObjectをListedTrainingに変換
//    func convertToListedTraining(from realmObject: TrainingRealmObject) -> ListedTraining {
//        // [FindHere] トレーニング名で[trainingMenus]を検索してcategoryを入手（一応実装済み）
//        var trainingCategory: String = "missing"
//        trainingMenus.filter { $0.name == realmObject.name }.forEach { filteredMenu in
//            trainingCategory = filteredMenu.category
//        }
//        
//        return ListedTraining(name: realmObject.name, category: trainingCategory, weight: realmObject.weight, count: realmObject.count, set: realmObject.set)
//    }
    
    // [TraininRealmObject]を[ListedTraining]に変換
//    func convertToListedTraining(from realmObject: RealmSwift.List<TrainingSetObject>) -> [TrainingSet] {
//        var listedTrainingArray: [TrainingSet] = []
//        realmObject.forEach { obj in
//            listedTrainingArray.append(convertToListedTraining(from: obj))
//        }
//        return listedTrainingArray
//    }
    
    // DateをDateComponent[年月日]に変換
//    func getDateComponents(date: Date) -> DateComponents {
//        return calendar.dateComponents([.year, .month, .day], from: date)
//    }
    
    // [TrainingSet]を[TraininSetObject]に変換
    // func convertToTrainingRealmObject(from listedTraining: [TrainingSet]) -> [TrainingSetObject] {
    //     var newConvertedArray: [TrainingSetObject] = []
    //     for training in listedTraining {
    //         newConvertedArray.append(TrainingSetObject(name: training.name, weight: training.weight, count: training.count, set: training.set))
    //     }
    //     return newConvertedArray
    // }
    
    // trainingListをeditingDateのものに更新する
//    func listUpdate(editingDate: Date) {
//        trainingList = getListedTrainingFromRealm(dateComponents: getDateComponents(date: editingDate))
//    }
    
    // 指定した日付のTrainingListをRealmから変換して返す
    // 指定した日付で探してなければから配列を返す
//    func getListedTrainingFromRealm(dateComponents: DateComponents) -> [ListedTraining] {
//        let returnArray: [ListedTraining] = []
//        if let filteredFromRealm = trainingListFromRealm.where({$0.year == dateComponents.year ?? 0 && $0.month == dateComponents.month ?? 0 && $0.day == dateComponents.day ?? 0}).first {
//            return convertToListedTraining(from: filteredFromRealm.trainingData)
//        }
//        return returnArray
//    }
    
    //指定した日付のTrainingLogを取得する
//    func getTrainingLog(dateComponents: DateComponents) -> TrainingLogObject {
//        if let filteredFromRealm = trainingListFromRealm.where({$0.year == dateComponents.year ?? 0 && $0.month == dateComponents.month ?? 0 && $0.day == dateComponents.day ?? 0}).first {
//            return filteredFromRealm
//        }
//        //指定した日付の記録がない
//        return TrainingLogRealmObject(trainingDate: calendar.date(from: dateComponents)!, trainingData: [], mark: -1)
//    }
    
    //[FindHere]指定した年月のすべての日付にrealmで検索して，なんか配列にぶち込む
    
    

    // Likeボタンが押された時favoriteをトグルする
//    func toggleFavorite(menu: TrainingMenu) {
//        do {
//            if let existingItem = favoriteFromRealm.where({$0.name == menu.name}).first {
//                isFavoriteArray[menu.name] = !(existingItem.isFavorite)
//                try realm.write {
//                    existingItem.isFavorite =  !(existingItem.isFavorite)
//                }
//            } else { // RealmにFavorite記録が存在しない(初めてのFavorite)
//                isFavoriteArray[menu.name] = true
//                try realm.write {
//                    let realmObject = FavoriteRealmObject(name: menu.name, isFavorite: true)
//                    realm.add(realmObject)
//                }
//
//                // Firebase Firestoreに書き込み (以降事実上クライアントがtoggleしても意味なし)
//                Task {
//                    if let id = menu.id {
//                        let document = db.collection("training-menu").document(id)
//                        if let data = try await document.getDocument().data() {
//                            if let fetchedFavorite = data["favorite"] as? Int {
//                                try await document.updateData([
//                                    "favorite": fetchedFavorite + 1
//                                ])
//                            }
//                        }
//                    }
//                }
//            }
//        } catch {
//            print("toggle failed. error occured.")
//        }
//    }
    
    // isFavoriteArrayに各MenuのisFavorite(Bool)を書き込む
    func loadFavorite() {
        trainingMenus.forEach { menu in
            isFavoriteArray[menu.name.rawValue] = service.isFavorite(trainingName: menu.name.rawValue)
        }
    }
}
