//
//  ReportViewController.swift
//  ikakeibo2
//
//  Created by hattori on 2017/05/17.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

extension UIColor {
    class func randomColor() -> UIColor {

        let r = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let g = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let b = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        return UIColor.init(red: r, green: g, blue: b, alpha: 0.5)
    }
}

class ReportViewController: UIViewController, YearsSelectionDelegate {

    @IBOutlet var itemLabels: [UILabel]!
    
    @IBOutlet var itemListLabels: [UILabel]!

    private var yearsSelectionView: YearsSelectionView!
    private var graphView: CircleGraphView!

    @IBOutlet weak var costTypeSegument: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleView()
        totalizeCosts()
    }

    @IBAction func costTypeSegumentValueChanged(_ sender: UISegmentedControl) {
        totalizeCosts()
    }

    func totalizeCosts() {
        // 項目ごとの集計結果を取得
        let inComeTotal = RealmDataCenter.readTotalCost(
            year: yearsSelectionView.current.year,
            month: yearsSelectionView.current.month,
            type: 0)
        
        let itemTotal = RealmDataCenter.readTotalCost(
            year: yearsSelectionView.current.year,
            month: yearsSelectionView.current.month,
            type: 1)
        
        print(inComeTotal)
        print(itemTotal)
        
        // グラフパラメータを設定
        var params = [Dictionary<String,Float>]()
        var paramsItem = [Dictionary<String,String>]()
        var paramsColor = [Dictionary<String,UIColor>]()

        var i = 0
        let sum = inComeTotal.sum
        let indentStyle = paragpathTextStyle(indent: 20)
        
        let incomeValueWithFormat = DHLibrary.dhStringToString(withMoneyFormat: String(inComeTotal.sum))
        let itemValueWithFormat = DHLibrary.dhStringToString(withMoneyFormat: String(itemTotal.sum))
        
        itemLabels[0].text = "収入：" + incomeValueWithFormat! + "\n" + "支出：" + itemValueWithFormat!

        for (key,value) in (Array(itemTotal.dic).sorted {$0.1 > $1.1}) {
            params.append(["value": Float(value)])
            paramsItem.append(["item": key])
            paramsColor.append(["color": UIColor.randomColor()])

            // 下段に支出ベスト10を表示
            if itemListLabels.count > i {
                let per = Int(Double(value) / Double(sum) * 100.0)
                let valueWithFormat = DHLibrary.dhStringToString(withMoneyFormat: String(value))
                
                var text = String(i + 1) + "." + key + "(" + String(per) + "%" + ")" + "\n"
                text = text + valueWithFormat!
                
                // インデント付きでテキストを設定
                let attributedString = NSAttributedString(string: text, attributes: [NSParagraphStyleAttributeName: indentStyle])
                itemListLabels[i].attributedText = attributedString

                i = i + 1
            }
        }

        // グラフ表示
        graphView = view.viewWithTag(1) as! CircleGraphView
        graphView.setParams(params: params, paramsItem: paramsItem, paramsColor: paramsColor)
        graphView.startAnimating()
    }
    
    func paragpathTextStyle(indent: CGFloat) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        paragraphStyle.headIndent = indent
        //paragraphStyle.tailIndent = -20
        
        return paragraphStyle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //graphView.startAnimating()
    }

    func setTitleView() {
        yearsSelectionView = UINib(nibName: "YearsSelectionView", bundle: nil)
            .instantiate(withOwner: self, options: nil).first as! YearsSelectionView
        yearsSelectionView.delegate = self
        
        self.navigationItem.titleView = yearsSelectionView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:YearsSelectionDelegate
    func rightButtonTouchUpInside() {
        totalizeCosts()
    }
    
    func leftButtonTouchUpInside() {
        totalizeCosts()
    }
}
