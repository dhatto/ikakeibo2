//
//  DataCenter.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/03/25.
//  Copyright © 2017年 touhuSoft. All rights reserved.

import RealmSwift

// 費目
class Item : Object {
    dynamic var id = NSUUID().uuidString
    dynamic var name = "費目未設定"
    dynamic var createDate = NSDate()
    dynamic var modifyDate: NSDate?
    dynamic var order = 0 // 降順

    override static func primaryKey() -> String? {
        return "id"
    }
}

// 店舗
class Shop : Object {
    dynamic var id = NSUUID().uuidString
    dynamic var name = "店舗未設定"
    dynamic var createDate = NSDate()
    dynamic var modifyDate: NSDate?
    dynamic var order = 0 // 降順

    override static func primaryKey() -> String? {
        return "id"
    }
}

// 支払方法
class Payment : Object {
    dynamic var id = NSUUID().uuidString
    dynamic var name = "支払方法未設定"
    dynamic var createDate = NSDate()
    dynamic var modifyDate: NSDate?
    dynamic var order = 0 // 降順

    override static func primaryKey() -> String? {
        return "id"
    }
}

// 支出
class Cost : Object {

    dynamic var id = NSUUID().uuidString
    dynamic var item:Item?
    dynamic var shop:Shop?
    dynamic var payment:Payment?
    
    // 金額
    dynamic var value = 0
    // メモ
    dynamic var memo = ""
    // 日付
    dynamic var date : NSDate?

    dynamic var createDate = NSDate()
    dynamic var modifyDate:NSDate?

    override static func primaryKey() -> String? {
        return "id"
    }
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

    static func readShop() -> Results<Shop> {
        // orderの降順で
        let shops = realm.objects(Shop.self).sorted(byKeyPath: "order", ascending: false)
        return shops
    }

    static func readPayment() -> Results<Payment> {
        // orderの降順で
        let payment = realm.objects(Payment.self).sorted(byKeyPath: "order", ascending: false)
        return payment
    }

    static func readCost() -> Results<Cost> {
        //let costs = realm.objects(Cost.self).filter("")
        let costs = realm.objects(Cost.self)
        
        return costs
    }

    static func addItem(itemName name : String, order:Int = 0) {
        let item = Item()

        // コンストラクタで採番済
        //item.id = NSUUID().uuidString
        item.name = name
        
        // 既に存在するorder + 1で作る。
        item.order = RealmDataCenter.itemAtMostLargeOrder() + 1

        try! realm.write {
            realm.add(item)
        }
    }

    static func addShop(shopName name : String, order:Int = 0) {
        let shop = Shop()
        
        // コンストラクタで採番済
        //shop.id = NSUUID().uuidString
        shop.name = name
        
        // 既に存在するorder + 1で作る。
        shop.order = RealmDataCenter.shopAtMostLargeOrder() + 1

        try! realm.write {
            realm.add(shop)
        }
    }
    
