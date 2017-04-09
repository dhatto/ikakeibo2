//
//  ItemSelectTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/06.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit
import RealmSwift

class ItemSelectTableViewController: UITableViewController {
    private var _items : Results<Item>?
    private var _itemSelectedRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        _items = RealmDataCenter.readItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let count = _items?.count {
            return count
        }
        
        return 0
    }

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemSelect", for: indexPath)
        let itemSelectCell = cell as! ItemSelectCell
        let label = itemSelectCell.viewWithTag(1) as! UILabel

        if let item = _items?[indexPath.row] {
            itemSelectCell.order = item.order
            
            #if !DEBUG
                label.text = item.name
            #else
                label.text = item.name + "(" + String(item.order) + ")"
            #endif
        }

        return cell
     }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _itemSelectedRow = indexPath.row
        self.performSegue(withIdentifier: "back", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 選択された費目を返す
        let vc = segue.destination as! CostInputTableViewController
        vc.item = _items![_itemSelectedRow]
    }
}


