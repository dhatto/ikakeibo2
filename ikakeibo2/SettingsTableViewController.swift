//
//  SettingsTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/03/16.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    struct SectionItem {
        var name = ""
    }

    struct Section {
        var name = ""
        var item : [SectionItem]
    }

    let _sectionList = [
        Section(name: "■データ",
                item: [SectionItem(name: "支出費目編集"),
                       SectionItem(name: "収入費目編集"),
                       SectionItem(name: "店舗編集"),
                       SectionItem(name: "支払方法編集")]),
        Section(name: "■ルール",
                item: [SectionItem(name: "月初め"),
                       SectionItem(name: "予算"),
                       SectionItem(name: "毎月発生費用")]),
        Section(name: "■インポート/エクスポート",
                item: [SectionItem(name: "インポート(CSV)"),
                       SectionItem(name: "エクスポート(CSV)")]),
                       //SectionItem(name: "インポート(Googleスプレッドシート)")]),
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
                reuseIdentifier = "incomeEdit"
            case (0, 2):
                reuseIdentifier = "shopEdit"
            case (0, 3):
                reuseIdentifier = "paymentEdit"
            default:
                reuseIdentifier = "settings"
        }
        
        return self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: path)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch _sectionList[indexPath.section].item[indexPath.row].name {
            
        case "インポート(CSV)":
            self.performSegue(withIdentifier: "importCsv", sender: nil)
            
        case "エクスポート(CSV)":
            let export = CSVExport(parent: self)
            export.export()
            // 選択を解除
            tableView.deselectRow(at: indexPath, animated: true)
            
        case "アイコン":
            self.performSegue(withIdentifier: "iconSelect", sender: nil)

        default:
            break
        }
    }
    
    // メールキャンセル
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        // MFMailComposeResultCancelled -> MFMailComposeResult.cancelled に変更。ほかも同様
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Email Send Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Email Saved as a Draft")
        case MFMailComposeResult.sent.rawValue:
            print("Email Sent Successfully")
        case MFMailComposeResult.failed.rawValue:
            print("Email Send Failed")
        default:
            break
        }

        self.dismiss(animated: true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "importCsv" {

            let vc = segue.destination as! CsvImportViewController
            let path = DHLibrary.dhFileExists(inDocumentsDirectory: "i家計簿2.csv")
            vc.csvFilePath = path
        }
    }
}