    static func addPayment(paymentName name : String, order:Int = 0) {
        let payment = Payment()
        // コンストラクタで採番済
        //payment.id = NSUUID().uuidString
        payment.name = name

        // 既に存在するorder + 1で作る。
        payment.order = RealmDataCenter.paymentAtMostLargeOrder() + 1

        try! realm.write {
            realm.add(payment)
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

    static func edit(atShop shop : Shop, newName name : String) {
        try! realm.write {
            shop.name = name
            realm.create(Shop.self, value: shop, update: true)
        }
    }

    static func edit(atShop shop : Shop, newOrder order : Int) {
        try! realm.write {
            shop.order = order
            realm.create(Shop.self, value: shop, update: true)
        }
    }
    
    static func edit(atPayment payment : Payment, newName name : String) {
        try! realm.write {
            payment.name = name
            realm.create(Payment.self, value: payment, update: true)
        }
    }
    
    static func edit(atPayment payment : Payment, newOrder order : Int) {
        try! realm.write {
            payment.order = order
            realm.create(Payment.self, value: payment, update: true)
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
    
    static func delete(atShops shops: Results<Shop>?, andTarget shop : Shop) {
        guard let targetShops = shops else {
            return
        }
        
        try! realm.write {
            realm.delete(shop)
            
            // 残った費目のorderを、歯抜けの無いよう、1から順に再設定
            let sortedShops = targetShops.sorted(byKeyPath: "order", ascending: true)
            var order = 1
            for target in sortedShops {
                target.order = order
                realm.create(Shop.self, value: target, update: true)
                order = order + 1
            }
        }
    }
    
    static func delete(atPayments payments: Results<Payment>?, andTarget payment : Payment) {
        guard let targetPayments = payments else {
            return
        }
        
        try! realm.write {
            realm.delete(payment)
            
            // 残った費目のorderを、歯抜けの無いよう、1から順に再設定
            let sortedPayments = targetPayments.sorted(byKeyPath: "order", ascending: true)
            var order = 1
            for target in sortedPayments {
                target.order = order
                realm.create(Payment.self, value: target, update: true)
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

    static func save(cost : Cost) {
        // コンストラクタで採番済
        //cost.id = NSUUID().uuidString
        cost.value = 12800

        try! realm.write {
            realm.add(cost)
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
    
    static func changeOrder(atShops shops : Results<Shop>?, from : Int, to : Int) {
        
        guard let targetShops = shops else {
            return
        }
        
        // 自分に自分を重ねた場合は、何もしない
        if from == to {
            return
        }
        
        print(targetShops)
        
        // Pattern1 上から下
        if(from < to) {
            try! realm.write {
                // 1.from(0)に、to(4)のorderを代入する
                let fromID = targetShops[from].id
                var order = targetShops[to].order
                
                targetShops[from].order = targetShops[to].order
                realm.create(Item.self, value: targetShops[from], update: true)
                
                // 2.from(0)に代入されたorder以上の項目(from0は省く！）をorderの昇順でquery検索し、全て、orderを+1する。
                let filterItems = targetShops
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
                let fromID = targetShops[from].id
                var order = targetShops[to].order
                
                targetShops[from].order = targetShops[to].order
                realm.create(Item.self, value: targetShops[from], update: true)
                
                // 2.from(0)に代入されたorder以下の項目（from0は省く！）をorderの降順でquery検索し、全て、orderを-1する。
                let filterItems = targetShops
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
        
        print(targetShops)
    }
    
    static func changeOrder(atPayments payments : Results<Payment>?, from : Int, to : Int) {
        
        guard let targetPayments = payments else {
            return
        }
        
        // 自分に自分を重ねた場合は、何もしない
        if from == to {
            return
        }
        
        print(targetPayments)
        
        // Pattern1 上から下
        if(from < to) {
            try! realm.write {
                // 1.from(0)に、to(4)のorderを代入する
                let fromID = targetPayments[from].id
                var order = targetPayments[to].order
                
                targetPayments[from].order = targetPayments[to].order
                realm.create(Item.self, value: targetPayments[from], update: true)
                
                // 2.from(0)に代入されたorder以上の項目(from0は省く！）をorderの昇順でquery検索し、全て、orderを+1する。
                let filterItems = targetPayments
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
                let fromID = targetPayments[from].id
                var order = targetPayments[to].order
                
                targetPayments[from].order = targetPayments[to].order
                realm.create(Item.self, value: targetPayments[from], update: true)
                
                // 2.from(0)に代入されたorder以下の項目（from0は省く！）をorderの降順でquery検索し、全て、orderを-1する。
                let filterItems = targetPayments
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
        
        print(targetPayments)
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
    
    static func shopAtMostLargeOrder() -> Int {
        if let shop = realm.objects(Shop.self).sorted(byKeyPath: "order", ascending: false).first {
            return shop.order
        }

        return 0
    }
    
    static func paymentAtMostLargeOrder() -> Int {
        if let payment = realm.objects(Payment.self).sorted(byKeyPath: "order", ascending: false).first {
            return payment.order
        }
        
        return 0
    }
}



