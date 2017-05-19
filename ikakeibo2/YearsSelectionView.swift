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

    @IBOutlet weak var yearsLabel: UILabel!

    var delegate: YearsSelectionDelegate?

    @IBAction func leftButtonTouchUpInside(_ sender: UIButton) {
        self.delegate?.leftButtonTouchUpInside()
    }

    @IBAction func rightButtonTouchUpInside(_ sender: UIButton) {
        self.delegate?.rightButtonTouchUpInside()
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
}

