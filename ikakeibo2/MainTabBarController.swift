//
//  MainTabBarController.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/04/01.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
//    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//        
//        if viewController is DummyViewController {
//            // DummyViewControllerはモーダルを出したい特定のタブに紐付けたViewController
//            if let currentVC = self.selectedViewController{
//                //表示させるモーダル
//                let modalViewController: UIViewController = UIViewController()
//                //わかりやすく背景を赤色に
//                modalViewController.view.backgroundColor = UIColor.redColor()
//                currentVC.presentViewController(modalViewController, animated: true, completion: nil)
//            }
//            return false
//        }
//        return true
//    }

    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let costInputViewController = self.viewControllers?[2]

        if(costInputViewController == viewController) {
            let storyBoard = UIStoryboard(name: "CostInput", bundle: nil)
            let popup = storyBoard.instantiateViewController(withIdentifier: "CostInputNavi")

            tabBarController.present(popup, animated: true, completion: {
            
            })
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
