//
//  File.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/05/26.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import Foundation

extension UIColor {

    static var pallet: [UIColor] {
        get {
            var result = [UIColor]()

            result.append(UIColor.rgb(r: 0, g: 0, b: 0))
            result.append(UIColor.rgb(r: 230, g: 0, b: 18))
            result.append(UIColor.rgb(r: 235, g: 97, b: 0))
            result.append(UIColor.rgb(r: 243, g: 152, b: 0))
            result.append(UIColor.rgb(r: 252, g: 200, b: 0))
            result.append(UIColor.rgb(r: 255, g: 251, b: 0))
            result.append(UIColor.rgb(r: 207, g: 219, b: 0))
            result.append(UIColor.rgb(r: 143, g: 195, b: 31))
            result.append(UIColor.rgb(r: 34, g: 172, b: 56))
            result.append(UIColor.rgb(r: 0, g: 153, b: 68))
            result.append(UIColor.rgb(r: 0, g: 155, b: 107))
            result.append(UIColor.rgb(r: 0, g: 158, b: 150))
            result.append(UIColor.rgb(r: 0, g: 160, b: 193))
            result.append(UIColor.rgb(r: 0, g: 160, b: 233))
            result.append(UIColor.rgb(r: 0, g: 134, b: 209))
            result.append(UIColor.rgb(r: 0, g: 104, b: 183))
            result.append(UIColor.rgb(r: 0, g: 71, b: 157))
            result.append(UIColor.rgb(r: 29, g: 32, b: 136))
            result.append(UIColor.rgb(r: 96, g: 25, b: 134))
            result.append(UIColor.rgb(r: 146, g: 7, b: 131))
            result.append(UIColor.rgb(r: 190, g: 0, b: 129))
            result.append(UIColor.rgb(r: 228, g: 0, b: 127))
            result.append(UIColor.rgb(r: 229, g: 0, b: 106))
            result.append(UIColor.rgb(r: 229, g: 0, b: 79))

            return result
        }
    }

    static func rgb(r: Int, g: Int, b: Int) -> UIColor {
        // alpha 1.0 = 不透明度100%
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
}

