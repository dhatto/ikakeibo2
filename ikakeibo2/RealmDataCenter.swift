//
//  DataCenter.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/03/25.
//  Copyright © 2017年 touhuSoft. All rights reserved.

import RealmSwift

// 費目
class Item : Object {
    static let defaultName = "■費目"

    dynamic var id = NSUUID().uuidString
    dynamic var name = defaultName
    dynamic var createDate = Date()
    dynamic var modifyDate: Date?
    dynamic var order = 0 // 降順

    override static func primaryKey() -> String? {
        return "id"
    }
}

// 店舗
class Shop : Object {
    static let defaultName = "未設定"
    
    dynamic var id = NSUUID().uuidString
    dynamic var name = defaultName
    dynamic var createDate = Date()
    dynamic var modifyDate: Date?
    dynamic var order = 0 // 降順

    override static func primaryKey() -> String? {
        return "id"
    }
}

// 支払方法
class Payment : Object {
    static let defaultName = "未設定"
    
    dynamic var id = NSUUID().uuidString
    dynamic var name = defaultName
    dynamic var createDate = Date()
    dynamic var modifyDate: Date?
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

    // 日付1(この変数に直接setするのではなく、setDate()を使う事！)
    dynamic var date : Date?
    
    // 日付2(グルーピングしてフィルタしやすいように、日付を分割したデータも保持)
    dynamic var year = 0
    dynamic var month = 0
    dynamic var day = 0
    
    func setDate(target : Date) {
        self.date = target
        // NSDateはGMT時間なので、JSTに変換する
        if let comp = DHLibrary.dhDate(toJSTComponents: target) {
            self.year = comp.year!
            self.month = comp.month!
            self.day = comp.day!
        }
    }

    dynamic var createDate = Date()
    dynamic var modifyDate:Date?

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
        let costs = realm.objects(Cost.self).sorted(byKeyPath: "date", ascending: false)
        
        return costs
    }

    // MEMO:NSDateは、内部でGMT(UTC)形式でデータを保持する。
    // なので、デバッグすると9時間ずれてしまっているが、これは仕様通り。
    static func monthRange() -> (begin:Date, end:Date) {
        // dateの月の月末月初めを計算します。
        let date = Date()
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)

        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        calendar.locale = Locale(identifier: "ja")
        
        // 年月日時分秒のNSComponentsを作る（この時点ではdateと一致したものになっている）
        var comp = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second], from: date)

        // ここで1日の0時0分0秒に設定します
        comp.day = 1
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        
        // NSComponentsをNSDateに変換します
        let monthBeginningDate = calendar.date(from: comp)
        
        // その月が何日あるかを計算します
//        let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        let range = calendar.range(of: .day, in: .month, for: date)
        //let lastDay = range

        // ここで月末に日を変えます
        comp.day = range?.upperBound
        
        let monthEndDate = calendar.date(from: comp)
        
        return (monthBeginningDate!, monthEndDate!)
    }

    static func numberOf(year : Int, month : Int) -> Int {
        // 今月のデータを持ってくる（2017/4/1 - 2017/4/30)
        //let dateRange = RealmDataCenter.monthRange()
        //let results = realm.objects(Cost.self).filter("date > %@", dateRange.begin).filter("date < %@", dateRange.end)
        let results = realm.objects(Cost.self).filter("year == %@", year)
            .filter("month == %@", month)
            .sorted(byKeyPath: "date")

        // 何日分のデータが入っているか確認(同じ日のデータは1でカウント)
        var count = 0
        var prevDay = 0

        for result in results {
            if prevDay != result.day {
                count = count + 1
                prevDay = result.day
            }
        }

        return count
        
        //        let date2 = Date(timeIntervalSinceNow: 1 * 60 * 60 * 24 * 7)
        //let count = realm.objects(Cost.self).filter("date > %@ AND date < %@", dateRange.0, dateRange.1).count
//        let accounts = realm.objects(Cost.self).filter("date", Date(), Date()).findAll();
//
//        accounts = realm.where(Account.class).findAllSorted("date")
//        Iterator<Account> it = accounts.iterator();
//        int previousMonth = it.next().getDate().getMonth();
//        while (it.hasNext) {
//            int month = it.next().getDate().getMonth();
//            if (month != previousMonth) {
//                // month changed
//            }
//            previousMonth = month;
//        }



//        let date = Date()
//        let predicate = NSPredicate(format: "date > %@", date)
//        let costs = realm.objects(Cost.self).filter(predicate)

        return count
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
        // 未設定の場合は、保存しない。
        if cost.item?.name == Item.defaultName {
            cost.item = nil
        }
        
        if cost.shop?.name == Shop.defaultName {
            cost.shop = nil
        }
        
        if cost.payment?.name == Payment.defaultName {
            cost.payment = nil
        }

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



