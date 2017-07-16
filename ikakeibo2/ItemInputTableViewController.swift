//
//  ItemInputTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/06.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class ItemInputTableViewController: UITableViewController, ColorChangeDelegate {

    var targetItem: Item?
    var editedItemField = UITextField()
    var saved = false
    var myColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    var myPalleteIndex: Int = 0

    var _sectionList = [
        Section(name: "",
                item:
                    [SectionItem(name: "itemInput"),
                     SectionItem(name: "selectColor"),
                     SectionItem(name: "selectPalette")]
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        print(targetItem!)
        
        // バッファに移動する。
        if let item = targetItem {
            myColor = item.color()
            myPalleteIndex = item.palletIndex
        }

        // ⬇︎をやらないと、ColorSelectTableViewCellを使えない！！！
        // エラーにはならないし、xibとソースは同名で連結されている&アウトレットも連結しているのに、
        // debugしてみると、アウトレットはnilになる。
        self.tableView.register(UINib(nibName: "ColorSelectTableViewCell", bundle: nil), forCellReuseIdentifier: "selectPalette")
    }

    override func viewDidAppear(_ animated: Bool) {
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let text = editedItemField.text

        RealmDataCenter.save(at: self.targetItem!, newName: text!, color: myColor)

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

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var result: CGFloat = 0.0
        
        switch(_sectionList[indexPath.section].item[indexPath.row].name) {
            case "itemInput","selectColor":
                result = 40
            default:
                result = 160
        }

        return result
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = _sectionList[indexPath.section].item[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        switch(_sectionList[indexPath.section].item[indexPath.row].name) {

            case "itemInput":
                let textField = cell.viewWithTag(1) as! UITextField
                
                // メンバ変数に参照させる
                editedItemField = textField
                editedItemField.text = targetItem?.name
                editedItemField.becomeFirstResponder()

            case "selectColor":
                cell.accessoryType = .disclosureIndicator
                let label: UILabel = cell.viewWithTag(1) as! UILabel
                label.textColor = myColor
                break

            default: //"selectPalette"
                // storyboard上でも設定しているのだが、このcellはregisterClassしないと表示できないセルなので、
                // accessoryTypeもコードで設定してやらないと表示されないのだ。
                //cell.accessoryType = .disclosureIndicator // 不要では?

                // カラーパレットからのカラー変更Delegateを受信する
                let cellDelegate = cell as! ColorSelectTableViewCell
                cellDelegate.delegate = self

                // パレットから選択されている場合
                if myPalleteIndex != -1 {
                    // カラー行とカラーインデックス行に、保存されている色を反映
                    cellDelegate.colorButtonTouchUpInside(palletIndex: myPalleteIndex)
                } else {
                    // ColorSelectTableViewCellのメソッドを呼び出し、必要なければ大きなサイズを取り消す。
                    cellDelegate.colorButtonSizeReset(color: myColor)
                }
            }

        return cell
    }
    
    // MARK: - ColorSelectTableViewCell Delegate
    func colorChange(color: UIColor) -> Void {
        myColor = color
        //self.textColor = color
        self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: UITableViewRowAnimation.automatic)
    }
    
    // MARK: - Navigation
    // カラー選択画面から戻ってきた時
    @IBAction func unwind(_ segue : UIStoryboardSegue) {
        let vc = segue.source as! ColorPickViewController

        // データソースに色を保存する。その後でreloadRowsする。
        myColor = vc.color
        myPalleteIndex = -1
        self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)], with: UITableViewRowAnimation.automatic)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // カラー選択画面へ遷移する場合
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "selectColor" {
            let vc = segue.destination as! ColorPickViewController
            vc.color = myColor
        }
    }
}



