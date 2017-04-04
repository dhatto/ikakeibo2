//
//  DataCenter.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/03/25.
//  Copyright © 2017年 touhuSoft. All rights reserved.

//import Foundation
import RealmSwift

class Item : Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var createDate = NSDate()
    dynamic var modifyDate: NSDate?
    dynamic var order = 0 // 降順

    override static func primaryKey() -> String? {
        return "id"
    }
}

class Cost : Object {
    dynamic var item:Item?
    dynamic var value = 0
    dynamic var createDate = NSDate()
    dynamic var modifyDate:NSDate?
}

class RealmDataCenter {
    // デフォルトRealmを取得。Realmの取得はスレッドごとに１度だけ必要
    private static let realm = try! Realm()

    // MARK: Interfaces
    static func readItem() -> Results<Item> {
        // orderの降順で
        let items = realm.objects(Item.self).sorted(byKeyPath: "order", ascending: false)
        return items
    }

    static func readCost() -> Results<Cost> {
        //let costs = realm.objects(Cost.self).filter("")
        let costs = realm.objects(Cost.self)
        
        return costs
    }
    
    static func addItem(name : String, order:Int = 0) {
        let item = Item()

        item.id = NSUUID().uuidString
        item.name = name
        
        // 既に存在するorder + 1で作る。
        item.order = RealmDataCenter.itemAtMostLargeOrder() + 1

        try! realm.write {
            realm.add(item)
        }
    }
    
    static func delete(data : Object) {
        try! realm.write {
            realm.delete(data)
        }
    }
    
    static func saveData(itemName name:String, value:Int) {

        let item = Item()
        item.id = NSUUID().uuidString
        item.name = name

        let cost = Cost()
        cost.value = value
        cost.item = item

        // データを永続化するのはとても簡単です
        // トランザクションを開始して、オブジェクトをRealmに追加
        try! realm.write {
            realm.add(item)
            realm.add(cost)
        }

        // クエリの実行結果は自動的に最新の状態に更新されます
        //puppies.count // => 1

        // バックグラウンドスレッドで検索を実行し、値を更新します
//        DispatchQueue(label: "background").async {
//            let realm = try! Realm()
//            let theDog = realm.objects(Dog.self).filter("age == 1").first
//            try! realm.write {
//                theDog!.age = 3
//            }
//        }
    }
    
    // MARK:private methods
    static func itemAtMostLargeOrder() -> Int {
        if let item = realm.objects(Item.self).sorted(byKeyPath: "order", ascending: false).first {
            return item.order
        }

        return 0
    }
}



