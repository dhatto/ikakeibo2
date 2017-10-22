//
//  SearchTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/07/30.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var costTypeSegument: UISegmentedControl!
    
    @IBAction func costTypeSegumentValueChanged(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    @IBAction func searchButtonTouchUpInside(_ sender: UIButton, forEvent event: UIEvent) {
        let storyBoard = UIStoryboard(name: "CostList", bundle: nil)
        let nav = storyBoard.instantiateInitialViewController() as! UINavigationController
        let vc = nav.viewControllers[0] as! CostTableViewController

        // ここに検索条件を格納
        vc.searchCondition = RealmSearchCondition()
        vc.searchCondition.target = SeachTarget.Cost
        vc.isSearching = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    var _sectionList = [
        // 収入
        Section(name: "",
            item: [SectionItem(name: "valueRange"),
                   SectionItem(name: "timesRange"),
                   SectionItem(name: "itemsIncomeRange"),
                   SectionItem(name: "start")]
        ),
        // 支出
        Section(name: "",
            item: [SectionItem(name: "valueRange"),
                   SectionItem(name: "timesRange"),
                   SectionItem(name: "itemsRange"),
                   SectionItem(name: "shopRange"),
                   SectionItem(name: "paymentRange"),
                   SectionItem(name: "start")]
        )
    ]

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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.costTypeSegument.selectedSegmentIndex == 0 ? 4 : 6
        return _sectionList[self.costTypeSegument.selectedSegmentIndex].item.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = _sectionList[
            self.costTypeSegument.selectedSegmentIndex].item[indexPath.row].name

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        return cell
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
