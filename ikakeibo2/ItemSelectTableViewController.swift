//
//  ItemSelectTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/02.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit
import RealmSwift

class ItemSelectTableViewController: UITableViewController {
    private var _items : Results<Item>?
    
    // MARK: Action
    @IBAction func addButtonTapped(_ sender: Any) {
        // 1件追加して保存してreload
        let item = Item()
        item.name = "新規項目"
        DataCenter.add(item:item)
        
        self.tableView.reloadData()
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if self.isEditing {
            self.setEditing(false, animated: true)
            sender.title = "編集"

            //TODO データの一括保存

        } else {
            self.setEditing(true, animated: true)
            sender.title = "保存"
        }

        self.tableView.reloadData()
    }
    
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        _items = DataCenter.readItem()
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

        if indexPath.row == 0 {
            // todo
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var i : Int
//        i = 100
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let count = _items?.count {
            return count
        }

        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemSelect", for: indexPath)
        let field = cell.viewWithTag(1) as! UITextField

//        if indexPath.row == 0 {
//            cell.textLabel?.text = "新規作成"
//            field.isHidden = true
//        } else {
            cell.textLabel?.text = _items?[indexPath.row].name
            field.text = cell.textLabel?.text
            //field.isHidden = false
//        }
        field.isEnabled = self.isEditing

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true//indexPath.row != 0
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            DataCenter.delete(data: (_items?[indexPath.row])!)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true //indexPath.row != 0
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
