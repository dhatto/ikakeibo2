//
//  IncomeSelectTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/06.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit
import RealmSwift

class IncomeSelectTableViewController: UITableViewController {
    private var _incomes : Results<ItemIncome>?
    private var _incomeSelectedRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationIncome.rightBarButtonIncome = self.editButtonIncome()
        _incomes = RealmDataCenter.readIncome()
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _incomeSelectedRow = indexPath.row
        self.performSegue(withIdentifier: "backFromIncomeSelect", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CostInputTableViewController
        vc.inputData.itemIncome = _incomes![_incomeSelectedRow]
    }
}


