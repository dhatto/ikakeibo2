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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleView()
        totalizeCosts()
    }

    @IBAction func costTypeSegumentValueChanged(_ sender: UISegmentedControl) {
        totalizeCosts()
    }
    
    func setSummaryText(inComeTotal: Int, itemTotal: Int) {
        let incomeValueWithFormat = DHLibrary.dhStringToString(withMoneyFormat: String(inComeTotal))
        let itemValueWithFormat = DHLibrary.dhStringToString(withMoneyFormat: String(itemTotal))
        
        var itemLabelText = "収入：" + incomeValueWithFormat! + "\n" + "支出：" + itemValueWithFormat!
        
        if let totalValueWithFormat = DHLibrary.dhStringToString(withMoneyFormat: String(inComeTotal - itemTotal)) {
            itemLabelText = itemLabelText + "\n" + "収支：" + totalValueWithFormat
        }
        
        // 0,1,3,4は使ってない
        itemLabels[2].text = itemLabelText
    }
    
    func setItemBest10(number: Int, key: String, itemTotal : Int, value: Int) {

        // 下段に支出ベスト10を表示
        if itemListLabels.count > number {
            let per = Int(Double(value) / Double(itemTotal) * 100.0)
            let valueWithFormat = DHLibrary.dhStringToString(withMoneyFormat: String(value))
            
            var text = String(number + 1) + "." + key + "(" + String(per) + "%" + ")" + "\n"
            text = text + valueWithFormat!

            // インデント付きでテキストを設定
            let indentStyle = paragpathTextStyle(indent: 20)
            let attributedString = NSAttributedString(string: text, attributes: [NSParagraphStyleAttributeName: indentStyle])
            itemListLabels[number].attributedText = attributedString
        }
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
        
        // 今月の、収入/支出/収支を表示
        setSummaryText(inComeTotal: inComeTotal.sum, itemTotal: itemTotal.sum)

        var i = 0

        // グラフパラメータを設定
        var params = [Dictionary<String,Float>]()
        var paramsItem = [Dictionary<String,String>]()
        var paramsColor = [Dictionary<String,UIColor>]()

        for (key, value) in (Array(itemTotal.dic).sorted {$0.1 > $1.1}) {
            params.append(["value": Float(value)])
            paramsItem.append(["item": key])
            paramsColor.append(["color": UIColor.randomColor()])

            setItemBest10(number: i, key: key, itemTotal: itemTotal.sum, value: value)
            i = i + 1
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
