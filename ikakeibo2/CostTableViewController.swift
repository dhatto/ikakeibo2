//
//  CostTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/03/15.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit
import RealmSwift

class CostTableViewController: UITableViewController {
//    private var _costs : Results<Cost>?
    private var _costs : [Section] = [Section]()
    private var _current : (year: Int, month: Int) = Date.currentYearMonth()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadCosts()
    }
    
    func loadCosts() {
        _costs = RealmDataCenter.readCost(year: _current.year, month: _current.month)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // タブ切り替えとか、保存したあと戻ってくるとか、再表示の度に呼び出されるので、
        // できればここでreloadData()はしたくない。
        //self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func returnActionForSegueInCostList(_ sender:UIStoryboardSegue)
    {
        let senderId = sender.identifier
        if senderId == "save" {
            loadCosts()
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "セクションよー"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return _costs.count
//        let sections = RealmDataCenter.numberOf(year: _current.year, month: _current.month)
//        
//        return sections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _costs[section].item.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cost", for: indexPath)

        // 1 費目
        // 2 金額
        // 3 店舗(支払方法)
        // 4 メモ
        guard let cost = _costs[indexPath.section].item[indexPath.row].cost else {
            return cell
        }

        // 費目
        if let itemLabel = cell.viewWithTag(1) as? UILabel {
            if let item = cost.item?.name {
                itemLabel.text = "■" + item
            }
        }

        // 金額
        if let costLabel = cell.viewWithTag(2) as? UILabel {
            let costString = DHLibrary.dhStringToString(withMoneyFormat: String(cost.value))
            costLabel.text = costString
        }

        // オプション入力項目-----------------------------------------------
        // 店舗(支払い方法)
        if let shopLabel = cell.viewWithTag(3) as? UILabel {
            if let shopName = cost.shop?.name {
                shopLabel.text = shopName
            } else {
                //shopLabel.text = Shop.defaultName
            }
            
            if let paymentName = cost.payment?.name {
                shopLabel.text = shopLabel.text! + "(" + paymentName + ")"
            } else {
                //shopLabel.text = Payment.defaultName
            }
        }

        // メモ
        if let memoLabel = cell.viewWithTag(4) as? UILabel {
            memoLabel.text = cost.memo
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
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
