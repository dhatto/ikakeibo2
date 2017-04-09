//
//  CostInputTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/02.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class CostInputTableViewController: UITableViewController {
    var item = Item()
    var shop = Shop()
    var payment = Payment()
    
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

        // test code
        let cost = Cost()
        cost.item = item
        cost.shop = shop
        cost.payment = payment
        
        cost.value = 10000
        cost.memo = "メモです"

        RealmDataCenter.save(cost: cost)

        self.dismiss(animated: true) {
        }
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

        switch (indexPath.section, indexPath.row) {
            case (0, 0):
                let label = cell.viewWithTag(1) as! UILabel
                label.text = item.name
            case (1, 1):
                let label = cell.viewWithTag(1) as! UILabel
                label.text = shop.name
            case (1, 2):
                let label = cell.viewWithTag(1) as! UILabel
                label.text = payment.name

            default:
                break;
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 40
        case (0, 1):
            return 80
        default:
            break;
        }

        return 60
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _sectionList[section].name
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }

    @IBAction func returnActionForSegueInCostInputTableView(_ segue : UIStoryboardSegue) {
        tableView.reloadData()
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
