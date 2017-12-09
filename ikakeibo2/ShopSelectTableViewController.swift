//
//  ShopSelectTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/06.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit
import RealmSwift

class ShopSelectTableViewController: UITableViewController {
    private var _shops : Results<Shop>?
    private var _shopSelectedRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationShop.rightBarButtonShop = self.editButtonShop()
        _shops = RealmDataCenter.read(type: Shop.self)
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
        
        if let count = _shops?.count {
            return count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopSelect", for: indexPath)
        let shopSelectCell = cell as! ShopSelectCell
        let label = shopSelectCell.viewWithTag(1) as! UILabel

        if let shop = _shops?[indexPath.row] {
            shopSelectCell.order = shop.order

            #if !DEBUG
                label.text = shop.name
            #else
                label.text = shop.name + "(" + String(shop.order) + ")"
            #endif
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _shopSelectedRow = indexPath.row
        self.performSegue(withIdentifier: "backFromShopSelect", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CostInputTableViewController {
            vc.inputData.shop = _shops![_shopSelectedRow]
        } else if let vc = segue.destination as? SearchTableViewController {
            vc.shopName = _shops![_shopSelectedRow].name
        }
    }
}

