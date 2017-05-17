//
//  CsvImportViewController.m
//  i家計簿
//
//  Created by 服部 太恒 on 12/04/21.
//  Copyright (c) 2012年 TouhuSoft. All rights reserved.
//

#import "CsvImportViewController.h"
#import "DHLibrary.h"


@interface CsvImportViewController ()

@end

@implementation CsvImportViewController
@synthesize csvFilePath = _csvFilePath;

#pragma mark - Methods
- (void)ImportCsv {
    
    CsvFileReader *reader = [[CsvFileReader alloc] init];
    NSInteger importCount = [reader ImportCsv:_csvText];
    
    [_loadingView removeFromSuperview];
    _loadingView = nil;

    // 処理結果通知
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"CSVインポート処理結果", nil), importCount];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                NSLocalizedString(@"CSVインポート", nil) message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 戻る
        [self.navigationController popViewControllerAnimated:YES];
    }];

    [alert addAction:action];

    // UIAlertControllerはUIViewControllerの継承なので、presentViewControllerで呼び出せる。
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - View Lifestyle
-(IBAction)startImportButtonTouchUpInside:(id)sender {

    // CSVインポート最終確認Alert
    NSString *message = NSLocalizedString(@"CSVインポート最終確認", nil);

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                NSLocalizedString(@"警告", nil) message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // CSV Import
        [self performSelector:@selector(ImportCsv) withObject:nil afterDelay:0.1];
        
        // ローディングビュー表示&インジケータ再生
        [self.tabBarController.view addSubview:_loadingView];
        [_loadingView startAnimating];
    }];

    [alert addAction:actionCancel];
    [alert addAction:actionOK];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    NSError *error;
    
    // CSV読み込み
    _csvText = [NSString stringWithContentsOfFile:_csvFilePath encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"error : %@",error.description);

    _textView.text = _csvText;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    // ローディングビュー作成
    _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake
                         (0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
