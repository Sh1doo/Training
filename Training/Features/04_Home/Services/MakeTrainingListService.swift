import SwiftUI

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
    func saveLogToRealm(trainingDate: String, list: [TrainingSet]) throws {
        try realm.write {
            if let existingItem = realm.objects(TrainingLogObject.self).filter("trainingDate == %@", trainingDate).first {
                // UPDATE
                let newList = RealmSwift.List<TrainingSetObject>()
                for trainingSet in existingItem.trainingData {
                    let realmObject = TrainingSetObject()
                    realmObject.setup(from: trainingSet)
                    newList.append(realmObject)
                }
                existingItem.trainingData = newList
            } else {
                // INSERT
                let newList = RealmSwift.List<TrainingSetObject>()
                for trainingSet in existingItem.trainingData {
                    let realmObject = TrainingSetObject()
                    realmObject.setup(from: trainingSet)
                    newList.append(realmObject)
                }
                let realmObject = TrainingLogObject(trainingDate: trainingDate, trainingData: newList)
                realm.add(realmObject)
            }
        }
    }
}