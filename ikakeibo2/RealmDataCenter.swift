    //
//  DataCenter.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/03/25.
//  Copyright © 2017年 touhuSoft. All rights reserved.

import RealmSwift

// 費目
class Item : Object {
    static let defaultName = "費目未設定"

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
    static let defaultName = "店舗未設定"
    
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
    static let defaultName = "支払方法未設定"
    
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
    
    //TODO:↓3つの?は取る方向で（つまりCost保存時、必ず↓3つも保存されるようにしたい。nilかどうかを意識したくないので。）
    // と思ったが、Objectの継承クラスにObjectの継承クラスを持たせる場合、Optionalじゃないと例外が出る。仕様。
    dynamic var item: Item?
    dynamic var shop: Shop?
    dynamic var payment: Payment?
    
    // 金額
    dynamic var value = 0
    // メモ
    dynamic var memo = ""

    // 日付1(この変数に直接setするのではなく、setDate()を使う事！)
    dynamic var date = Date()
    
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
    
    static func copy(from: Cost, to: Cost) {

        if let item = from.item {
            to.item = item
        }

        if let shop = from.shop {
            to.shop = shop
        }
        
        if let payment = from.payment {
            to.payment = payment
        }

        to.value = from.value
        to.setDate(target: from.date)
        to.memo = from.memo
        to.createDate = from.createDate
        to.modifyDate = from.modifyDate
    }
    
    convenience init(cost: Int) {
        self.init()
        self.value = cost
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}

class CostSectionItem {
    var cost: Cost? = nil

    init(cost:Cost) {
        self.cost = cost
    }
}

class CostSection {
    var name = ""
    var item : [CostSectionItem] = [CostSectionItem]()

    init(name:String) {
        self.name = name
    }
}

// CSVインポート機能で、ObjCからも呼び出すので、NSObjectを継承させる。
class RealmDataCenter: NSObject {
    // デフォルトRealmを取得。Realmの取得はスレッドごとに１度だけ必要
    private static let realm = try! Realm()
    
        // ソートオブジェクトは保存しておける
//    let sortDescriptor = [SortDescriptor(keyPath:"name", ascending: true),
//                          SortDescriptor(keyPath:"name", ascending: true)]

    // "未設定"のマスタデータを作成する
    static func saveDefaultData() {
        let item = realm.objects(Item.self).filter("name == %@", Item.defaultName)
        if item.count == 0 {
            let defItem = Item()
            try! realm.write {
                realm.add(defItem)
            }
        }
        
        let payment = realm.objects(Payment.self).filter("name == %@", Payment.defaultName)
        if payment.count == 0 {
            let defPayment = Payment()
            try! realm.write {
                realm.add(defPayment)
            }
        }
        
        let shop = realm.objects(Shop.self).filter("name == %@", Shop.defaultName)
        if shop.count == 0 {
            let defShop = Shop()
            try! realm.write {
                realm.add(defShop)
            }
        }
        
        #if DEBUG
        //saveTestData()
        #endif
    }

    static func saveTestData() {
        let kosaihi = Item()
        kosaihi.name = "交際費"
        kosaihi.order = 1
        
        let konetsuhi = Item()
        konetsuhi.name = "光熱費"
        konetsuhi.order = 2
        
        try! realm.write {
            realm.add(kosaihi)
            realm.add(konetsuhi)
        }

        let genkin = Payment()
        genkin.name = "現金"
        genkin.order = 1
        
        let card = Payment()
        card.name = "クレジットカード"
        card.order = 2
        
        try! realm.write {
            realm.add(genkin)
            realm.add(card)
        }
        
        let nagasakiya = Shop()
        nagasakiya.name = "長崎屋"
        nagasakiya.order = 1
        
        let saty = Shop()
        saty.name = "SATY"
        saty.order = 2

        try! realm.write {
            realm.add(nagasakiya)
            realm.add(saty)
        }
    }
    
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

