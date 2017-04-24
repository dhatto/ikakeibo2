//
//  MainTabBarController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/01.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    public func showCostInputView(savedData: Cost? = nil) {
        let storyBoard = UIStoryboard(name: "CostInput", bundle: nil)
        let popup = storyBoard.instantiateViewController(withIdentifier: "CostInputNavi") as! UINavigationController
        let vc = popup.viewControllers[0] as! CostInputTableViewController
        vc.savedData = savedData

        self.present(popup, animated: true, completion: {
            
        })
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let costInputViewController = self.viewControllers?[2]

        if(costInputViewController == viewController) {
            showCostInputView()
            return false;
        }
        return true
    }

    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
