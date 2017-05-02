//
//  CSVExport.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/05/02.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import Foundation
import MessageUI

class CSVExport{
    let parent: UIViewController

    init(parent: UIViewController) {
        self.parent = parent
    }
    
    func export() {
        let actionSheet:UIAlertController = UIAlertController(title:"エクスポート",
                                                              message: "エクスポート先を指定して下さい",
                                                              preferredStyle: UIAlertControllerStyle.actionSheet)
        // Cancel 一つだけしか指定できない
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: UIAlertActionStyle.cancel,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
        })
        
        // メールの添付ファイルで送信
        let mailAction:UIAlertAction = UIAlertAction(title: "メール送信",
                                                        style: UIAlertActionStyle.default,
                                                        handler:
        {
            (action:UIAlertAction!) -> Void in
                self.csvExportToMail()
        })
        
        // iTunes経由で送信
        let documentAction:UIAlertAction = UIAlertAction(title: "iTunesにエクスポート",
                                                        style: UIAlertActionStyle.default,
                                                        handler:
        {
            (action:UIAlertAction!) -> Void in
                self.csvExportToDocumentDirectory()
        })

        //AlertもActionSheetも同じ
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(mailAction)
        actionSheet.addAction(documentAction)

        //表示。UIAlertControllerはUIViewControllerを継承している。
        parent.present(actionSheet, animated: true, completion: nil)

    }
    
    func csvExportToDocumentDirectory() {
        let loadingView = startLoadingView()
        
        // 0.5秒後に実行させる。じゃないと↑のインジケータが表示されない。
        let dispatchTime: DispatchTime =
            DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            let writer = CsvFileWriter()
            let result = writer.createCsvFile()
            let message = "CSV書き出しに" + (result ? "成功" : "失敗") + "しました"
            self.showAlert(message)
            loadingView.removeFromSuperview()
        })
    }
    
    func showAlert(_ message: String) {
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "処理結果", message: message, preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })

        // ③ UIAlertControllerにActionを追加
        alert.addAction(defaultAction)

        // ④ Alertを表示
        self.parent.present(alert, animated: true, completion: nil)
    }
    
    func startLoadingView() -> LoadingView {
        let loadingView = LoadingView(frame: self.parent.view.frame)
        self.parent.tabBarController?.view.addSubview(loadingView)
        loadingView.startAnimating()
        return loadingView
    }
    
    func csvExportToMail() {
        let loadingView = startLoadingView()
        
        // 0.5秒後に実行させる。じゃないと↑のインジケータが表示されない。
        let dispatchTime: DispatchTime =
            DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            let writer = CsvFileWriter()
            _ = writer.createCsvFile()
            loadingView.removeFromSuperview()
            
            self.startMailer(title: writer.title, path: writer.path)
        })
    }
    
    func startMailer(title: String, path: String) {
        if MFMailComposeViewController.canSendMail()==false {
            print("Email Send Failed")
            return
        }

        let mailViewController = MFMailComposeViewController()
        // Toの宛先、カンマ区切りの複数件対応
        //let toRecipients = toText.text!.components(separatedBy: ",")
        // Ccの宛先、カンマ区切りの複数件対応
        //let CcRecipients = ccText.text!.components(separatedBy: ",")
        // 件名
        let subjectTextStr = "i家計簿CSVファイル"
        // 本文
        let messageBodyTextStr = "i家計簿CSVファイルを送信します"
        
        mailViewController.mailComposeDelegate = self.parent as! SettingsTableViewController
        mailViewController.setSubject(subjectTextStr)
        //mailViewController.setToRecipients(toRecipients) //Toアドレスの表示
        //mailViewController.setCcRecipients(CcRecipients) //Ccアドレスの表示
        mailViewController.setMessageBody(messageBodyTextStr, isHTML: false)

        // CSVファイル添付
        let data = try? Data(contentsOf: URL(fileURLWithPath: path + title))
        
        mailViewController.addAttachmentData(data!, mimeType: "text/plain", fileName: title)

        // presentViewController -> present に変更
        self.parent.present(mailViewController, animated: true, completion: nil)
    }
}
