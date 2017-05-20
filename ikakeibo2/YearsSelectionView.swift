//
//  YearsSelectionView.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/05/19.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

protocol YearsSelectionDelegate {
    func leftButtonTouchUpInside() -> Void
    func rightButtonTouchUpInside() -> Void
}

class YearsSelectionView: UIView {

    @IBOutlet weak var titleLabel: UILabel!

    var delegate: YearsSelectionDelegate?
    var current : (year: Int, month: Int) = Date.currentYearMonth()

    @IBAction func leftButtonTouchUpInside(_ sender: UIButton) {
        decrementCurrentMonth()
        setTitle()

        self.delegate?.leftButtonTouchUpInside()
    }

    @IBAction func rightButtonTouchUpInside(_ sender: UIButton) {
        incrementCurrentMonth()
        setTitle()
        
        self.delegate?.rightButtonTouchUpInside()
    }
    
    // xibからインスタンス化されるので、呼び出されない
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    // この時点では、outletは接続されていない(nil)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // このタイミングなら、アウトレットは接続されている
    override func awakeFromNib() {
        setTitle()
    }

    func setTitle() {
        titleLabel.text = String(current.year) + "年" + String(current.month) + "月"
    }
    
    func decrementCurrentMonth() {
        if current.month == 1 {
            current.year = current.year - 1
            current.month = 12
            return
        }
        
        current.month = current.month - 1
    }
    
    func incrementCurrentMonth() {
        if current.month == 12 {
            current.year = current.year + 1
            current.month = 1
            return
        }
        
        current.month = current.month + 1
    }
}

