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

    static func edit(atItem item : Item, newName name : String) {
        try! realm.write {
            item.name = name
            realm.create(Item.self, value: item, update: true)
        }
    }
    
    static func edit(atItem item : Item, newOrder order : Int) {
        try! realm.write {
            item.order = order
            realm.create(Item.self, value: item, update: true)
        }
    }

    static func delete(atItems items: Results<Item>?, andTargetItem item : Item) {
        guard let targetItems = items else {
            return
        }
        
        try! realm.write {
            realm.delete(item)

            // 残った費目のorderを、歯抜けの無いよう、1から順に再設定
            let sortedItems = targetItems.sorted(byKeyPath: "order", ascending: true)
            var order = 1
            for target in sortedItems {
                target.order = order
                realm.create(Item.self, value: target, update: true)
                order = order + 1
            }
        }
    }

    // 汎用的なdeleteメソッド
    static func delete(atTarget target : Object) {
        try! realm.write {
            realm.delete(target)
        }
    }

    /*
     “あ”を”お”の下に
     now	proc1	proc2	result
     —————————————————————————————————
     あ5		あ1		あ1		い5
     い4		い4		い5(1+4)	う4
     う3		う3		う4(1+3)	え3
     え2		え2		え3(1+2)	お2
     お1		お1		お2(1+1)	あ1
     
     “あ”を”え”の下に
     now	proc1	proc2	result
     —————————————————————————————————
     あ5		あ2		あ2		い5
     い4		い4		い5(2+3)	う4
     う3		う3		う4(2+2)	え3
     え2		え2		え3(2+1)	あ2
     お1		お1		お1		お1
     
     “お”を”あ”の上に
     now	proc1	proc2	result
     —————————————————————————————————
     あ5		あ5		あ4(5-1)	お5
     い4		い4		い3(5-2)	あ4
     う3		う3		う2(5-3)	い3
     え2		え2		え1(5-4)	う2
     お1		お5		お5		え1
     
     “お”を”あ”の下に
     now	proc1	proc2	result
     —————————————————————————————————
     あ5		あ5		あ5		あ5
     い4		い4		い3(4-1)	お4
     う3		う3		う2(4-2)	い3
     え2		え2		え1(4-3)	う2
     お1		お4		お4		え1
     */
    static func changeOrder(atItems items : Results<Item>?, from : Int, to : Int) {

        guard let targetItems = items else {
            return
        }

        // 自分に自分を重ねた場合は、何もしない
        if from == to {
            return
        }

        print(targetItems)

        // Pattern1 上から下
        if(from < to) {
            try! realm.write {
                // 1.from(0)に、to(4)のorderを代入する
                let fromID = targetItems[from].id
                var order = targetItems[to].order
                
                targetItems[from].order = targetItems[to].order
                realm.create(Item.self, value: targetItems[from], update: true)

                // 2.from(0)に代入されたorder以上の項目(from0は省く！）をorderの昇順でquery検索し、全て、orderを+1する。
                let filterItems = targetItems
                    .filter("order >= " + String(order))
                    .filter("id != '" + fromID + "'")
                    .sorted(byKeyPath: "order", ascending: true)

                for target in filterItems {
                    target.order = order + 1
                    realm.create(Item.self, value: target, update: true)
                    order = order + 1
                }
            }
        // Pattern2 下から上
        } else {
            try! realm.write {
                // 1.from(0)に、to(4)のorderを代入する
                let fromID = targetItems[from].id
                var order = targetItems[to].order
                
                targetItems[from].order = targetItems[to].order
                realm.create(Item.self, value: targetItems[from], update: true)

                // 2.from(0)に代入されたorder以下の項目（from0は省く！）をorderの降順でquery検索し、全て、orderを-1する。
                let filterItems = targetItems
                    .filter("order <= " + String(order))
                    .filter("id != '" + fromID + "'")
                    .sorted(byKeyPath: "order", ascending: false)

                for target in filterItems {
                    target.order = order - 1
                    realm.create(Item.self, value: target, update: true)
                    order = order - 1
                }
            }
        }
        
        print(targetItems)
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



