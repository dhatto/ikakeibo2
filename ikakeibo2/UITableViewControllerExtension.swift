//
//  UITableViewControllerExtension.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/05/26.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import Foundation

extension UITableViewController {
    struct SectionItem {
        var name = ""
        var value = ""
        
        init(name:String) {
            self.name = name
        }
    }
    
    struct Section {
        var name = ""
        var item : [SectionItem]
    }
}
