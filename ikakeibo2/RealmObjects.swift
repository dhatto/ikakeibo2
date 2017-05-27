//
//  RealmObjects.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/05/02.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import Foundation
import RealmSwift

class ObjectBase : Object {
    dynamic var id = NSUUID().uuidString
    dynamic var name = ""
    dynamic var createDate = Date()
    dynamic var modifyDate: Date?
    dynamic var order = 0 // 降順
    
    // UIColorはそのままではRealmに格納できない。RGB要素をCGFloatで取り出しても
    // CGFloat型はプラットフォーム（CPUアーキテクチャ）によって実際の定義が変わる(swiftではstructとして定義されている）
    // ので、relamとしては非推奨となっている。
    // という事で、CGFloatをIntにキャストして格納する。
    dynamic var r = 0
    dynamic var g = 0
    dynamic var b = 0

    convenience init(name: String) {
        self.init()
        self.name = name
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}

// 支出
class Item : ObjectBase {
    static let defaultName = "支出未設定"

//    convenience init(name: String) {
//        self.init()
//        self.name = Item.defaultName
//    }
}

// 収入
class ItemIncome : ObjectBase {
    static let defaultName = "収入未設定"

//    convenience init(name: String) {
//        self.init()
//        self.name = Item.defaultName
//    }
}

// 店
class Shop : ObjectBase {
    static let defaultName = "店舗未設定"

//    convenience init(name: String) {
//        self.init()
//        self.name = Shop.defaultName
//    }
}

// 支払方法
class Payment : ObjectBase {
    static let defaultName = "支払方法未設定"
    
//    convenience init(name: String) {
//        self.init()
//        self.name = Payment.defaultName
//    }
}

//struct ConstStruct {
//    static let CostType = 32
//    static let imageMargin: CGFloat = 10.0
//    static let defaultName = "NO NAME"
//}

//enum CostType: Int {
//    case income = 1
//    case spend = 2
//}

// 支出
class Cost : Object {
    
    dynamic var id = NSUUID().uuidString
    
    //↓3つの?は取る方向で（つまりCost保存時、必ず↓3つも保存されるようにしたい。nilかどうかを意識したくないので。）
    // と思ったが、Objectの継承クラスにObjectの継承クラスを持たせる場合、Optionalじゃないと例外が出る。仕様。
    dynamic var item: Item?
    dynamic var itemIncome: ItemIncome?
    dynamic var shop: Shop?
    dynamic var payment: Payment?
    
    // 金額
    dynamic var value = 0
    // メモ
    dynamic var memo = ""
    
    // タイプ（収入 or 支出)
    dynamic var type = 1
    
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
        
        to.type = from.type
        // 収入
        if to.type == 0 {
            if let income = from.itemIncome {
                to.itemIncome = income
            }
            to.item = nil
        // 支出
        } else {
            if let item = from.item {
                to.item = item
            }
            to.itemIncome = nil
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


