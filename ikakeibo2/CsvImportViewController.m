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
    
    // ActivityIndicator閉じる
    [_modalLoadingView removeFromSuperview];
    _modalLoadingView = nil;
    
    // 処理結果通知
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"CSVインポート処理結果", nil), importCount];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CSVインポート", nil) 
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                              otherButtonTitles:nil];
    [alertView show];
    
    // 戻る
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Lifestyle
-(IBAction)startImportButtonTouchUpInside:(id)sender {

    // CSVインポート最終確認Alert
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"警告", nil) 
                                           message:NSLocalizedString(@"CSVインポート最終確認", nil)
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
                                 otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
    [alertView show];
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
    _modalLoadingView = [[UIView alloc] initWithFrame:CGRectMake
                         (0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _modalLoadingView.backgroundColor = [UIColor blackColor];
    _modalLoadingView.alpha = 0.5f;

    // インジケータ作成
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [indicator setCenter:CGPointMake(_modalLoadingView.bounds.size.width / 2, _modalLoadingView.bounds.size.height / 2)];
    indicator.tag = 1;

    // ローディングビューに追加
    [_modalLoadingView addSubview:indicator];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - AlertView Delegate
// Alertが閉じられた後で呼ばれる
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

    // CSV Import YES
    if(buttonIndex == 1) {
        // CSV Import
        [self performSelector:@selector(ImportCsv) withObject:nil afterDelay:0.1];

        // ローディングビュー表示&インジケータ再生
        [self.tabBarController.view addSubview:_modalLoadingView];
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[_modalLoadingView viewWithTag:1];

        [indicator startAnimating];
    }
}

@end




















