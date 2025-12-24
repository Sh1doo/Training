import SwiftUI
import RealmSwift

@MainActor
class MakeTrainingListService {
    
    private var realm: Realm {
        return RealmConfig.shared.realm
    }
    
    /// トレーニングメニュー一覧を取得する
    func fetchTrainingMenus() async throws -> [TrainingMenu] {
        let snapshot = try await db.collection(AppConfig.Domain.dbCollection_trainingMenu).getDocuments()
        
        let fetchedMenus = snapshot.documents.compactMap { document -> TrainingMenu? in
            try? document.data(as: TrainingMenu.self)
        }
        
        return fetchedMenus
    }
    
    
    /// トレーニング予定を保存する
    /// - Parameters:
    ///   - trainingDate: 主キー
    ///   - list: 実施予定トレーニング一覧
    func saveLogToRealm(trainingDate: String, list: [TrainingSet]) throws {
        try realm.write {
            if let trainingLogObject = realm.objects(TrainingLogObject.self).where({$0.trainingDate == trainingDate}).first {
                // UPDATE
                let newList = RealmSwift.List<TrainingSetObject>()
                for trainingSet in list {
                    let realmObject = TrainingSetObject()
                    realmObject.setup(from: trainingSet)
                    newList.append(realmObject)
                }
                trainingLogObject.trainingData = newList
            } else {
                // INSERT
                let newList = RealmSwift.List<TrainingSetObject>()
                for trainingSet in list {
                    let realmObject = TrainingSetObject()
                    realmObject.setup(from: trainingSet)
                    newList.append(realmObject)
                }
                let realmObject = TrainingLogObject(trainingDate: trainingDate, trainingData: newList)
                realm.add(realmObject)
            }
        }
    }
    
    
    /// 実施予定日をもとにトレーニングログを取得する
    /// - Parameters: 実施予定日（slashDateString）
    /// - Returns: TrainingLogObject→[TrainingSet]に変換して返す
    func getTrainingLog(trainingDate: String) -> [TrainingSet] {
        let returnArray: [TrainingSet] = []
        if let trainingLogObject = realm.objects(TrainingLogObject.self).where({$0.trainingDate == trainingDate}).first {
            let trainingSetArray: [TrainingSet] = trainingLogObject.trainingData.map { TrainingSet(from: $0) }
            return trainingSetArray
        }
        return returnArray
    }
}
