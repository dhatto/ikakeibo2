//
//  ColorSelectTableViewCell.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/05/27.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

protocol ColorChangeDelegate {
    func colorChange(color: UIColor) -> Void
}

class ColorSelectTableViewCell: UITableViewCell {
    
    @IBOutlet var colorButton: [UIButton]!
    var _activeButton: UIButton? = nil
    var delegate: ColorChangeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        colorButton[0].setTitleColor(UIColor.rgb(r: 230, g: 0, b: 18), for: UIControlState.normal)
        colorButton[1].setTitleColor(UIColor.rgb(r: 235, g: 97, b: 0), for: UIControlState.normal)
        colorButton[2].setTitleColor(UIColor.rgb(r: 243, g: 152, b: 0), for: UIControlState.normal)
        colorButton[3].setTitleColor(UIColor.rgb(r: 252, g: 200, b: 0), for: UIControlState.normal)
        colorButton[4].setTitleColor(UIColor.rgb(r: 255, g: 251, b: 0), for: UIControlState.normal)
        colorButton[5].setTitleColor(UIColor.rgb(r: 207, g: 219, b: 0), for: UIControlState.normal)
        colorButton[6].setTitleColor(UIColor.rgb(r: 143, g: 195, b: 31), for: UIControlState.normal)
        colorButton[7].setTitleColor(UIColor.rgb(r: 34, g: 172, b: 56), for: UIControlState.normal)
        colorButton[8].setTitleColor(UIColor.rgb(r: 0, g: 153, b: 68), for: UIControlState.normal)
        colorButton[9].setTitleColor(UIColor.rgb(r: 0, g: 155, b: 107), for: UIControlState.normal)
        colorButton[10].setTitleColor(UIColor.rgb(r: 0, g: 158, b: 150), for: UIControlState.normal)
        colorButton[11].setTitleColor(UIColor.rgb(r: 0, g: 160, b: 193), for: UIControlState.normal)
        
        colorButton[12].setTitleColor(UIColor.rgb(r: 0, g: 160, b: 233), for: UIControlState.normal)
        colorButton[13].setTitleColor(UIColor.rgb(r: 0, g: 134, b: 209), for: UIControlState.normal)
        colorButton[14].setTitleColor(UIColor.rgb(r: 0, g: 104, b: 183), for: UIControlState.normal)
        colorButton[15].setTitleColor(UIColor.rgb(r: 0, g: 71, b: 157), for: UIControlState.normal)
        colorButton[16].setTitleColor(UIColor.rgb(r: 29, g: 32, b: 136), for: UIControlState.normal)
        colorButton[17].setTitleColor(UIColor.rgb(r: 96, g: 25, b: 134), for: UIControlState.normal)
        colorButton[18].setTitleColor(UIColor.rgb(r: 146, g: 7, b: 131), for: UIControlState.normal)
        colorButton[19].setTitleColor(UIColor.rgb(r: 190, g: 0, b: 129), for: UIControlState.normal)
        colorButton[20].setTitleColor(UIColor.rgb(r: 228, g: 0, b: 127), for: UIControlState.normal)
        colorButton[21].setTitleColor(UIColor.rgb(r: 229, g: 0, b: 106), for: UIControlState.normal)
        colorButton[22].setTitleColor(UIColor.rgb(r: 229, g: 0, b: 79), for: UIControlState.normal)
        colorButton[23].setTitleColor(UIColor.rgb(r: 0, g: 0, b: 0), for: UIControlState.normal)

    }

    @IBAction func colorButtonTouchUpInside(_ sender: UIButton) {
        if let button = _activeButton {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 28.0)
        }

        sender.titleLabel?.font = UIFont.systemFont(ofSize: 48.0)
        
        // TableViewControllerに通知
        if let color = sender.titleLabel?.textColor {
            delegate?.colorChange(color: color)
        }
        
        _activeButton = sender
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
