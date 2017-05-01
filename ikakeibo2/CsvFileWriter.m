////
////  CSVFileWriter.m
////  i家計簿
////
////  Created by 服部 太恒 on 12/04/22.
////  Copyright (c) 2012年 TouhuSoft. All rights reserved.
////
//
//#import "KBCsvFileWriter.h"
//#import "KBCsvListDataAccessor.h"
//
//@implementation KBCsvFileWriter
//@synthesize title = _title;
//@synthesize path = _path;
//
//- (id)init {
//    self = [super init];
//    
//    if (self) {
//        // tmpパス取得
//        _path = [NSString stringWithFormat:@"%@", NSTemporaryDirectory()];
//
//        // 本日日付の文字列を作る
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"dateLocale", nil)]];
//        [formatter setDateFormat:NSLocalizedString(@"CSV日付",nil)];
//
//        NSDate* date = [NSDate date];
//        NSString *csvFileTitlePartDateTime = [formatter stringFromDate:date];
//
//        //ファイル名完成
//        _title =[NSString stringWithFormat:@"%@%@%@",
//                    NSLocalizedString(@"i家計簿", nil),
//                    csvFileTitlePartDateTime, 
//                    NSLocalizedString(@"CSV拡張子",nil)];
//    }
//    return self;
//}
//
//#pragma mark CsvFileProc
//
//// CSVファイル出力。csvFileTitleにCSVタイトル、csvFilePathにCSVファイル（フルパス）を返す
//- (BOOL)createCsvFile {
//
//    // CSV作成
//    NSString *csvString = [KBCsvListDataAccessor getCsvString];
//    if(csvString.length == 0) {
//        return NO;
//    }
//
//    NSString *filePath = [_path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", _title]];
//    BOOL result = [csvString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//
//// Notes:NSFileManagerを使う方法
////    // C文字列で取得
////    const char *cDataString = [csvString UTF8String];
////    // NSUnicodeStringEncodingだと、すべての文字を2Byteで計算するからだめ！
////    NSUInteger uiLength = [csvString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
////    // バイト文字で取得
////    NSData *data = [NSData dataWithBytes:cDataString length:uiLength];
////
////    // 書き込むCSVファイルの属性設定
////    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
////                         [NSDate date], NSFileModificationDate,
////                         @"owner", @"ikakeibo",
////                         @"group", @"ikakeibo",
////                         nil, @"NSFilePosixPermissions",
////                         [NSNumber numberWithBool:YES], @"NSFileExtensionHidden",
////                         nil];
////    // ファイル書き込み
////    NSFileManager *manager = [NSFileManager defaultManager];
////    NSString *filePath = [_path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", _title]];
////    BOOL result = [manager createFileAtPath:filePath contents:data attributes:dic];
//
//    return result;
//}
//
//@end
//
