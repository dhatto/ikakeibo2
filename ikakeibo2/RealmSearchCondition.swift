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

struct RangeOfAmounts {
    var min = 0
    var max = 0

    init(min:Int, max:Int) {
        self.min = min
        self.max = max
    }
};

class RealmSearchCondition: Object {
    var target = SeachTarget.Cost
    var rangeOfAmounts = RangeOfAmounts(min: 0, max: 0)
}
