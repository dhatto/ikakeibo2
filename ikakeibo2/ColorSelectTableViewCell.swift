//
//  ColorSelectTableViewCell.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/05/27.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class ColorSelectTableViewCell: UITableViewCell {
    
    @IBOutlet var colorButton: [UIButton]!

    override func awakeFromNib() {
        super.awakeFromNib()

        colorButton[0].setTitleColor(UIColor.rgb(r: 255, g: 0, b: 0), for: UIControlState.normal)
        colorButton[1].setTitleColor(UIColor.rgb(r: 128, g: 128, b: 128), for: UIControlState.normal)
        colorButton[2].setTitleColor(UIColor.rgb(r: 0, g: 255, b: 0), for: UIControlState.normal)
        colorButton[3].setTitleColor(UIColor.rgb(r: 0, g: 255, b: 255), for: UIControlState.normal)
        colorButton[4].setTitleColor(UIColor.rgb(r: 0, g: 0, b: 255), for: UIControlState.normal)
        colorButton[5].setTitleColor(UIColor.rgb(r: 128, g: 0, b: 0), for: UIControlState.normal)
        colorButton[6].setTitleColor(UIColor.rgb(r: 0, g: 128, b: 0), for: UIControlState.normal)
        colorButton[7].setTitleColor(UIColor.rgb(r: 0, g: 0, b: 128), for: UIControlState.normal)
        colorButton[8].setTitleColor(UIColor.rgb(r: 255, g: 0, b: 128), for: UIControlState.normal)
        colorButton[9].setTitleColor(UIColor.rgb(r: 255, g: 128, b: 0), for: UIControlState.normal)
        colorButton[10].setTitleColor(UIColor.rgb(r: 0, g: 128, b: 32), for: UIControlState.normal)
        colorButton[11].setTitleColor(UIColor.rgb(r: 255, g: 255, b: 0), for: UIControlState.normal)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
