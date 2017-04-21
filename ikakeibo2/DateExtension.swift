//
//  DateExtension.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/20.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import Foundation

extension Date {
    
    static func currentYearMonth() -> (year: Int, month: Int) {
        let date = Date()

        let comp = DHLibrary.dhDate(toJSTComponents: date)
        
        return (comp!.year!, comp!.month!)
    }
}
