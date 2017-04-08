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
    
        // ソートオブジェクトは保存しておける
//    let sortDescriptor = [SortDescriptor(keyPath:"name", ascending: true),
//                          SortDescriptor(keyPath:"name", ascending: true)]
    
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
    
    static func addItem(itemName name : String, order:Int = 0) {
        let item = Item()

        item.id = NSUUID().uuidString
        item.name = name
        
        // 既に存在するorder + 1で作る。
        item.order = RealmDataCenter.itemAtMostLargeOrder() + 1

        try! realm.write {
            realm.add(item)
        }
    }

    static func edit(forItem item : Item, newName name : String) {
        try! realm.write {
            item.name = name
            realm.create(Item.self, value: item, update: true)
        }
    }
    
    static func edit(forItem item : Item, newOrder order : Int) {
        try! realm.write {
            item.order = order
            realm.create(Item.self, value: item, update: true)
        }
    }
    
    static func delete(data : Object) {
        try! realm.write {
            realm.delete(data)
        }
    }

    static func changeOrder(atItems items : Results<Item>?, from : Int, to : Int, order : Int) {
        guard let targetItems = items else {
            return
        }

        print(targetItems)

        // 案1
        // from(0)とto(4)を入れ替える
        // 入れ替えた際の、(4).order + 1 で、(3)-(1)つまり(4-1)-(0+1)を入れ替える。
        
        // 案2
        // from(0)とfrom(4)をswapする（確定させる）
        // from(0)のorderより大きい項目をqueryでorderの昇順検索し、全てorderを+1する。
        if(from < to) {
            try! realm.write {

                let filterItems = targetItems
                    .filter("order > " + String(order))
                    .sorted(byKeyPath: "order", ascending: false)
                
                for target in filterItems {
                    target.order = order + 1
                    realm.create(Item.self, value: target, update: true)
                }
                
                
                
                
                
                
                
                
                
                
                
                
                // 移動前のorder
                let fromOrder = (targetItems[from].order)

                // 移動先の、さらに1つ下のItemを取得
                var item : Item
                var itemOrder : Int

                if(targetItems.count > to + 1) {
                    item = targetItems[to + 1]
                    itemOrder = item.order
                } else {
                    item = targetItems[to]
                    itemOrder = item.order
                }

                // 移動元のアイテムを保持（下のループで変わってしまうので）
                let lastMove = targetItems[from]

                // 1つ下(なければ、移動先）のorderから移動前-1のorderまでのorderを、+1する。
                let filterItems = targetItems
                    .filter("order > " + String(item.order))
                    .filter("order < " + String(fromOrder))

                for target in filterItems {
                    target.order = target.order + 1
                    realm.create(Item.self, value: target, update: true)
                }

                // 移動元のアイテムを最後に移動
                lastMove.order = itemOrder + 1
                realm.create(Item.self, value: lastMove, update: true)
            }
        }

//        // 上から下の場合
//        if(from < to) {
//            try! realm.write {
//                // 移動前のorder
//                let fromOrder = (targetItems[from].order)
//                
//                // 移動先の、さらに1つ下のItemを取得
//                var item : Item
//                var itemOrder : Int
//                
//                if(targetItems.count > to + 1) {
//                    item = targetItems[to + 1]
//                    itemOrder = item.order
//                } else {
//                    item = targetItems[to]
//                    itemOrder = item.order
//                }
//
//                // 移動元のアイテムを保持（下のループで変わってしまうので）
//                let lastMove = targetItems[from]
//                
//                // 1つ下(なければ、移動先）のorderから移動前-1のorderまでのorderを、+1する。
//                let filterItems = targetItems
//                    .filter("order > " + String(item.order))
//                    .filter("order < " + String(fromOrder))
//
//                for target in filterItems {
//                    target.order = target.order + 1
//                    realm.create(Item.self, value: target, update: true)
//                }
//
//                // 移動元のアイテムを最後に移動
//                lastMove.order = itemOrder + 1
//                realm.create(Item.self, value: lastMove, update: true)
//            }
//        }
    }

    
    // 未使用
    static func swapItem(from source:Item, to dest:Item) {
        let temp = source.order

        try! realm.write {
            source.order = dest.order
            dest.order = temp
            
            realm.create(Item.self, value: source, update: true)
            realm.create(Item.self, value: dest, update: true)
        }
    }
/*
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
*/

    // MARK:private methods
    static func itemAtMostLargeOrder() -> Int {
        if let item = realm.objects(Item.self).sorted(byKeyPath: "order", ascending: false).first {
            return item.order
        }
        
        // ↓でも良いかも
//        let itemsa = realm.objects(Item.self)
//        let max = itemsa.filter("sort.@max")

        // ↓は通らなかった。IF変わった？
        //itemsa.max(ofProperty: "sort")
        //let a = realm.objects(Item.self).max(ofProperty: "order")
        
        return 0
    }
}



