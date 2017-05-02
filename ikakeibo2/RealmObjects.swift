//
//  RealmObjects.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/05/02.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import Foundation
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


