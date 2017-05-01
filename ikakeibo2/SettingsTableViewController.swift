//
//  SettingsTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/03/16.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    struct SectionItem {
        var name = ""
    }

    struct Section {
        var name = ""
        var item : [SectionItem]
    }

    let _sectionList = [
        Section(name: "■データ",
                item: [SectionItem(name: "費目編集"),
                       SectionItem(name: "店舗編集"),
                       SectionItem(name: "支払方法編集")]),
        Section(name: "■ルール",
                item: [SectionItem(name: "月初め"),
                       SectionItem(name: "予算"),
                       SectionItem(name: "毎月発生費用")]),
        Section(name: "■インポート/エクスポート",
                item: [SectionItem(name: "インポート(CSV)"),
                       SectionItem(name: "インポート(Googleスプレッドシート)")]),
        Section(name: "■テーマ",
                item: [SectionItem(name: "テーマカラー"),
                       SectionItem(name: "アイコン")]),
        Section(name: "■通知",
                item: [SectionItem(name: "通知")]),
        Section(name: "■その他",
                item: [SectionItem(name: "利用規約"),
                       SectionItem(name: "ワンポイント")])
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
        // #warning Incomplete implementation, return the number of sections
        return _sectionList.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _sectionList[section].name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _sectionList[section].item.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.cell(forIndexPath: indexPath)
        let title = _sectionList[indexPath.section].item[indexPath.row].name

        cell.textLabel?.text = title

        return cell
    }
    
    func cell(forIndexPath path : IndexPath) -> UITableViewCell {
        var reuseIdentifier : String
        
        switch (path.section, path.row) {
            case (0, 0):
                reuseIdentifier = "itemEdit"
            case (0, 1):
                reuseIdentifier = "shopEdit"
            case (0, 2):
                reuseIdentifier = "paymentEdit"
            default:
                reuseIdentifier = "settings"
        }
        
        return self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: path)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch _sectionList[indexPath.section].item[indexPath.row].name {
        case "アイコン":
            self.performSegue(withIdentifier: "iconSelect", sender: nil)
        default:
            break
        }
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
