//
//  PaymentInputTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/06.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class PaymentInputTableViewController: UITableViewController {
    
    var targetPayment : Payment?
    var editedPaymentField = UITextField()
    var saved = false
    var textColor = UIColor.black
    
    var _sectionList = [
        Section(name: "",
                item:
            [SectionItem(name: "paymentInput")]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(targetPayment!)
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let text = editedPaymentField.text
        //RealmDataCenter.edit(atPayment: self.targetPayment!, newName: text!)
        RealmDataCenter.save(at: self.targetPayment!, newName: text!, color: self.textColor)
        
        self.saved = true
        self.performSegue(withIdentifier: "return", sender: self)
        // ↓でも戻れるが、戻り先で、どうやって戻ってきたかを検出できない
        // （ = reloadDataすべきかどうかが分からない）
        //self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        //RealmDataCenter.saveData(PaymentName: <#T##String#>, value: <#T##Int#>)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = _sectionList[indexPath.section].item[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        switch(_sectionList[indexPath.section].item[indexPath.row].name) {
        case "paymentInput":
            let textField = cell.viewWithTag(1) as! UITextField
            
            // メンバ変数に参照させる
            editedPaymentField = textField
            editedPaymentField.text = targetPayment?.name
            editedPaymentField.becomeFirstResponder()
        default:
            break
//            cell.textLabel?.textColor = self.textColor
        }
        
        return cell
    }

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
