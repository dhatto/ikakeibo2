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
        let totalInfo = RealmDataCenter.readTotalCost(
            year: yearsSelectionView.current.year,
            month: yearsSelectionView.current.month,
            type: costTypeSegument.selectedSegmentIndex)
        
        // グラフパラメータを設定
        var params = [Dictionary<String,Float>]()
        var paramsItem = [Dictionary<String,String>]()
        var paramsColor = [Dictionary<String,UIColor>]()

        var i = 0
        var j = 0
        let sum = totalInfo.sum
        let indentStyle = paragpathTextStyle(indent: 20)
        
        for itemLabel in itemLabels {
            itemLabel.text = ""
        }

        for (key,value) in (Array(totalInfo.dic).sorted {$0.1 > $1.1}) {
            params.append(["value": Float(value)])
            paramsItem.append(["item": key])
            paramsColor.append(["color": UIColor.randomColor()])

            if itemLabels.count > i {
                let per = Int(Double(value) / Double(sum) * 100.0)
                itemLabels[i].text = String(i + 1) + "." + key + "(" + String(per) + "%" + ")"
                i = i + 1
            }

            if itemListLabels.count > j {
                let per = Int(Double(value) / Double(sum) * 100.0)
                let valueWithFormat = DHLibrary.dhStringToString(withMoneyFormat: String(value))
                
                var text = String(j + 1) + "." + key + "(" + String(per) + "%" + ")" + "\n"
                text = text + valueWithFormat!
                
                // インデント付きでテキストを設定
                let attributedString = NSAttributedString(string: text, attributes: [NSParagraphStyleAttributeName: indentStyle])
                itemListLabels[j].attributedText = attributedString

                j = j + 1
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
