//
//  CostInputTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/02.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class CostInputTableViewController: UITableViewController {
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

    struct SectionItem {
        var name = ""
    }
    
    struct Section {
        var name = ""
        var item : [SectionItem]
    }
    
    let _sectionList = [
        Section(name: "入力",
                item: [SectionItem(name: "selectItem"),
                       SectionItem(name: "inputCost")]),
        Section(name: "オプション",
                item: [SectionItem(name: "date"),
                       SectionItem(name: "shop"),
                       SectionItem(name: "howTo"),
                       SectionItem(name: "memo")])
    ]

    @IBAction func cancelButtonTapped(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true) {
            
        }
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
//        let source = self.inputData
//        RealmDataCenter.saveData(itemName: source.item, value: source.value)
//
//        // 画面を閉じる
//        self.dismiss(animated: true) {
//            
//        }
    }
    
    @IBAction func returnActionForSegue(_ sender:UIStoryboardSegue)
    {
        let senderId = sender.identifier
        if senderId == "save" {
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return _sectionList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return _sectionList[section].item.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = _sectionList[indexPath.section].item[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _sectionList[section].name
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
