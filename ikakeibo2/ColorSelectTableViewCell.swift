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
        let palette = UIColor.palette
        var i = 0
        
        for paletteColor in palette {
            colorButton[i].setTitleColor(paletteColor, for: UIControlState.normal)
            i = i + 1
        }
    }

    @IBAction func colorButtonTouchUpInside(_ sender: UIButton) {
        activeButtonChanged(sender)
    }
    
    func colorButtonTouchUpInside(palletIndex: Int) {
        activeButtonChanged(colorButton[palletIndex])
    }

    func colorButtonSizeReset(color: UIColor) {
        // 前回タップされたボタンのサイズを小さくする
        if let button = _activeButton {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 28.0)
        }

//        let palette = UIColor.palette
//        var i = 0
//        
//        for paletteColor in palette {
//            if paletteColor.cgColor == color.cgColor {
//                colorButton[i].titleLabel?.font = UIFont.systemFont(ofSize: 48.0)
//                _activeButton = colorButton[i]
//            }
//            i = i + 1
//        }
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
}
