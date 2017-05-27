//
//  DataCenter.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/03/25.
//  Copyright © 2017年 touhuSoft. All rights reserved.

import RealmSwift

// CSVインポート機能で、ObjCからも呼び出すので、NSObjectを継承させる。
class RealmDataCenter: NSObject {
    // デフォルトRealmを取得。Realmの取得はスレッドごとに１度だけ必要
    private static let realm = try! Realm()

// ソートオブジェクトは保存しておける
//    let sortDescriptor = [SortDescriptor(keyPath:"name", ascending: true),
//                          SortDescriptor(keyPath:"name", ascending: true)]

    // MARK: 特殊なメソッド
    // マスタにデータが１件もない場合のみ、"未設定"のマスタデータを作成する
    static func saveDefaultData() {
        let item = realm.objects(Item.self).filter("name == %@", Item.defaultName)
        if item.count == 0 {
            let defItem = Item(name: Item.defaultName)
            try! realm.write {
                realm.add(defItem)
            }
        }
        
        let income = realm.objects(ItemIncome.self).filter("name == %@", ItemIncome.defaultName)
        if income.count == 0 {
            let defItem = ItemIncome(name: ItemIncome.defaultName)
            try! realm.write {
                realm.add(defItem)
            }
        }
        
        let payment = realm.objects(Payment.self).filter("name == %@", Payment.defaultName)
        if payment.count == 0 {
            let defPayment = Payment(name: Payment.defaultName)
            try! realm.write {
                realm.add(defPayment)
            }
        }
        
        let shop = realm.objects(Shop.self).filter("name == %@", Shop.defaultName)
        if shop.count == 0 {
            let defShop = Shop(name: Shop.defaultName)
            try! realm.write {
                realm.add(defShop)
            }
        }
    }

    static func exportToCsv() -> String {

        var csvString = ""

        func addCamma() {
            if csvString.characters.count == 0 {
                return
            }

            if !csvString.hasSuffix(",") {
                csvString = csvString + ","
            }
        }

        func addStr(str: String) {
            addCamma()
            csvString = csvString + str
        }

        let costs = realm.objects(Cost.self).sorted(byKeyPath: "createDate", ascending: false)

        //店/支出項目/収入項目/金額/日付
        for cost in costs {
            
            if let shop = cost.shop {
                csvString = csvString + shop.name
                addCamma()
            } else {
                addCamma()
            }

            if let item = cost.item {
                addStr(str: item.name)
            } else {
                addStr(str: "")
            }

            if let income = cost.itemIncome {
                addStr(str: income.name)
            } else {
                addStr(str: "")
            }

            addStr(str: String(cost.value))
            addStr(str: DHLibrary.dhDateToString(fromCurrentCalendar: cost.date))

            // 改行
            csvString = csvString + "\r\n"
        }
        
        return csvString
    }

    // MARK: read
//    static func readItem() -> Results<Item> {
//        // orderの降順で
//        let items = realm.objects(Item.self).sorted(byKeyPath: "order", ascending: false)
//        return items
//    }
//
//    static func readIncome() -> Results<ItemIncome> {
//        // orderの降順で
//        let incomes = realm.objects(ItemIncome.self).sorted(byKeyPath: "order", ascending: false)
//        return incomes
//    }
//
//    static func readShop() -> Results<Shop> {
//        // orderの降順で
//        let shops = realm.objects(Shop.self).sorted(byKeyPath: "order", ascending: false)
//        return shops
//    }
//
//    static func readPayment() -> Results<Payment> {
//        // orderの降順で
//        let payment = realm.objects(Payment.self).sorted(byKeyPath: "order", ascending: false)
//        return payment
//    }
    
    static func read<T: ObjectBase>(type: T.Type) -> Results<T> {
        // orderの降順で
        let target = realm.objects(T.self).sorted(byKeyPath: "order", ascending: false)
        return target
    }
    
