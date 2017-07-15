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
        let pallet = UIColor.pallet
        var i = 0
        
        for palletColor in pallet {
            colorButton[i].setTitleColor(palletColor, for: UIControlState.normal)
            i = i + 1
        }
    }

    @IBAction func colorButtonTouchUpInside(_ sender: UIButton) {
        activeButtonChanged(sender)
    }
    
    func colorButtonTouchUpInside(palletIndex: Int) {
        activeButtonChanged(colorButton[palletIndex])
    }
    
    func activeButtonChanged(_ sender: UIButton) {
        // 前回タップされたボタンのサイズを小さくする
        if let button = _activeButton {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 28.0)
        }
        
        _activeButton = sender
        _activeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 48.0)
        
        // TableViewControllerに通知
        if let color = sender.titleLabel?.textColor {
            delegate?.colorChange(color: color)
        }
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
