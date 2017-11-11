//
//  ValueRangeViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/10/22.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class ValueRangeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    fileprivate var listMin : [String] = []
    fileprivate var listMax : [String] = []
    
    
    @IBOutlet weak var valueRangePicker: UIPickerView!

    // TODO: ViewControllerDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetDataSource(1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     // In a storyboard-based application, you will often want to do a little preparation before navigation
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let min = listMin[valueRangePicker.selectedRow(inComponent: 0)]
        let max = listMax[valueRangePicker.selectedRow(inComponent: 2)]
        
        if let vc = segue.destination as? SearchTableViewController {
            vc.valueRange.removeAll()
            vc.valueRange.append(min)
            vc.valueRange.append(max)
        }
     }

    // MARK: PickerViewDelegate
    // 列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    // 列ごとの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            return 1
        }
        
        return listMin.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return listMin[row]

        case 1:
            return "〜"

        default:
            return listMax[row]
        }
    }

    //　色をカスタマイズなどできる
//    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//
//    }

//    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 1 {
            return 40.0
        }
        return 150.0
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coordinatePickerViewSelectedStatus(component: component, changeRow: row)
    }
    
    // MARK: PickerViewSetting
    fileprivate func coordinatePickerViewSelectedStatus(component: Int, changeRow: Int) {
        //選択状態を調整したい（minを¥4,000にした時に、maxが¥1,000だったら、maxを¥4,000にする等）
        if component == 0 {
            let maxRowSelectedIndex = valueRangePicker.selectedRow(inComponent: 2)
            if changeRow > maxRowSelectedIndex {
                valueRangePicker.selectRow(changeRow, inComponent: 2, animated: true)
            }
        } else if component == 2 {
            let minRowSelectedIndex = valueRangePicker.selectedRow(inComponent: 0)
            if changeRow < minRowSelectedIndex {
                valueRangePicker.selectRow(changeRow, inComponent: 0, animated: true)
            }
        }
    }

    fileprivate func resetDataSource(_ index: Int) {
        switch index {
        case 0:
            listMin = ["¥100","¥200","¥300","¥400","¥500","¥600","¥700","¥800","¥900","¥1,000"]
            listMax = ["¥100","¥200","¥300","¥400","¥500","¥600","¥700","¥800","¥900","¥1,000"]
        case 1:
            listMin = ["¥1,000","¥2,000","¥3,000","¥4,000","¥5,000","¥6,000","¥7,000","¥8,000","¥9,000", "¥10,000"]
            listMax = ["¥1,000","¥2,000","¥3,000","¥4,000","¥5,000","¥6,000","¥7,000","¥8,000","¥9,000", "¥10,000"]
        default:
            listMin = ["¥10,000","¥20,000","¥30,000","¥40,000","¥50,000","¥60,000","¥70,000","¥80,000","¥90,000", "¥100,000"]
            listMax = ["¥10,000","¥20,000","¥30,000","¥40,000","¥50,000","¥60,000","¥70,000","¥80,000","¥90,000", "¥100,000"]
        }
    }

    fileprivate func reloadValueRangePicker() {
        valueRangePicker.reloadAllComponents()
        valueRangePicker.selectRow(0, inComponent: 0, animated: true)
        valueRangePicker.selectRow(0, inComponent: 2, animated: true)
    }

    // MARK: Event
    @IBAction func valueSegumentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex

        resetDataSource(index)
        reloadValueRangePicker()
    }
}
