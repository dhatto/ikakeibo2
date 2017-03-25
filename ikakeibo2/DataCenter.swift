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

//class kakeiboDate {
//    static func dateString() -> String {
//        let date:Date = Date() // 当日の日付を得る
//        let dateFormatter = DateFormatter()
//        
//        //表示のためにフォーマット設定
//        dateFormatter.dateFormat = "yyyy/MM/dd HH:MM:ss" // 日付フォーマットの設定
//
//        //        NSDate *nowdate = [NSDate date];
//        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        //        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//        //        NSString *datamoji = [formatter stringFromDate:nowdate];
//        var dateString = dateFormatter.string(from: date)
//        
//        return dateString
//    }
//}


class DataCenter {
    // デフォルトRealmを取得。Realmの取得はスレッドごとに１度だけ必要
    static let realm = try! Realm()

    static func readData() -> Results<Cost> {
        //let costs = realm.objects(Cost.self).filter("")
        let costs = realm.objects(Cost.self)
        
        return costs
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
}
