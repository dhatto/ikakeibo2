//
//  CostInputViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/03/31.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class CostInputViewController: UIViewController {
    struct InputData {
        var item:String = ""
        var value:Int = 0
    }
    
    private var _inputData = InputData(item: "", value: 0)
    
    var inputData:InputData {
        get {
            
            if _inputData.value != 0 && _inputData.item != "" {
                return _inputData
            }
            
            var result = InputData(item: "", value: 0)
            
//            if let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) {
//                let inputCell = cell as! CostInputCell
//                let cost = inputCell.moneyInputField.text!
//                
//                result.item = "交際費"
//                result.value = Int(cost)!
//            }
            
            result.item = "交際費"
            result.value = 100

            _inputData = result
            
            return result
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTouch(_ sender: Any) {

    }

    @IBAction func saveButtonTouchUpInside(_ sender: Any) {
        let source = self.inputData
        DataCenter.saveData(itemName: source.item, value: source.value)
        
        // リストタブを選択状態に
        self.tabBarController?.selectedIndex = 0
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
