//
//  ItemEditTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/02.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit
import RealmSwift

class ItemEditTableViewController: UITableViewController {
    private var _items : Results<Item>?
    private var _itemSelectedRow = 0
    
    static var i = 0

    // MARK: Action
    @IBAction func addButtonTapped(_ sender: Any) {
        // 1件追加して保存してreload
        RealmDataCenter.addItem(itemName: "新規項目" + String(ItemEditTableViewController.i))
        ItemEditTableViewController.i = ItemEditTableViewController.i + 1

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
        let item = self.navigationItem.rightBarButtonItems![1]
        item.isEnabled = enabled
    }

    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        _items = RealmDataCenter.readItem()
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

        if let count = _items?.count {
            return count
        }

        return 1
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

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            RealmDataCenter.delete(data: (_items?[indexPath.row])!)
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        print(fromIndexPath)
        print(to)
        
        let itemFrom = _items![fromIndexPath.row]
        let itemTo = _items![to.row]
        
        RealmDataCenter.swapItem(from: itemFrom, to: itemTo)
        RealmDataCenter.changeOrder(atItems: _items, from: fromIndexPath.row, to: to.row)
        
        // 上から下？
        if(fromIndexPath.row < to.row) {
//            let count = to.row - fromIndexPath.row

            //for i in (1...count).reversed() {
//            for i in 1...count {
//                print(to.row)
//                let item1 = _items![to.row - i]
//                print(item1)
//                let item2 = _items![to.row - i - 1]
//                print(item2)
//
//                RealmDataCenter.edit(forItem: item1, newOrder: item2.order)
//            }


            
            
            
            
//            for(NSInteger i = sortOrder; i > sourceIndexPath.row - 1; i--) {
//                sortOrderChangeAccessor = [_goodsListArray objectAtIndex:i];
//                sortOrderChangeAccessor.sortOrder--;
//            }
//            
//            id item = [_goodsListArray objectAtIndex:sourceAccessor.sortOrder];
//            [_goodsListArray removeObject:item];
//            [_goodsListArray insertObject:item atIndex:sortOrder];
//            
//            sourceAccessor.sortOrder = sortOrder;
//            // 下から上？
//        } else {
//            for(NSInteger i = sortOrder; i < sourceIndexPath.row - 1; i++) {
//                sortOrderChangeAccessor = [_goodsListArray objectAtIndex:i];
//                sortOrderChangeAccessor.sortOrder++;
//            }
//            
//            id item = [_goodsListArray objectAtIndex:sourceAccessor.sortOrder];
//            [_goodsListArray removeObject:item];
//            [_goodsListArray insertObject:item atIndex:sortOrder];
//            
//            sourceAccessor.sortOrder = sortOrder;
        }
        
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _itemSelectedRow = indexPath.row
        self.performSegue(withIdentifier: "itemEdit", sender: self)
    }

     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let vc = segue.destination as! ItemInputTableViewController
            vc.targetItem = _items![_itemSelectedRow]
    }
    
    @IBAction func returnActionForSegueInItemEditTable(_ segue : UIStoryboardSegue) {
        let vc = segue.source as! ItemInputTableViewController

        if segue.identifier == "return" && vc.saved {
            self.tableView.reloadData()
        }
    }
}



