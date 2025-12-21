//
//  TestView.swift
//  Training
//
//  Created by 冨岡獅堂 on 2024/12/25.
//

import RealmSwift
import SwiftUI

class E: Object, ObjectKeyIdentifiable {
    @Persisted var a = "default"
    @Persisted var dogs: RealmSwift.List<Dog>
    
    required override init() {
        super.init()
    }
    
    // 便利な独自イニシャライザ
    convenience init(a: String, dog: [Dog]) {
        self.init()
        self.a = a
        self.dogs.append(objectsIn: dog)
    }
}

class Dog: Object {
    @Persisted var name: String = ""
    @Persisted var age: Int = 0
    @Persisted var breed: String?
    // No backlink to person -- one-directional relationship
    
    // 便利な独自イニシャライザ
    convenience init(name: String, age: Int, breed: String?) {
        self.init()
        self.name = name
        self.age = age
        self.breed = breed
    }
}

struct TestView: View {
    @State private var realm: Realm = try! Realm(configuration: config)
    @State private var items: Results<E> = try! Realm(configuration: config).objects(E.self)
    // @ObservedResults(E.self) var items
    
    var body: some View {
        VStack {
            List {
                ForEach(items) { item in
                    Text("\(item.a)")
                }
            }
            Button("add"){
                add()
            }
            Button("search"){
                search()
            }
        }
    }
    
    func add() {
        try! realm.write {
            realm.add(E(a: "add success", dog: [Dog(name: "A", age: 10, breed: "yes"),Dog(name: "B", age: 25, breed: "no no")]))
        }
    }
    
    func search() {
        let results = realm.objects(E.self)
        items = results
        print(results)
    }
}

#Preview {
    TestView()
}
