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
    private var _costs : Results<Cost>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        _costs = RealmDataCenter.readCost()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func returnActionForSegue(_ sender:UIStoryboardSegue)
    {
        let senderId = sender.identifier
        if senderId == "save" {
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let count = _costs?.count {
            return count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "costShort", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cost", for: indexPath)

        // 1 費目
        // 2 金額
        // 3 店舗
        // 4 支払方法
        // 5 メモ

        // 費目
        if let itemLabel = cell.viewWithTag(1) as? UILabel {
            if let item = _costs?[indexPath.row].item?.name {
                itemLabel.text = "■" + item
            }
        }

        // 金額
        if let costLabel = cell.viewWithTag(2) as? UILabel {
            if let cost = _costs?[indexPath.row].value {
                let costString = DHLibrary.dhStringToString(withMoneyFormat: String(cost))
                costLabel.text = costString
            }
        }

        // オプション入力項目-----------------------------------------------
        // 店舗
        if let shopLabel = cell.viewWithTag(3) as? UILabel {
            if let shopName = _costs?[indexPath.row].shop?.name {
                shopLabel.text = shopName
            } else {
                shopLabel.text = Shop.defaultName
            }
        }

        // 支払方法
        if let paymentLabel = cell.viewWithTag(4) as? UILabel {
            if let paymentName = _costs?[indexPath.row].payment?.name {
                paymentLabel.text = paymentName
            } else {
                paymentLabel.text = Payment.defaultName
            }
        }

        // メモ
        if let memoLabel = cell.viewWithTag(5) as? UILabel {
            if let memoName = _costs?[indexPath.row].memo {
                memoLabel.text = memoName
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 60.0 //cost short
        return 120.0
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
