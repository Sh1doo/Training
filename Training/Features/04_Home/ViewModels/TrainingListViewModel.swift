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
    @Published var trainingMenus: [TrainingMenu] = []
    @Published var isFavoriteArray: [String: Bool] = [:]
    
    @Published var isFetched = false
    @Published var trainingList: [ListedTraining] = []
    
    // カレンダー関連
    let calendar = Calendar.current
    
    // Realm 「Result」
    private var trainingListFromRealm: Results<TrainingLogRealmObject> = realm.objects(TrainingLogRealmObject.self)
    private var favoriteFromRealm: Results<FavoriteRealmObject> = realm.objects(FavoriteRealmObject.self)
    
    //これいるの？
    @Published var currentAddedTraining: ListedTraining = ListedTraining(name: "none", category: "none", weight: 0, count: 0, set: 1)
    
    let maxWeight = 120
    let maxCount = 60
    
    //カテゴリを上半身と下半身に大別する
    let bigCategories = [
        LocalizedText(english: "upperbody", japanese: "上半身"),
        LocalizedText(english: "lowerbody", japanese: "下半身")
    ]
    
    //上半身に分類した体の部位
    let upperCategories = [
        LocalizedText(english: "chest", japanese: "胸"),
        LocalizedText(english: "arm", japanese: "腕"),
        LocalizedText(english: "abs", japanese: "腹"),
        LocalizedText(english: "shoulder", japanese: "肩"),
        LocalizedText(english: "back", japanese: "背中")
    ]
    
    //下半身に分類した体の部位
    let lowerCategories = [
        LocalizedText(english: "thigh", japanese: "太もも"),
        LocalizedText(english: "calf", japanese: "ふくらはぎ"),
        LocalizedText(english: "gluteal", japanese: "臀部"),
        LocalizedText(english: "hip", japanese: "股関節")
    ]
    
    //データベースの初期化
    // var db = Firestore.firestore()
    
    init(){
        //とりあえず当日のリストを読み込む
        trainingList = getListedTrainingFromRealm(dateComponents: getDateComponents(date: Date()))
    }
    
    //トレーニングメニューをFirestoreからフェッチする
    func fetchTrainingMenus() async{
        #if DEBUG
        self.trainingMenus = [TrainingMenu(favorite: 0, name: "test", category: "chest", pof: "pof", description: "description"),
        TrainingMenu(favorite: 0, name: "test", category: "arm", pof: "pof", description: "description")]
        #else
        do {
            let snapshot = try await db.collection("training-menu").getDocuments()
            for document in snapshot.documents {
                if let trainingMenu = try?document.data(as: TrainingMenu.self){
                    DispatchQueue.main.async {
                        self.trainingMenus.append(trainingMenu)
                    }
                }
            }
            DispatchQueue.main.async {
                self.isFetched = true
            }
        } catch {
            print("Error getting documents: \(error)")
        }
        #endif
    }
    
    func SelectCategories(category: String) -> [LocalizedText] {
        if category == "upperbody" {
            return self.upperCategories
        } else {
            return self.lowerCategories
        }
    }
    
    // トレーニングリストに追加
    func addTrainingList(menu: TrainingMenu) {
        trainingList.append(ListedTraining(name: menu.name, category: menu.category, weight: 30, count: 10, set: 1))
        currentAddedTraining = trainingList.last ?? ListedTraining(name:"none", category:"none", weight:0, count:0, set: 1)
    }
    
    // トレーニングログをRealmに書き込む
    func writeTrainingLogRealm(date: Date, trainingData: [TrainingRealmObject]){
        try! realm.write {
            realm.add(TrainingLogRealmObject(trainingDate: date, trainingData: trainingData, mark: categoryToMark(category: trainingList.last!.category)))
        }
    }
    
    // TraininRealmObjectをListedTrainingに変換
    func convertToListedTraining(from realmObject: TrainingRealmObject) -> ListedTraining {
        // [FindHere] トレーニング名で[trainingMenus]を検索してcategoryを入手（一応実装済み）
        var trainingCategory: String = "missing"
        trainingMenus.filter { $0.name == realmObject.name }.forEach { filteredMenu in
            trainingCategory = filteredMenu.category
        }
        
        return ListedTraining(name: realmObject.name, category: trainingCategory, weight: realmObject.weight, count: realmObject.count, set: realmObject.set)
    }
    
    // [TraininRealmObject]を[ListedTraining]に変換
    func convertToListedTraining(from realmObject: RealmSwift.List<TrainingRealmObject>) -> [ListedTraining] {
        var listedTrainingArray: [ListedTraining] = []
        realmObject.forEach { obj in
            listedTrainingArray.append(convertToListedTraining(from: obj))
        }
        return listedTrainingArray
    }
    
    // DateをDateComponent[年月日]に変換
    func getDateComponents(date: Date) -> DateComponents {
        return calendar.dateComponents([.year, .month, .day], from: date)
    }
    
    // [ListedTraining]を[TraininRealmObject]に変換
    func convertToTrainingRealmObject(from listedTraining: [ListedTraining]) -> [TrainingRealmObject] {
        var newConvertedArray: [TrainingRealmObject] = []
        for training in listedTraining {
            newConvertedArray.append(TrainingRealmObject(name: training.name, weight: training.weight, count: training.count, set: training.set))
        }
        return newConvertedArray
    }
    
    // trainingListをeditingDateのものに更新する
    func listUpdate(editingDate: Date) {
        trainingList = getListedTrainingFromRealm(dateComponents: getDateComponents(date: editingDate))
    }
    
    // 指定した日付のTrainingListをRealmから変換して返す
    // 指定した日付で探してなければから配列を返す
    func getListedTrainingFromRealm(dateComponents: DateComponents) -> [ListedTraining] {
        let returnArray: [ListedTraining] = []
        if let filteredFromRealm = trainingListFromRealm.where({$0.year == dateComponents.year ?? 0 && $0.month == dateComponents.month ?? 0 && $0.day == dateComponents.day ?? 0}).first {
            return convertToListedTraining(from: filteredFromRealm.trainingData)
        }
        return returnArray
    }
    
    //指定した日付のTrainingLogを取得する
    func getTrainingLog(dateComponents: DateComponents) -> TrainingLogRealmObject {
        if let filteredFromRealm = trainingListFromRealm.where({$0.year == dateComponents.year ?? 0 && $0.month == dateComponents.month ?? 0 && $0.day == dateComponents.day ?? 0}).first {
            return filteredFromRealm
        }
        //指定した日付の記録がない
        return TrainingLogRealmObject(trainingDate: calendar.date(from: dateComponents)!, trainingData: [], mark: -1)
    }
    
    //[FindHere]指定した年月のすべての日付にrealmで検索して，なんか配列にぶち込む
    
    // Realmへの保存
    func saveToRealm(date: Date, list: [ListedTraining]) {
        // 年月日以外の情報を落として再度Dateに変換
        if let trainingDate: Date = calendar.date(from: getDateComponents(date: date)) {
            //[FindHere]もしかしたらResultを直接編集できるかも
            if let existingItem = realm.objects(TrainingLogRealmObject.self).filter("trainingDate == %@", trainingDate).first {
                //すでに同日の予定がrealmに追加されている。
                try! realm.write {
                    let newList = RealmSwift.List<TrainingRealmObject>()
                    newList.append(objectsIn: convertToTrainingRealmObject(from: list))
                    existingItem.trainingData = newList
                    // マークの変更をするのが合理的に思えるが、後から色を手動で変更したものが変えられるとストレスだからこのままにしておく。
                }
            } else {
                try! realm.write {
                    let realmObject = TrainingLogRealmObject(trainingDate: trainingDate, trainingData: convertToTrainingRealmObject(from: list), mark: categoryToMark(category: list.last!.category))
                    realm.add(realmObject)
                }
            }
        } else {
            print("(dateComponents) -> (date) conversion failed.")
        }
    }

    // Likeボタンが押された時favoriteをトグルする
    func toggleFavorite(menu: TrainingMenu) {
        do {
            if let existingItem = favoriteFromRealm.where({$0.name == menu.name}).first {
                isFavoriteArray[menu.name] = !(existingItem.isFavorite)
                try realm.write {
                    existingItem.isFavorite =  !(existingItem.isFavorite)
                }
            } else { // RealmにFavorite記録が存在しない(初めてのFavorite)
                isFavoriteArray[menu.name] = true
                try realm.write {
                    let realmObject = FavoriteRealmObject(name: menu.name, isFavorite: true)
                    realm.add(realmObject)
                }

                // Firebase Firestoreに書き込み (以降事実上クライアントがtoggleしても意味なし)
                Task {
                    if let id = menu.id {
                        let document = db.collection("training-menu").document(id)
                        if let data = try await document.getDocument().data() {
                            if let fetchedFavorite = data["favorite"] as? Int {
                                try await document.updateData([
                                    "favorite": fetchedFavorite + 1
                                ])
                            }
                        }
                    }
                }
            }
        } catch {
            print("toggle failed. error occured.")
        }
    }
    
    
    /// Favoriteかどうかを返す
    /// - Parameter name: 種目名称
    /// - Returns: Favoriteかどうか
    func isFavorite(name: String) -> Bool {
        if let existingItem = favoriteFromRealm.where({$0.name == name}).first {
            return existingItem.isFavorite
        } else {
            return false
        }
    }
    
    // isFavoriteArrayに各MenuのisFavorite(Bool)を書き込む
    func loadFavorite() {
        trainingMenus.forEach { menu in
            isFavoriteArray[menu.name] = isFavorite(name: menu.name)
        }
    }
    
    // カテゴリー名からIntに変換
    func categoryToMark(category: String) -> Int{
        switch category {
        case "chest":
            return 0
        case "arm":
            return 1
        case "abs":
            return 2
        case "shoulder":
            return 3
        case "back":
            return 4
        case "thigh":
            return 5
        case "calf":
            return 6
        case "gluteal":
            return 7
        case "hip":
            return 8
        default:
            return -1
        }
    }
}
