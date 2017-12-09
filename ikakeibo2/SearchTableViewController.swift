//
//  SearchTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/07/30.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    var valueRange : [String] = []
    var itemNames = "全て" // 支出費目

    var _sectionList = [
        // 収入
        Section(name: "",
                item: [SectionItem(name: "valueRange"),
                       SectionItem(name: "timesRange"),
                       SectionItem(name: "selectTimesRange"),
                       SectionItem(name: "itemsIncomeRange"),
                       SectionItem(name: "start")]
        ),
        // 支出
        Section(name: "",
                item: [SectionItem(name: "valueRange"),
                       SectionItem(name: "timesRange"),
                       SectionItem(name: "selectTimesRange"),
                       SectionItem(name: "itemsRange"),
                       SectionItem(name: "shopRange"),
                       SectionItem(name: "paymentRange"),
                       SectionItem(name: "start")]
        )
    ]

    var startEndDate : [String:Date] = ["start":Date(), "end":Date()]

    // flags
    var showingCalender = CalendarState.notShowing
    enum CalendarState: Int {
        case notShowing
        case showingForStartDate
        case showingForEndDate
    }

    @IBOutlet weak var costTypeSegument: UISegmentedControl!
    
    @IBAction func costTypeSegumentValueChanged(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }

    @IBAction func returnActionForSegueInSearchTableViewController(_ segue : UIStoryboardSegue) {
        // 遷移元
//        let vc = segue.source as! ValueRangeViewController
//        // 遷移先（つまりこの画面）
//        let vc2 = segue.destination

        if segue.identifier == "returnFromValueRange" {

            _sectionList[self.costTypeSegument.selectedSegmentIndex].item[0].value =
                valueRange[0] + "〜" + valueRange[1]

            //            vc.valueRange.append(DHLibrary.dhStringWithMoneyFormat(toInteger: min))
            //            vc.valueRange.append(DHLibrary.dhStringWithMoneyFormat(toInteger: max))

            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
        }
    }

    @IBAction func returnActionForSegueInCostInputTableView(_ segue : UIStoryboardSegue) {
        self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: UITableViewRowAnimation.automatic)
    }

    @IBAction func searchButtonTouchUpInside(_ sender: UIButton, forEvent event: UIEvent) {
        let storyBoard = UIStoryboard(name: "CostList", bundle: nil)
        let nav = storyBoard.instantiateInitialViewController() as! UINavigationController
        let vc = nav.viewControllers[0] as! CostTableViewController

        // ここに検索条件を格納
        vc.searchCondition = RealmSearchCondition()
        vc.searchCondition.target = SeachTarget.Cost

        if !valueRange.isEmpty {
            let min = DHLibrary.dhStringWithMoneyFormat(toInteger: valueRange[0])
            let max = DHLibrary.dhStringWithMoneyFormat(toInteger: valueRange[1])
            
            vc.searchCondition.rangeOfAmounts.min = min
            vc.searchCondition.rangeOfAmounts.max = max

        }

        vc.searchCondition.itemNames = itemNames
        vc.isSearching = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.costTypeSegument.selectedSegmentIndex == 0 ? 4 : 6
        return _sectionList[self.costTypeSegument.selectedSegmentIndex].item.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = _sectionList[
            self.costTypeSegument.selectedSegmentIndex].item[indexPath.row].name

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        switch reuseIdentifier {
        // 金額範囲選択画面から戻ってきた場合、反映したい
        case "valueRange":
            if let label = cell.viewWithTag(1) as? UILabel {
                label.text = _sectionList[self.costTypeSegument.selectedSegmentIndex].item[0].value
            }
        // 年月
        case "timesRange":
            if let startBtn = cell.viewWithTag(1) as? UIButton {
                startBtn.setTitle(stringYearMonth(name: "start"), for: UIControlState.normal)
            }
            if let endBtn = cell.viewWithTag(2) as? UIButton {
                endBtn.setTitle(stringYearMonth(name: "end"), for: UIControlState.normal)
            }
        // 年月選択
        case "selectTimesRange":
            switch self.showingCalender {
            // 何も表示されていない場合
            case .notShowing:
                break

            // 開始カレンダーが表示されている場合
            case .showingForStartDate:
                if let datePicker = cell.viewWithTag(1) as? UIDatePicker, let date = startEndDate["start"] {
                    datePicker.setDate(date, animated: true)
                }
            // 終了カレンダーが表示されている場合
            case .showingForEndDate:
                if let datePicker = cell.viewWithTag(1) as? UIDatePicker, let date = startEndDate["end"] {
                    datePicker.setDate(date, animated: true)
                }
            }
        // 支出費目
        case "itemsRange":
            if let label = cell.viewWithTag(1) as? UILabel {
                //label.text = _sectionList[self.costTypeSegument.selectedSegmentIndex].item[0].value
                label.text = itemNames
            }

//        case "shopRange"
//        case "paymentRange"

        default:
            break
        }

        return cell
    }

    func stringYearMonth(name: String) -> String {
        var result = ""

        if let date = startEndDate[name] {
            let year = Calendar.current.component(.year, from: date)
            let month = Calendar.current.component(.month, from: date)
            let day = Calendar.current.component(.day, from: date)
            result = String(year) + "/" + String(month) + "/" + String(day)
        }

        return result
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch(_sectionList[self.costTypeSegument.selectedSegmentIndex].item[indexPath.row].name) {
        case "selectTimesRange":
            if showingCalender != .notShowing {
                return 300.0
            } else {
                return 0
            }

        default:
            return 40.0
        }
    }

    func showItemSelectView() {
        // 費目（支出）選択画面を表示する
        // ItemSelectTableViewControllerはCostInput.storyboardにあるので、StoryBoardIDを指定して取り出す
        let storyboard = UIStoryboard(name: "CostInput", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ItemSelect")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK:TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch(_sectionList[self.costTypeSegument.selectedSegmentIndex].item[indexPath.row].name) {
        case "itemsRange":
            self.showItemSelectView()

//        case "timesRange":
//            // タップ状態解除アニメーション
//            if let indexPath = tableView.indexPathForSelectedRow {
//                tableView.deselectRow(at: indexPath, animated: true)
//            }
//
//            // 表示されてなかったら、開始日選択状態でカレンダー開く
//            if self.showingCalender == .notShowing {
//                self.showingCalender = .showingForStartDate
//            // 表示中ならカレンダー閉じる
//            } else {
//                self.showingCalender = .notShowing
//            }
//
//            self.tableView.reloadRows(at: [IndexPath(row:2, section:0)], with: UITableViewRowAnimation.automatic)
//
//            break

        default:
            break
        }
    }

    // MARK:EVENT
    @IBAction func timesRangeButtonTouchUpInside(_ sender: UIButton) {
        print("Function: \(#function), line: \(#line)")

        switch self.showingCalender {
        // 何も表示されていない場合
        case .notShowing:
            // 　対象カレンダーを開く
            self.showingCalender = (sender.tag == 1) ? .showingForStartDate : .showingForEndDate

        // すでに開始カレンダーが表示されている場合
        case .showingForStartDate:
            // 　開始カレンダーが押されたら、閉じる
            // 　終了カレンダーが押されたら、開始カレンダーの結果をセルに反映し、終了カレンダーを開く
            self.showingCalender = (sender.tag == 1) ? .notShowing : .showingForEndDate

        // すでに終了カレンダーが表示されている場合
        case .showingForEndDate:
            // 　開始カレンダーが押されたら、終了カレンダーの結果をセルに反映し、開始カレンダーを開く
            // 　終了カレンダーが押されたら、閉じる
            self.showingCalender = (sender.tag == 1) ? .showingForStartDate : .notShowing
            break
        }
        
        // 年月設定行をリロードする。
        // (showingCalenderをtrueにしていると、行の高さが0ではなくなり、行が表示される)
        self.tableView.reloadRows(at: [IndexPath(row:2, section:0)], with: UITableViewRowAnimation.automatic)
    }

    // 日付を変更
    @IBAction func onDidChangeDate(sender: UIDatePicker) {

        switch self.showingCalender {
        // 何も表示されていない場合
        case .notShowing:
            // ありえない
            break

        // 開始カレンダーが表示されている場合
        case .showingForStartDate:
            self.startEndDate.updateValue(sender.date, forKey: "start")

        // 終了カレンダーが表示されている場合
        case .showingForEndDate:
            self.startEndDate.updateValue(sender.date, forKey: "end")
        }

        // 年月行を更新
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: UITableViewRowAnimation.automatic)
    }
}
