import SwiftUI
import RealmSwift
import FirebaseFirestore

@MainActor
class TrainingListService {
    
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
    
    /// お気に入り登録状態の更新
    /// 
    /// [RealmDB] FavoriteTrainingObject
    /// - Parameters:
    ///   - trainingName: TrainingMenu.name.rawValue
    ///   - isFavorite: お気に入り登録状態
    func updateFavoriteState(trainingName: String, isFavorite: Bool) throws {
        try realm.write {
            let favoriteTrainingObject = FavoriteTrainingObject(name: trainingName, isFavorite: isFavorite)
            realm.add(favoriteTrainingObject, update: .modified)
        }
    }

    /// お気に入り数の更新
    ///
    /// [FireStoreDB] training-menu
    /// - Parameter trainingName: TrainingMenu.name.rawValue
    func updateFavoriteCount(trainingName: String) async throws {
        let document = db.collection(AppConfig.Domain.dbCollection_trainingMenu).document(trainingName)
        try await document.updateData([
            "favorite": FieldValue.increment(Int64(1))
        ])
    }

    /// トレーニングをお気に入り登録しているか
    ///
    /// [RealmDB] FavoriteTrainingObject
    /// - Parameter trainingName: TrainingMenu.name.rawValue
    /// - Returns: トレーニングをお気に入り登録しているか
    func isFavorite(trainingName: String) -> Bool {
        return realm.objects(FavoriteTrainingObject.self).where({$0.name == trainingName}).first != nil
    }

}
