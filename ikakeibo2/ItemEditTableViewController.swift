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

    static var i = 0

    // MARK: Action
    @IBAction func addButtonTapped(_ sender: Any) {
        // 1件追加して保存してreload
        RealmDataCenter.addItem(name: "新規項目" + String(ItemEditTableViewController.i))
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
        /*
         NSArray *array = self.navigationController.viewControllers;
         int arrayCount = [array count];
         HogeViewController *parent = [array objectAtIndex:arrayCount - 1];
         parent.piyo = piyo;
         */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let count = _items?.count {
            return count
        }

        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemEdit", for: indexPath)
        let itemEditCell = cell as! ItemEditCell
        
        let label = itemEditCell.viewWithTag(1) as! UILabel
        let order = _items?[indexPath.row].order

        itemEditCell.order = order
        label.text = _items?[indexPath.row].name
        
        label.text = label.text! + String(describing: order)
        
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
        let itemFrom = _items![fromIndexPath.row]
        let itemTo = _items![to.row]

        RealmDataCenter.swapItem(from: itemFrom, to: itemTo)

        // 先頭行(新規作成）に重ねた場合
//        if(fromIndexPath.row == to.row) {
//            return;
//        }

        // ソート順の変更を保存
//        let sortOrder = to.row - 1;
//        KBGoodsDataAccessor *sourceAccessor = [_goodsListArray objectAtIndex:sourceIndexPath.row - 1];
//        KBGoodsDataAccessor *sortOrderChangeAccessor;

        // 上から下？
//        if fromIndexPath.sort < sortOrder {
//            for(NSInteger i = sortOrder; i > sourceIndexPath.row - 1; i--) {
//                sortOrderChangeAccessor = [_goodsListArray objectAtIndex:i];
//                sortOrderChangeAccessor.sortOrder--;
//            }

//            id item = [_goodsListArray objectAtIndex:sourceAccessor.sortOrder];
//            [_goodsListArray removeObject:item];
//            [_goodsListArray insertObject:item atIndex:sortOrder];

//            fromIndexPath.sortOrder = sortOrder;
            // 下から上？
//        } else {
//            for(NSInteger i = sortOrder; i < sourceIndexPath.row - 1; i++) {
//                sortOrderChangeAccessor = [_goodsListArray objectAtIndex:i];
//                sortOrderChangeAccessor.sortOrder++;
//            }
//
//            id item = [_goodsListArray objectAtIndex:sourceAccessor.sortOrder];
//            [_goodsListArray removeObject:item];
//            [_goodsListArray insertObject:item atIndex:sortOrder];

//            fromIndexPath.sortOrder = sortOrder;
//        }

        // 保存
//        for(NSInteger j = 0; j < _goodsListArray.count; j++) {
//            sortOrderChangeAccessor = [_goodsListArray objectAtIndex:j];
//            [sortOrderChangeAccessor save];
//        }
        
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
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

