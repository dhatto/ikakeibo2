//
//  CSVExport.swift
//  ikakeibo2
//
//  Created by daigoh on 2017/05/02.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

import Foundation

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
                self.sendMail()
            /*            // CSVファイル名とパス取得
             result = [writer createCsvFile];
             if(result) {
             // メールに添付して送信
             result = [self sendMailWithCsvFile:writer.title csvFilePath:writer.path];
             }
             
             // メール作成失敗
             if(result != YES) {
             alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"エラー", nil) message:NSLocalizedString(@"メール送信失敗", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
             
             [alert show];
             }
             
             break;
*/
        })
        
        // iTunes経由で送信
        let documentAction:UIAlertAction = UIAlertAction(title: "iTunesにエクスポート",
                                                        style: UIAlertActionStyle.default,
                                                        handler:
        {
            (action:UIAlertAction!) -> Void in
            let writer = CsvFileWriter()
            let result = writer.createCsvFile()
            
            if result {
                
            }
            
            /*
             if(result == YES) {
             title = NSLocalizedString(@"完了",nil);
             message = [NSString stringWithFormat:NSLocalizedString(@"保存完了",nil), writer.title];
             // 保存失敗
             } else {
             title = NSLocalizedString(@"エラー",nil);
             message = NSLocalizedString(@"保存失敗",nil);
             }
             
             alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
             
             [alert show];
*/
        })

        //AlertもActionSheetも同じ
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(mailAction)
        actionSheet.addAction(documentAction)

        //表示。UIAlertControllerはUIViewControllerを継承している。
        parent.present(actionSheet, animated: true, completion: nil)

    }
    
    func sendMail() {
        /*
         - (BOOL)sendMailWithCsvFile:(NSString *)csvFileTitle csvFilePath:(NSString *)csvFilePath{
         
         // メール送信クラスが使えるか(iPhoneOS 3.0以降&セットアップ済みか）調べる。
         Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
         if (mailClass == nil || ![mailClass canSendMail]) {
         return NO;
         }
         
         // メール送信画面表示
         MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
         mailViewController.mailComposeDelegate = self;
         [mailViewController setSubject:NSLocalizedString(@"mailSubject", nil)];
         
         // Notes:to,cc,bccの指定
         //NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
         //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
         //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
         //[picker setToRecipients:toRecipients];
         //[picker setCcRecipients:ccRecipients];
         //[picker setBccRecipients:bccRecipients];
         NSString *fileFullPath = [csvFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", csvFileTitle]];
         
         // CSVファイル添付
         NSData *myData = [NSData dataWithContentsOfFile:fileFullPath];
         [mailViewController addAttachmentData:myData mimeType:@"text/plain"//@"text/comma-separated-values"
         fileName:csvFileTitle];
         [mailViewController setMessageBody:nil isHTML:NO];
         
         // MFMailComposeViewControllerをModalで表示！
         [self presentModalViewController:mailViewController animated:YES];
         
         return YES;	
         }
         */
    }
    /*// CSVファイル付きメール送信画面のDelegate
     - (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:
     (MFMailComposeResult)result error:(NSError*)error {
     UIAlertView *alertView;
     
     // Notifies users about errors associated with the interface
     switch (result) {
     case MFMailComposeResultCancelled:
     break;
     case MFMailComposeResultSaved:
     break;
     case MFMailComposeResultSent:
     // 送信完了Alert
     alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"完了", nil)
     message:NSLocalizedString(@"メール送信完了", nil)
     delegate:nil
     cancelButtonTitle:NSLocalizedString(@"OK", nil)
     otherButtonTitles:nil];
     [alertView show];
     
     break;
     case MFMailComposeResultFailed:
     break;
     default:
     break;
     }
     
     [self dismissModalViewControllerAnimated:YES];
     }
*/
}
