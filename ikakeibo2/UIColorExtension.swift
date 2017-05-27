//
//  File.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/05/26.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import Foundation

extension UIColor {
    static func rgb(r: Int, g: Int, b: Int) -> UIColor {
        // alpha 1.0 = 不透明度100%
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
}
