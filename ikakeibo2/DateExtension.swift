//
//  DateExtension.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/20.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import Foundation

extension Date {
    
    // 現在の年月を取得する。JST対応。
    static func currentYearMonth() -> (year: Int, month: Int) {
        let date = Date()

        let comp = DHLibrary.dhDate(toJSTComponents: date)
        
        return (comp!.year!, comp!.month!)
    }
}
