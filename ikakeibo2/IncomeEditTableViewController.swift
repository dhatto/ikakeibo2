//
//  IncomeEditTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/02.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit
import RealmSwift

class IncomeEditTableViewController: UITableViewController {
    private var _incomes : Results<ItemIncome>?
    private var _incomeSelectedRow = 0
    
    static var i = 0

    //MARK: Action
    @IBAction func addButtonTapped(_ sender: Any) {
        // 1件追加して保存してreload
        RealmDataCenter.addIncome(name: "新規費目" + String(IncomeEditTableViewController.i))
        IncomeEditTableViewController.i = IncomeEditTableViewController.i + 1

        self.tableView.reloadData()
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {

        if self.isEditing {
            self.setEditing(false, animated: true)
            // 追加ボタンを使用可能に
            self.isEnabledAddButton()
        } else {
            self.setEditing(true, animated: true)
            // 編集中は、追加ボタンを使用不可能に
            self.isEnabledAddButton(enabled: false)
        }

        self.tableView.reloadData()
    }
    
    private func isEnabledAddButton(enabled:Bool = true) {
        let income = self.navigationItem.rightBarButtonItems![1]
        income.isEnabled = enabled
    }

    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationIncome.rightBarButtonIncome = self.editButtonIncome()
        
        _incomes = RealmDataCenter.readIncome()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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

        if let count = _incomes?.count {
            return count
        }

        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "incomeSelect", for: indexPath)
        let incomeSelectCell = cell as! IncomeSelectCell
        let label = incomeSelectCell.viewWithTag(1) as! UILabel
        
        if let income = _incomes?[indexPath.row] {
            incomeSelectCell.order = income.order
            #if !DEBUG
                label.text = income.name
            #else
                label.text = income.name + "(" + String(income.order) + ")"
            #endif
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            if let income = _incomes?[indexPath.row] {
                RealmDataCenter.delete(atIncome: _incomes, andTargetIncome: income)
            }
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        RealmDataCenter.changeOrder(atIncomes: _incomes, from: fromIndexPath.row, to: to.row)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _incomeSelectedRow = indexPath.row
        self.performSegue(withIdentifier: "incomeEdit", sender: self)
    }

     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let vc = segue.destination as! IncomeInputTableViewController
            vc.targetIncome = _incomes![_incomeSelectedRow]
    }
    
    @IBAction func returnActionForSegueInIncomeEditTable(_ segue : UIStoryboardSegue) {
        let vc = segue.source as! IncomeInputTableViewController

        if segue.identifier == "return" && vc.saved {
            self.tableView.reloadData()
        }
    }
}




