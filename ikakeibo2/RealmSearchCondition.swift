//
//  RealmSearchCondition.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/10/22.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit
import RealmSwift

enum SeachTarget: Int {
    case InCome = 0
    case Cost = 1
}

class RealmSearchCondition: Object {
    var target = SeachTarget.Cost
}
