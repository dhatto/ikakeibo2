//
//  IncomeSelectCell.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/04.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class IncomeSelectCell: UITableViewCell {
    var order : Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        order = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
