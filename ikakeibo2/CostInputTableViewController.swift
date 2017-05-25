//
//  CostInputTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/02.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class CostInputTableViewController: UITableViewController, CostInputCellDelegate {
    
    //現在表示しているデバイスのサイズを返す構造体
    struct DeviceSize {
        
        //デバイスのCGRectを取得
        static func bounds() -> CGRect {
            return UIScreen.main.bounds
        }
        
        //デバイスの画面の横サイズを取得
        static func screenWidth() -> Int {
            return Int(UIScreen.main.bounds.size.width)
        }
        
        //デバイスの画面の縦サイズを取得
        static func screenHeight() -> Int {
            return Int(UIScreen.main.bounds.size.height)
        }
    }
    
    @IBOutlet weak var costTypeSegment: UISegmentedControl!

    var savedData: Cost? = nil
    var inputData = Cost(cost: 0)
    var saveOk: Bool = false

    // Fields
    var inputMemoField : UITextField?
    var inputCostTextField : UITextField?

    // flags
    var showingCalender = false
    var firstApear = true
    var inputOption = false

    var defaultContentOffset = CGPoint()
    
//    struct SectionItem {
//        var name = ""
//    }
//
//    struct Section {
//        var name = ""
//        var item : [SectionItem]
//    }
    
    // デフォルトは、支出
    var _sectionList = [
        Section(name: "", // 入力（タイトルを空にすると、セクションヘッダを非表示にできる）
            item: [SectionItem(name: "selectItem"),
                   SectionItem(name: "inputCost"),
                   SectionItem(name: "date"),
                   SectionItem(name: "dateSelect")]),
        Section(name: "オプション",
                item: [SectionItem(name: "shop"),
                       SectionItem(name: "payment"),
                       SectionItem(name: "memo")]),
        Section(name: "", // 保存
            item: [SectionItem(name: "save")])]

    @IBAction func costTypeSegmentValueChanged(_ sender: UISegmentedControl) {
        setSectionList(segmentIndex: sender.selectedSegmentIndex)
        self.tableView.reloadData()
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true) {
        }
    }
    
    // 日付を変更
    @IBAction func onDidChangeDate(sender: UIDatePicker) {
        inputData.date = sender.date
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: UITableViewRowAnimation.automatic)
    }

    func setSectionList(segmentIndex: Int = 1) {
        // 収入
        if segmentIndex == 0 {
            _sectionList = [
                Section(name: "", // 入力（タイトルを空にすると、セクションヘッダを非表示にできる）
                    item: [SectionItem(name: "selectIncome"),
                           SectionItem(name: "inputCost"),
                           SectionItem(name: "date"),
                           SectionItem(name: "dateSelect")]),
                Section(name: "オプション",
                        item: [SectionItem(name: "memo")]),
                Section(name: "", // 保存
                    item: [SectionItem(name: "save")])
            ]
            // 支出
        } else {
            _sectionList = [
                Section(name: "", // 入力（タイトルを空にすると、セクションヘッダを非表示にできる）
                    item: [SectionItem(name: "selectItem"),
                           SectionItem(name: "inputCost"),
                           SectionItem(name: "date"),
                           SectionItem(name: "dateSelect")]),
                Section(name: "オプション",
                        item: [SectionItem(name: "shop"),
                               SectionItem(name: "payment"),
                               SectionItem(name: "memo")]),
                Section(name: "", // 保存
                    item: [SectionItem(name: "save")])]
        }
    }
    
    func date(from date : Date) -> String {
        // フォーマットを生成
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        // 日付をフォーマットに則って取得.
        return myDateFormatter.string(from: date)
    }

    func save() -> Bool {
        let str = inputCostTextField?.text?.replacingOccurrences(of: ",", with: "")

        if let value = str?.replacingOccurrences(of: "¥", with: "") {
            if value != "" {
                inputData.value = Int(value)!
            }
        }

        inputData.memo = (inputMemoField?.text)!
        inputData.setDate(target: inputData.date)
        
        // 収入
        if costTypeSegment.selectedSegmentIndex == 0 {
            inputData.item = nil
            inputData.type = 0
        // 支出
        } else {
            inputData.itemIncome = nil
            inputData.type = 1
        }
        
        // 編集モードの場合
        if let data = savedData {
            RealmDataCenter.saveOverWrite(inputData: inputData, savedData: data)
        // 新規の場合
        } else {
            RealmDataCenter.save(cost: inputData)
        }

        //dismissだと遷移元画面にデータを受け渡せない
        //self.dismiss(animated: true) {
        //}

        saveOk = true
        
        return true
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    @IBAction func inputMemoFieldEditingDidBegin(_ sender: UITextField) {
        // スクロールをずらして、保存ボタンが見えるようにする。
        defaultContentOffset = self.tableView.contentOffset
        self.tableView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
    }

    @IBAction func inputMemoFieldEditingDidEnd(_ sender: UITextField) {
        // スクロールをもとに戻す
        self.tableView.setContentOffset(defaultContentOffset, animated: true)
        inputData.memo = (inputMemoField?.text)!
    }

    override func viewDidAppear(_ animated: Bool) {
        
        // 初めて表示された際、キーボードを表示してすぐに入力開始できるようにする。
        // 編集の場合は、やらない。金額が消えてしまうので。
        if self.savedData == nil {
            if firstApear {
                firstApear = false
                inputCostTextField?.becomeFirstResponder()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.savedData != nil {
            self.costTypeSegment.selectedSegmentIndex = savedData?.type == 0 ? 0 : 1
            setSectionList(segmentIndex: costTypeSegment.selectedSegmentIndex)
            Cost.copy(from: savedData!, to: inputData)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return _sectionList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _sectionList[section].item.count
    }

    // 金額入力
    func didEndEditingCost(_ value: Int32) {
        
        // 保存が完了してからこのdelegateが走った場合（キーボードを閉じずに保存ボタンを押した場合に発生する）、すでに
        // 保存しているデータを変更することになってしまうので、realm内部で例外が発生する。
        if !saveOk {
            inputData.value = Int(value)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = _sectionList[indexPath.section].item[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        switch(_sectionList[indexPath.section].item[indexPath.row].name) {
            case "selectItem":
                let label = cell.viewWithTag(1) as! UILabel
                if let item = inputData.item {
                    label.text = item.name
                }
            
            case "selectIncome":
                let label = cell.viewWithTag(1) as! UILabel
                if let income = inputData.itemIncome {
                    label.text = income.name
                }

            case "inputCost":
                inputCostTextField = cell.viewWithTag(1) as? UITextField
                // Delegateを受け取れるようにする
                let cell2 = cell as! CostInputCell
                cell2.delegate = self as CostInputCellDelegate
                
                inputCostTextField?.text = String(inputData.value)
                // 12890 => ¥12,890
                cell2.textFieldFormat(inputCostTextField)
            
            case "date":
                let label = cell.viewWithTag(1) as! UILabel
                label.text = date(from: inputData.date)

            case "dateSelect":
                break

            case "shop":
                let label = cell.viewWithTag(1) as! UILabel
                label.text = inputData.shop?.name

            case "payment":
                let label = cell.viewWithTag(1) as! UILabel
                label.text = inputData.payment?.name

            case "memo":
                inputMemoField = cell.viewWithTag(1) as? UITextField

                // 閉じるボタン付きのアクセサリビューをつける
                let vw = InputAccessoryView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
                vw.closeButton.addTarget(self, action:
                    #selector(CostInputTableViewController.closeButtonTouchUpInside(_:)),
                                         for: UIControlEvents.touchUpInside)

                inputMemoField?.inputAccessoryView = vw
                inputMemoField?.text = inputData.memo
                break

            case "save":
                break

            default:
                break
        }

        return cell
    }

    func closeButtonTouchUpInside(_ sender: UIButton) {
        inputMemoField?.endEditing(true)
    }
    
    func optionButtonTouchUpInside(_ sender: UIButton) {
        self.tableView.endEditing(true)
        // オプション入力をON/OFFする
        inputOption = !inputOption
        // オプション入力セクションをリロードする
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(_sectionList[indexPath.section].item[indexPath.row].name) {
        case "selectItem", "selectIncome":
            return 40
        case "inputCost":
            return 80
        case "date":
            return 40
        case "dateSelect":
            // カレンダー表示中
            if showingCalender {
                return 162
            }
            // 非表示
            return 0

        case "shop","payment","memo":
            if inputOption {
                return 45
            }
            // オプション入力しない場合は、非表示
            return 0
        case "save":
            return 60
        default:
            break
        }

        return 40
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _sectionList[section].name
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択を解除
        tableView.deselectRow(at: indexPath, animated: true)

        switch(_sectionList[indexPath.section].item[indexPath.row].name) {

        case "date":
            showingCalender = !showingCalender
            // このやり方だと、DataSourceを入れ替える事になるので、アニメーションしない。
            // またreloadRowsすると落ちる↓。
            //reason: 'Invalid update: invalid number of rows in section 1.  The number of rows contained in an existing section after the update (5) must be equal to the number of rows contained in that section before the update (4), plus or minus the number of rows inserted or deleted from that section (1 inserted, 1 deleted) and plus or minus the number of rows moved into or out of that section (0 moved in, 0 moved out).
            //
            //_sectionList[1].item.insert(SectionItem(name: "dateSelect"), at: 1)
            //tableView.reloadData()

            let path = [IndexPath(item: 3, section: 0)]
            tableView.reloadRows(at: path, with: UITableViewRowAnimation.automatic)

        case "memo":
            break

        default:
            break;
        }
    }

    @IBAction func returnActionForSegueInCostInputTableView(_ segue : UIStoryboardSegue) {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30.0
        }
        return 0.0
    }

//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 1 {
//            return 10.0
//        }
//        return 0.0
//    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // カスタマイズしたいのは、オプションセクション
        if section != 1 {
            return nil
        }

        let storyboard = UIStoryboard(name: "CostInputTableSection", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        let view = viewController?.view

        // タップイベントを登録
        let button = view?.viewWithTag(1) as! UIButton
        button.addTarget(self, action:
            #selector(CostInputTableViewController.optionButtonTouchUpInside(_:)),
                                 for: UIControlEvents.touchUpInside)

        return view
    }

    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            // 保存
            if ident == "save" {
                // 保存に失敗
                if !self.save() {
                    return false
                }
            }
        }
        return true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //print(segue.identifier)
    }

}
