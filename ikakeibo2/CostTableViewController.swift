//
//  CostTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/03/15.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit
import RealmSwift

class CostTableViewController: UITableViewController, YearsSelectionDelegate {

    private var _costs : [CostSection] = [CostSection]()
    private var yearsSelectionView: YearsSelectionView!

    @IBOutlet weak var costTypeSegument: UISegmentedControl!
    
    @IBAction func costTypeValueChanged(_ sender: UISegmentedControl) {
        loadCosts(type: sender.selectedSegmentIndex)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.leftBarButtonItem
//        self.navigationItem.rightBarButtonItem
//        self.navigationItem.backBarButtonItem
        setTitleView()

        loadCosts(type: costTypeSegument.selectedSegmentIndex)
    }
    
    func setTitleView() {
        yearsSelectionView = UINib(nibName: "YearsSelectionView", bundle: nil)
            .instantiate(withOwner: self, options: nil).first as! YearsSelectionView
        yearsSelectionView.delegate = self
        
        self.navigationItem.titleView = yearsSelectionView
    }
    
    // MARK: YearsSelectionViewDelegate
    func leftButtonTouchUpInside() {
        loadCosts(type: costTypeSegument.selectedSegmentIndex)
        self.tableView.reloadData()
    }
    
    func rightButtonTouchUpInside() {
        loadCosts(type: costTypeSegument.selectedSegmentIndex)
        self.tableView.reloadData()
    }
    
    func loadCosts(type: Int) {
        _costs = RealmDataCenter.readCost(year: yearsSelectionView.current.year,
                                          month: yearsSelectionView.current.month,
                                          type: type)
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
            loadCosts(type: costTypeSegument.selectedSegmentIndex)
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _costs[section].name
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return _costs.count
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

        setup(targetCell: cell, costData: cost)

        return cell
    }
    
    func setupTitleLabel(targetCell cell: UITableViewCell, costData cost: Cost) {
        guard let itemLabel = cell.viewWithTag(1) as? UILabel,
            let headerLabel = cell.viewWithTag(5) as? UILabel else {
                return
        }
        
        itemLabel.text = Item.defaultName
        headerLabel.textColor = Item.defaultColor

        switch cost.type {
        case balanceTypeIncome:
            if let itemIncome = cost.itemIncome {
                itemLabel.text = itemIncome.name
                headerLabel.textColor = itemIncome.color()
            }
        default:
            if let item = cost.item {
                itemLabel.text = item.name
                headerLabel.textColor = item.color()
            }
        }
    }
    
    func setupValueLabel(targetCell cell: UITableViewCell, costData cost: Cost) {
        // 金額
        guard let costLabel = cell.viewWithTag(2) as? UILabel else {
            return
        }
        
        let costString = DHLibrary.dhStringToString(withMoneyFormat: String(cost.value))
        costLabel.text = costString
    }

    func setupOptionInfoLabel(targetCell cell: UITableViewCell, costData cost: Cost) {
        guard let shopLabel = cell.viewWithTag(3) as? UILabel,
            let memoLabel = cell.viewWithTag(4) as? UILabel else {
                return
        }

        if cost.type == balanceTypePayment {
            if let shopName = cost.shop?.name {
                shopLabel.text = shopName
                
                if let payment = cost.payment?.name {
                    shopLabel.text = shopLabel.text! + "(" + payment + ")"
                }
                
            } else {
                shopLabel.text = Shop.defaultName
            }
            
            memoLabel.text = cost.memo
        // 支出の場合は表示しない。
        } else {
            shopLabel.text = ""
            memoLabel.text = ""
        }
    }

    func setup(targetCell cell: UITableViewCell, costData cost: Cost) {
        setupTitleLabel(targetCell: cell, costData: cost)
        setupValueLabel(targetCell: cell, costData: cost)
        
        // オプション入力項目(支出の場合のみ表示)
        setupOptionInfoLabel(targetCell: cell, costData: cost)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            self.presentPreDeleteAlert(selectedIndexPath: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func deleteCost(at indexPath: IndexPath) {
        RealmDataCenter.delete(atCost: _costs[indexPath.section].item[indexPath.row].cost!)
        self.loadCosts(type: costTypeSegument.selectedSegmentIndex)
        tableView.reloadData()
    }

    func presentPreDeleteAlert(selectedIndexPath path : IndexPath) {
        
        let alert: UIAlertController = UIAlertController(title: "確認", message: "削除しますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
                // 確認OKなので、ここで初めてコストを削除する。
                self.deleteCost(at: path)
            })
        
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
                self.tableView.reloadData()
                // この方法だと、消える時のアニメーションが汚い。
                //self.tableView.reloadRows(at: [path], with: UITableViewRowAnimation.automatic)
            })

        alert.addAction(cancelAction)
        alert.addAction(defaultAction)

        present(alert, animated: true, completion: nil)
    }

    func presentCostActionSheet(atPath : IndexPath) {
        let actionSheet:UIAlertController = UIAlertController(title:"アクション選択",
                                                              message: nil,
                                                              preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: UIAlertActionStyle.cancel,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
        })
        
        let editAction:UIAlertAction = UIAlertAction(title: "編集",
                                                     style: UIAlertActionStyle.default,
                                                     handler:
            {
                (action:UIAlertAction!) -> Void in
                    let tabBarController = self.tabBarController as! MainTabBarController
                    tabBarController.showCostInputView(savedData: self._costs[atPath.section].item[atPath.row].cost!)
            }
        )

        let deleteAction:UIAlertAction = UIAlertAction(title: "削除",
                                                       style: UIAlertActionStyle.destructive,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
                                                        self.presentPreDeleteAlert(selectedIndexPath: atPath)
        })

        //AlertもActionSheetも同じ
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)

        //表示。UIAlertControllerはUIViewControllerを継承している。
        present(actionSheet, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.presentCostActionSheet(atPath: indexPath)
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