    static func readCost(year: Int, month: Int, type: Int) -> [CostSection] {

        // 指定された年月のデータを日付の降順で取り出す
        let results = realm.objects(Cost.self)
            .filter("year == %@", year)
            .filter("month == %@", month)
            .filter("type == %@", type)
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
    
    static func readTotalCost(year: Int, month: Int, type: Int) -> (sum: Int, dic: [String: Int]) {
        
        // 指定された年月のデータを日付の降順で取り出す
        let results = realm.objects(Cost.self)
            .filter("year == %@", year)
            .filter("month == %@", month)
            .filter("type == %@", type)
            .sorted(byKeyPath: "date", ascending: false)

        let sum:Int = results.sum(ofProperty: "value")

        var resultDic = [String: Int]()

        for result in results {
            if let name = result.item?.name {
                if let value = resultDic[name] {
                    resultDic[name] = value + result.value
                } else {
                    resultDic[name] = result.value
                }
            } else {
                if let value = resultDic["その他"] {
                    resultDic["その他"] = value + result.value
                } else {
                    resultDic["その他"] = result.value
                }
            }
        }
        
        return (sum, resultDic)
    }
    
    // MARK: add
    // for objc(not support generics function...)
    @discardableResult
    static func addItem(name: String, order:Int = 0) -> Bool {

        // 既に存在する
        if exists(type:Item.self, checkName: name) != nil {
            return false
        }

        let item = Item(name: Item.defaultName)
        item.name = name

        // 既に存在するorder + 1で作る。
        item.order = RealmDataCenter.atMostLargeOrder(type: Item.self) + 1

        try! realm.write {
            realm.add(item)
        }
        return true
    }

    // for objc(not support generics function...)
    @discardableResult
    static func addIncome(name: String, order:Int = 0) -> Bool {
        
        // 既に存在する
        if exists(type:ItemIncome.self, checkName: name) != nil {
            return false
        }

        let income = ItemIncome(name: ItemIncome.defaultName)
        income.name = name
        
        // 既に存在するorder + 1で作る。
        income.order = RealmDataCenter.atMostLargeOrder(type: ItemIncome.self) + 1

        try! realm.write {
            realm.add(income)
        }
        return true
    }
    
    // for objc(not support generics function...)
    @discardableResult
    static func addShop(shopName name : String, order:Int = 0) -> Bool {
        
        // 既に存在する
        if exists(type:Shop.self, checkName: name) != nil {
            return false
        }

        let shop = Shop()
        shop.name = name
        
        // 既に存在するorder + 1で作る。
        shop.order = RealmDataCenter.atMostLargeOrder(type: Shop.self) + 1
        
        try! realm.write {
            realm.add(shop)
        }
        
        return true
    }
    
    // for objc(not support generics function...)
    @discardableResult
    static func addPayment(paymentName name : String, order:Int = 0) -> Bool {
        // 既に存在する
        if exists(type: Payment.self, checkName: name) != nil {
            return false
        }

        let payment = Payment()
        payment.name = name

        // 既に存在するorder + 1で作る。
        payment.order = RealmDataCenter.atMostLargeOrder(type: Payment.self) + 1

        try! realm.write {
            realm.add(payment)
        }
        
        return true
    }

    @discardableResult
    static func add<T:ObjectBase>(type: T.Type, name: String, order: Int = 0) -> Bool {
        // 既に存在する
        if exists(type:T.self, checkName: name) != nil {
            return false
        }

        let target = T()
        target.name = name
        
        // 既に存在するorder + 1で作る。
        target.order = RealmDataCenter.atMostLargeOrder(type: T.self) + 1
        
        try! realm.write {
            realm.add(target)
        }
        return true
    }

    @discardableResult
    static func addCost(shopName: String, type: Int, itemName: String, paymentName: String, value : Int, date: NSDate) -> Bool {
        
        let cost = Cost(cost: value)
        // 収入/支出
        cost.type = type

        if cost.type == 0 {
            if let income = exists(type: ItemIncome.self, checkName: itemName) {
                cost.itemIncome = income
            }
        } else {
            if let item = exists(type: Item.self, checkName: itemName) {
                cost.item = item
            }
        }

        if let shop = exists(type: Shop.self, checkName: shopName) {
            cost.shop = shop
        }
        if let payment = exists(type: Payment.self, checkName: paymentName) {
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

    // MARK: delete
//    static func edit(atItem item : Item, newName name : String) {
//        try! realm.write {
//            item.name = name
//            realm.create(Item.self, value: item, update: true)
//        }
//    }
    
//    static func edit(atItem item : Item, newOrder order : Int) {
//        try! realm.write {
//            item.order = order
//            realm.create(Item.self, value: item, update: true)
//        }
//    }

//    static func edit(atIncome income : ItemIncome, newName name : String) {
//        try! realm.write {
//            income.name = name
//            realm.create(ItemIncome.self, value: income, update: true)
//        }
//    }
    
//    static func edit(atIncome income : ItemIncome, newOrder order : Int) {
//        try! realm.write {
//            income.order = order
//            realm.create(ItemIncome.self, value: income, update: true)
//        }
//    }

//    static func edit(atShop shop : Shop, newName name : String) {
//        try! realm.write {
//            shop.name = name
//            realm.create(Shop.self, value: shop, update: true)
//        }
//    }

//    static func edit(atShop shop : Shop, newOrder order : Int) {
//        try! realm.write {
//            shop.order = order
//            realm.create(Shop.self, value: shop, update: true)
//        }
//    }
    
//    static func edit(atPayment payment : Payment, newName name : String) {
//        try! realm.write {
//            payment.name = name
//            realm.create(Payment.self, value: payment, update: true)
//        }
//    }

//    static func edit(atPayment payment : Payment, newOrder order : Int) {
//        try! realm.write {
//            payment.order = order
//            realm.create(Payment.self, value: payment, update: true)
//        }
//    }


    static func delete(atCost cost:Cost) {
        try! realm.write {
            realm.delete(cost)
        }
    }

//    static func delete(atShops shops: Results<Shop>?, andTarget shop : Shop) {
//        guard let targetShops = shops else {
//            return
//        }
//        
//        try! realm.write {
//            realm.delete(shop)
//            
//            // 残った費目のorderを、歯抜けの無いよう、1から順に再設定
//            let sortedShops = targetShops.sorted(byKeyPath: "order", ascending: true)
//            var order = 1
//            for target in sortedShops {
//                target.order = order
//                realm.create(Shop.self, value: target, update: true)
//                order = order + 1
//            }
//        }
//    }
//    
//    static func delete(atPayments payments: Results<Payment>?, andTarget payment : Payment) {
//        guard let targetPayments = payments else {
//            return
//        }
//        
//        try! realm.write {
//            realm.delete(payment)
//            
//            // 残った費目のorderを、歯抜けの無いよう、1から順に再設定
//            let sortedPayments = targetPayments.sorted(byKeyPath: "order", ascending: true)
//            var order = 1
//            for target in sortedPayments {
//                target.order = order
//                realm.create(Payment.self, value: target, update: true)
//                order = order + 1
//            }
//        }
//    }

    static func delete<T: ObjectBase>(at list: Results<T>?, andTarget target : T) {
        guard let targetList = list else {
            return
        }
        
        try! realm.write {
            realm.delete(target)
            
            // 残った費目のorderを、歯抜けの無いよう、1から順に再設定
            let sorted = targetList.sorted(byKeyPath: "order", ascending: true)
            var order = 1
            for target in sorted {
                target.order = order
                realm.create(T.self, value: target, update: true)
                order = order + 1
            }
        }
    }

//    static func delete(atItems items: Results<Item>?, andTargetItem item : Item) {
//        guard let targetItems = items else {
//            return
//        }
//        
//        try! realm.write {
//            realm.delete(item)
//            
//            // 残った費目のorderを、歯抜けの無いよう、1から順に再設定
//            let sortedItems = targetItems.sorted(byKeyPath: "order", ascending: true)
//            var order = 1
//            for target in sortedItems {
//                target.order = order
//                realm.create(Item.self, value: target, update: true)
//                order = order + 1
//            }
//        }
//    }
//
//    static func delete(atIncome incomes: Results<ItemIncome>?, andTargetIncome income : ItemIncome) {
//        guard let targetIncomes = incomes else {
//            return
//        }
//        
//        try! realm.write {
//            realm.delete(income)
//            
//            // 残った費目のorderを、歯抜けの無いよう、1から順に再設定
//            let sortedItems = targetIncomes.sorted(byKeyPath: "order", ascending: true)
//            var order = 1
//            for target in sortedItems {
//                target.order = order
//                realm.create(ItemIncome.self, value: target, update: true)
//                order = order + 1
//            }
//        }
//    }

    // 汎用的なdeleteメソッド
//    static func delete(atTarget target : Object) {
//        try! realm.write {
//            realm.delete(target)
//        }
//    }
    
    // MARK: changeOrder
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
    static func changeOrder<T: ObjectBase>(at list : Results<T>?, from : Int, to : Int) {

        guard let targetItems = list else {
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
                realm.create(T.self, value: targetItems[from], update: true)

                // 2.from(0)に代入されたorder以上の項目(from0は省く！）をorderの昇順でquery検索し、全て、orderを+1する。
                let filterItems = targetItems
                    .filter("order >= " + String(order))
                    .filter("id != '" + fromID + "'")
                    .sorted(byKeyPath: "order", ascending: true)

                for target in filterItems {
                    target.order = order + 1
                    realm.create(T.self, value: target, update: true)
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
                realm.create(T.self, value: targetItems[from], update: true)
                
                // 2.from(0)に代入されたorder以下の項目（from0は省く！）をorderの降順でquery検索し、全て、orderを-1する。
                let filterItems = targetItems
                    .filter("order <= " + String(order))
                    .filter("id != '" + fromID + "'")
                    .sorted(byKeyPath: "order", ascending: false)
                
                for target in filterItems {
                    target.order = order - 1
                    realm.create(T.self, value: target, update: true)
                    order = order - 1
                }
            }
        }

        print(targetItems)
    }

//    static func changeOrder(atIncomes incomes : Results<ItemIncome>?, from : Int, to : Int) {
//        
//        guard let targetIncomes = incomes else {
//            return
//        }
//        
//        // 自分に自分を重ねた場合は、何もしない
//        if from == to {
//            return
//        }
//        
//        print(targetIncomes)
//        
//        // Pattern1 上から下
//        if(from < to) {
//            try! realm.write {
//                // 1.from(0)に、to(4)のorderを代入する
//                let fromID = targetIncomes[from].id
//                var order = targetIncomes[to].order
//                
//                targetIncomes[from].order = targetIncomes[to].order
//                realm.create(ItemIncome.self, value: targetIncomes[from], update: true)
//                
//                // 2.from(0)に代入されたorder以上の項目(from0は省く！）をorderの昇順でquery検索し、全て、orderを+1する。
//                let filterItems = targetIncomes
//                    .filter("order >= " + String(order))
//                    .filter("id != '" + fromID + "'")
//                    .sorted(byKeyPath: "order", ascending: true)
//                
//                for target in filterItems {
//                    target.order = order + 1
//                    realm.create(ItemIncome.self, value: target, update: true)
//                    order = order + 1
//                }
//            }
//            // Pattern2 下から上
//        } else {
//            try! realm.write {
//                // 1.from(0)に、to(4)のorderを代入する
//                let fromID = targetIncomes[from].id
//                var order = targetIncomes[to].order
//                
//                targetIncomes[from].order = targetIncomes[to].order
//                realm.create(ItemIncome.self, value: targetIncomes[from], update: true)
//                
//                // 2.from(0)に代入されたorder以下の項目（from0は省く！）をorderの降順でquery検索し、全て、orderを-1する。
//                let filterItems = targetIncomes
//                    .filter("order <= " + String(order))
//                    .filter("id != '" + fromID + "'")
//                    .sorted(byKeyPath: "order", ascending: false)
//                
//                for target in filterItems {
//                    target.order = order - 1
//                    realm.create(ItemIncome.self, value: target, update: true)
//                    order = order - 1
//                }
//            }
//        }
//        
//        print(targetIncomes)
//    }
    
//    static func changeOrder(atShops shops : Results<Shop>?, from : Int, to : Int) {
//        
//        guard let targetShops = shops else {
//            return
//        }
//        
//        // 自分に自分を重ねた場合は、何もしない
//        if from == to {
//            return
//        }
//        
//        print(targetShops)
//        
//        // Pattern1 上から下
//        if(from < to) {
//            try! realm.write {
//                // 1.from(0)に、to(4)のorderを代入する
//                let fromID = targetShops[from].id
//                var order = targetShops[to].order
//                
//                targetShops[from].order = targetShops[to].order
//                realm.create(Shop.self, value: targetShops[from], update: true)
//                
//                // 2.from(0)に代入されたorder以上の項目(from0は省く！）をorderの昇順でquery検索し、全て、orderを+1する。
//                let filterItems = targetShops
//                    .filter("order >= " + String(order))
//                    .filter("id != '" + fromID + "'")
//                    .sorted(byKeyPath: "order", ascending: true)
//                
//                for target in filterItems {
//                    target.order = order + 1
//                    realm.create(Shop.self, value: target, update: true)
//                    order = order + 1
//                }
//            }
//            // Pattern2 下から上
//        } else {
//            try! realm.write {
//                // 1.from(0)に、to(4)のorderを代入する
//                let fromID = targetShops[from].id
//                var order = targetShops[to].order
//                
//                targetShops[from].order = targetShops[to].order
//                realm.create(Shop.self, value: targetShops[from], update: true)
//                
//                // 2.from(0)に代入されたorder以下の項目（from0は省く！）をorderの降順でquery検索し、全て、orderを-1する。
//                let filterItems = targetShops
//                    .filter("order <= " + String(order))
//                    .filter("id != '" + fromID + "'")
//                    .sorted(byKeyPath: "order", ascending: false)
//                
//                for target in filterItems {
//                    target.order = order - 1
//                    realm.create(Shop.self, value: target, update: true)
//                    order = order - 1
//                }
//            }
//        }
//        
//        print(targetShops)
//    }
//    
//    static func changeOrder(atPayments payments : Results<Payment>?, from : Int, to : Int) {
//        
//        guard let targetPayments = payments else {
//            return
//        }
//        
//        // 自分に自分を重ねた場合は、何もしない
//        if from == to {
//            return
//        }
//        
//        print(targetPayments)
//        
//        // Pattern1 上から下
//        if(from < to) {
//            try! realm.write {
//                // 1.from(0)に、to(4)のorderを代入する
//                let fromID = targetPayments[from].id
//                var order = targetPayments[to].order
//                
//                targetPayments[from].order = targetPayments[to].order
//                realm.create(Payment.self, value: targetPayments[from], update: true)
//                
//                // 2.from(0)に代入されたorder以上の項目(from0は省く！）をorderの昇順でquery検索し、全て、orderを+1する。
//                let filterItems = targetPayments
//                    .filter("order >= " + String(order))
//                    .filter("id != '" + fromID + "'")
//                    .sorted(byKeyPath: "order", ascending: true)
//                
//                for target in filterItems {
//                    target.order = order + 1
//                    realm.create(Payment.self, value: target, update: true)
//                    order = order + 1
//                }
//            }
//            // Pattern2 下から上
//        } else {
//            try! realm.write {
//                // 1.from(0)に、to(4)のorderを代入する
//                let fromID = targetPayments[from].id
//                var order = targetPayments[to].order
//                
//                targetPayments[from].order = targetPayments[to].order
//                realm.create(Payment.self, value: targetPayments[from], update: true)
//                
//                // 2.from(0)に代入されたorder以下の項目（from0は省く！）をorderの降順でquery検索し、全て、orderを-1する。
//                let filterItems = targetPayments
//                    .filter("order <= " + String(order))
//                    .filter("id != '" + fromID + "'")
//                    .sorted(byKeyPath: "order", ascending: false)
//                
//                for target in filterItems {
//                    target.order = order - 1
//                    realm.create(Payment.self, value: target, update: true)
//                    order = order - 1
//                }
//            }
//        }
//        
//        print(targetPayments)
//    }

    // MARK: save
    static func save<T: ObjectBase>(at target : T, newName name : String, color : UIColor) {
        var red: CGFloat = 1.0
        var green: CGFloat = 1.0
        var blue: CGFloat = 1.0
        var alpha: CGFloat = 1.0
        
        // UIColor 型の color から RGBA の値を取得します。
        try! realm.write {
            target.name = name
            if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
                
                target.r = Int(red * 255)
                target.g = Int(green * 255)
                target.b = Int(blue * 255)
                
                realm.create(T.self, value: target, update: true)
            }
        }
    }
    static func save<T: ObjectBase>(at target : T, newOrder order : Int) {
        try! realm.write {
            target.order = order
            realm.create(T.self, value: target, update: true)
        }
    }
    
    static func saveOverWrite(inputData data: Cost, savedData: Cost) {
        
        try! realm.write {
            Cost.copy(from: data, to: savedData)
        }
    }
    
    static func save(cost : Cost) {
        try! realm.write {
            realm.add(cost)
        }
    }

    // MARK: Check
//    static func existsItem(checkName: String) -> Item? {
//        let exist = realm.objects(Item.self).filter("name == %@", checkName)
//        if exist.count == 0 {
//            return nil
//        }
//
//        return exist.first
//    }
//
//    static func existsIncome(checkName: String) -> ItemIncome? {
//        let exist = realm.objects(ItemIncome.self).filter("name == %@", checkName)
//        if exist.count == 0 {
//            return nil
//        }
//
//        return exist.first
//    }
//
//    static func existsShop(checkName: String) -> Shop? {
//        let exist = realm.objects(Shop.self).filter("name == %@", checkName)
//        if exist.count == 0 {
//            return nil
//        }
//        
//        return exist.first
//    }
//    
//    static func existsPayment(checkName: String) -> Payment? {
//        let exist = realm.objects(Payment.self).filter("name == %@", checkName)
//        if exist.count == 0 {
//            return nil
//        }
//        
//        return exist.first
//    }
    
    static func exists<T:ObjectBase>(type:T.Type, checkName: String) -> T? {
        let exist = realm.objects(T.self).filter("name == %@", checkName)
        if exist.count == 0 {
            return nil
        }
        
        return exist.first
    }
    
//    static func itemAtMostLargeOrder() -> Int {
//        if let item = realm.objects(Item.self).sorted(byKeyPath: "order", ascending: false).first {
//            return item.order
//        }
//        
//        // ↓でも良いかも
////        let itemsa = realm.objects(Item.self)
////        let max = itemsa.filter("sort.@max")
//
//        // ↓は通らなかった。IF変わった？
//        //itemsa.max(ofProperty: "sort")
//        //let a = realm.objects(Item.self).max(ofProperty: "order")
//        
//        return 0
//    }

//    static func incomeAtMostLargeOrder() -> Int {
//        if let income = realm.objects(ItemIncome.self).sorted(byKeyPath: "order", ascending: false).first {
//            return income.order
//        }
//        return 0
//    }
    
    static func atMostLargeOrder<T: ObjectBase>(type: T.Type) -> Int
    {
        if let target = realm.objects(type).sorted(byKeyPath: "order", ascending: false).first {
            return target.order
        }

        return 0
    }

//    static func shopAtMostLargeOrder() -> Int {
//        if let shop = realm.objects(Shop.self).sorted(byKeyPath: "order", ascending: false).first {
//            return shop.order
//        }
//
//        return 0
//    }
//    
//    static func paymentAtMostLargeOrder() -> Int {
//        if let payment = realm.objects(Payment.self).sorted(byKeyPath: "order", ascending: false).first {
//            return payment.order
//        }
//        
//        return 0
//    }
}



