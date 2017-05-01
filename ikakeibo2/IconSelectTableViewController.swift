//
//  IconSelectTableViewController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/05/01.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class IconSelectTableViewController: UITableViewController {

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    @IBAction func iconButtonTouchUpInside(_ sender: UIButton) {
        didTapChangeIcon(tag: sender.tag)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func didTapChangeIcon(tag: Int) {
        
        var icon: String?

        switch(tag) {
        case 1:
            icon = "blueIcon"
        case 3:
            icon = "redIcon"
        default:
            icon = nil
        }

        UIApplication.shared.setAlternateIconName(icon) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
