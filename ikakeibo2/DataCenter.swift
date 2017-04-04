//
//  DataCenter.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/04.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import Foundation


class DataCenter {

    class Item : Object {
        dynamic var id = ""
        dynamic var name = ""
        dynamic var createDate = NSDate()
        dynamic var modifyDate: NSDate?
        dynamic var order = 0 // 降順
    }

    let Item: [String:Any] = [
        "id": 12,
        "name": "Jack Dorsey",
        "order": "0"
    ]

    init() {
        
    }
}
