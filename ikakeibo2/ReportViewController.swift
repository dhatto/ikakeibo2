//
//  ReportViewController.swift
//  ikakeibo2
//
//  Created by hattori on 2017/05/17.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, YearsSelectionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        var params = [Dictionary<String,Float>]()
        var paramsColor = [Dictionary<String,UIColor>]()
        
        params.append(["value":7.0])
        params.append(["value":5.0])
        params.append(["value":8.0])
        params.append(["value":10.0])
        
        paramsColor.append(["color": UIColor.red])
        paramsColor.append(["color": UIColor.green])
        paramsColor.append(["color": UIColor.blue])
        paramsColor.append(["color": UIColor.yellow])
        
//        params.append(["value":7 as AnyObject,  "color":UIColor.red])
//        params.append(["value":5 as AnyObject,  "color":UIColor.blue])
//        params.append(["value":8 as AnyObject,  "color":UIColor.green])
//        params.append(["value":10 as AnyObject, "color":UIColor.yellow])
        
//        graphView = CircleGraphView(frame: CGRectMake(0, 30, 320, 320), params: params)
//        self.view.addSubview(graphView)
        let graphView = view.viewWithTag(1) as! CircleGraphView
        graphView.setParams(params: params, paramsColor: paramsColor)
        graphView.startAnimating()
        
//        if let view = UINib(nibName: "YearsSelectionView", bundle: nil).instantiateWithOwner(self, options: nil).first as? UIView {
//            self.view = view
//        }
//        UINib *nib = [UINib nibWithNibName:@"YearsSelectionView" bundle:nil]; [nib instantiateWithOwner:self options:nil]; }

        let view2 = UINib(nibName: "YearsSelectionView", bundle: nil).instantiate(withOwner: self, options: nil).first as! YearsSelectionView
        view2.delegate = self
        self.navigationItem.titleView = view2 as UIView
    }

    func rightButtonTouchUpInside() {
        var i = "test"
        i = "abc"
    }
    
    func leftButtonTouchUpInside() {
        var i = "test"
        i = "abc"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
