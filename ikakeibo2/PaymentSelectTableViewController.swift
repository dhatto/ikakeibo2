//
//  PaymentSelectTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/06.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit
import RealmSwift

class PaymentSelectTableViewController: UITableViewController {
    private var _payments : Results<Payment>?
    private var _paymentSelectedRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationPayment.rightBarButtonPayment = self.editButtonPayment()
        _payments = RealmDataCenter.read(type: Payment.self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let count = _payments?.count {
            return count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentSelect", for: indexPath)
        let paymentSelectCell = cell as! PaymentSelectCell
        let label = paymentSelectCell.viewWithTag(1) as! UILabel
        
        if let payment = _payments?[indexPath.row] {
            paymentSelectCell.order = payment.order
            
            #if !DEBUG
                label.text = payment.name
            #else
                label.text = payment.name + "(" + String(payment.order) + ")"
            #endif
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _paymentSelectedRow = indexPath.row
        self.performSegue(withIdentifier: "backFromPaymentSelect", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CostInputTableViewController {
            vc.inputData.payment = _payments![_paymentSelectedRow]
        } else if let vc = segue.destination as? SearchTableViewController {
            vc.paymentName = _payments![_paymentSelectedRow].name
        }
    }
}