    static func readCost(year : Int, month : Int) -> [CostSection] {

        // 指定された年月のデータを日付の降順で取り出す
        let results = realm.objects(Cost.self).filter("year == %@", year)
            .filter("month == %@", month)
            .sorted(byKeyPath: "date", ascending: false)

        // 何日分のデータが入っているか確認(同じ日のデータは1でカウント)
        var count = 0
        var prevDay = 0
        var find = false
        var sectionArray = [CostSection]()
        
        var section = CostSection(name: "")

        // 日付ごとにSectionオブジェクトを作る。
        // Sectionオブジェクトには、その日付の支出データSectionItemを含む。
        // 最終的に、Sectionの配列である、sectionArrayを作る。
        for result in results {
            if !find {
                find = true
                prevDay = result.day
                section = CostSection(name: String(result.day) + "日")
                section.item.append(contentsOf: [CostSectionItem(cost:result)])
                continue
            }

            if prevDay != result.day {
                count = count + 1
                prevDay = result.day
                sectionArray.append(section)
                section = CostSection(name: String(result.day) + "日")
            }

            section.item.append(contentsOf: [CostSectionItem(cost:result)])
        }

        // ループ処理の最後の１つを追加
        if find {
            sectionArray.append(section)
        }

        return sectionArray
    }

    static func existsItem(checkName: String) -> Item? {
        let exist = realm.objects(Item.self).filter("name == %@", checkName)
        if exist.count == 0 {
            return nil
        }
        
        return exist.first
    }

    static func existsShop(checkName: String) -> Shop? {
        let exist = realm.objects(Shop.self).filter("name == %@", checkName)
        if exist.count == 0 {
            return nil
        }
        
        return exist.first
    }

    static func existsPayment(checkName: String) -> Payment? {
        let exist = realm.objects(Payment.self).filter("name == %@", checkName)
        if exist.count == 0 {
            return nil
        }
        
        return exist.first
    }

    // CSVImportの時は、戻り値を無視させたい。
    @discardableResult
    static func addItem(itemName name : String, order:Int = 0) -> Bool {
        // 既に存在する
        if existsItem(checkName: name) != nil {
            return false
        }

        let item = Item()
        item.name = name

        // 既に存在するorder + 1で作る。
        item.order = RealmDataCenter.itemAtMostLargeOrder() + 1

        try! realm.write {
            realm.add(item)
        }
        return true
    }
    
    // CSVImportの時は、戻り値を無視させたい。
    @discardableResult
    static func addShop(shopName name : String, order:Int = 0) -> Bool {
        // 既に存在する
        if existsShop(checkName: name) != nil {
            return false
        }

        let shop = Shop()
        
        // コンストラクタで採番済
        //shop.id = NSUUID().uuidString
        shop.name = name
        
        // 既に存在するorder + 1で作る。
        shop.order = RealmDataCenter.shopAtMostLargeOrder() + 1

        try! realm.write {
            realm.add(shop)
        }
        return true
    }
    
    // CSVImportの時は、戻り値を無視させたい。
    @discardableResult
    static func addPayment(paymentName name : String, order:Int = 0) -> Bool {
        // 既に存在する
        if existsPayment(checkName: name) != nil {
            return false
        }

        let payment = Payment()
        // コンストラクタで採番済
        //payment.id = NSUUID().uuidString
        payment.name = name

        // 既に存在するorder + 1で作る。
        payment.order = RealmDataCenter.paymentAtMostLargeOrder() + 1

        try! realm.write {
            realm.add(payment)
        }
        
        return true
    }

    @discardableResult
    static func addCost(shopName: String, itemName: String, paymentName: String, value : Int, date: NSDate) -> Bool {
        
        let cost = Cost(cost: value)
        
        if let item = existsItem(checkName: itemName) {
            cost.item = item
        }
        if let shop = existsShop(checkName: shopName) {
            cost.shop = shop
        }
        if let payment = existsPayment(checkName: paymentName) {
            cost.payment = payment
        }
        // メモは未実装
        //cost.memo = ""
        
        // 引数の時点でDate型で受け取りたいのだが、objcからswiftのメソッド(Dateを引数に取る）を呼ぶと、設定していないブレークポイントで止まったままになる。
        cost.setDate(target: date as Date)
        
        try! realm.write {
            realm.add(cost)
        }
        
        return true
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
    
    static func delete(atCost cost:Cost) {
        try! realm.write {
            realm.delete(cost)
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
    
    static func saveOverWrite(inputData data: Cost, savedData: Cost) {
        
        try! realm.write {
            Cost.copy(from: data, to: savedData)
            //trimCost(cost: savedData)
        }
    }
    
    static func save(cost : Cost) {
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



