//
//  IncomeInputTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/06.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class IncomeInputTableViewController: UITableViewController {

    var targetIncome : ItemIncome?
    var editedIncomeField = UITextField()
    var saved = false
    var textColor = UIColor.black

    var _sectionList = [
        Section(name: "",
                item:
            [SectionItem(name: "incomeInput"),
             SectionItem(name: "selectColor")]
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationIncome.rightBarButtonIncome = self.editButtonIncome()

        print(targetIncome!)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let text = editedIncomeField.text
        RealmDataCenter.save(at: self.targetIncome!, newName: text!, color: textColor)

        self.saved = true
        self.performSegue(withIdentifier: "return", sender: self)
        // ↓でも戻れるが、戻り先で、どうやって戻ってきたかを検出できない
        // （ = reloadDataすべきかどうかが分からない）
        //self.navigationController?.popViewController(animated: true)
    }

//    override func viewWillAppear(_ animated: Bool) {
//
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        //RealmDataCenter.saveData(incomeName: <#T##String#>, value: <#T##Int#>)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = _sectionList[indexPath.section].item[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        switch(_sectionList[indexPath.section].item[indexPath.row].name) {
        case "incomeInput":
            let textField = cell.viewWithTag(1) as! UITextField
            // メンバ変数に参照させる
            editedIncomeField = textField
            editedIncomeField.text = targetIncome?.name
            editedIncomeField.becomeFirstResponder()
            
        default:
            cell.textLabel?.textColor = self.textColor
        }
        return cell
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified income to be editable.
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
        // Return false if you do not want the income to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    // カラー選択画面から戻ってきた時
    @IBAction func unwind(_ segue : UIStoryboardSegue) {
        let vc = segue.source as! ColorPickViewController
        self.textColor = vc.color

        self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: UITableViewRowAnimation.automatic)
    }
    
    // カラー選択画面へ遷移する場合
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "selectColor" {
            let vc = segue.destination as! ColorPickViewController
            vc.color = self.textColor
        }
    }

}
