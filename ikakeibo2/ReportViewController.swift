//
//  ReportViewController.swift
//  ikakeibo2
//
//  Created by hattori on 2017/05/17.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, YearsSelectionDelegate {

    private var yearsSelectionView: YearsSelectionView!
    private var graphView: CircleGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var params = [Dictionary<String,Float>]()
        var paramsColor = [Dictionary<String,UIColor>]()
        
        // valueは単なる割合。合計で100にならなくても計算される。
        params.append(["value":25.0])
        params.append(["value":17.0])
        params.append(["value":13.0])
        params.append(["value":8.0])
        params.append(["value":37.0])

        paramsColor.append(["color": UIColor.red])
        paramsColor.append(["color": UIColor.green])
        paramsColor.append(["color": UIColor.blue])
        paramsColor.append(["color": UIColor.yellow])
        paramsColor.append(["color": UIColor.brown])

        graphView = view.viewWithTag(1) as! CircleGraphView
        graphView.setParams(params: params, paramsColor: paramsColor)
        graphView.startAnimating()

        setTitleView()
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
    }
    
    func leftButtonTouchUpInside() {
    }
}
