//
//  KBCsvImportViewController.h
//  i家計簿
//
//  Created by 服部 太恒 on 12/04/21.
//  Copyright (c) 2012年 TouhuSoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CsvFileReader.h"
#import "LoadingView.h"

@interface CsvImportViewController : UIViewController<UIAlertViewDelegate>{
@private
    IBOutlet UITextView *_textView;
    NSString            *_csvText;
    LoadingView         *_loadingView;
}

-(IBAction)startImportButtonTouchUpInside:(id)sender;
- (void)ImportCsv;

@property (nonatomic,strong) NSString *csvFilePath;

@end
