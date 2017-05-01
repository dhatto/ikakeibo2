//
//  CsvFileReader.m
//  i家計簿
//
//  Created by 服部 太恒 on 12/04/22.
//  Copyright (c) 2012年 TouhuSoft. All rights reserved.
//

#import "CsvFileReader.h"
//#import "ShopDataAccessor.h"
//#import "FolderDataAccessor.h"
//#import "RecordDataAccessor.h"
#import "DHLibrary.h"

@interface CsvFileReader()
//-(NSInteger)saveShopName:(NSString *)name createDate:(NSDate *)date;
//-(NSInteger)saveFolderName:(NSString *)name createDate:(NSDate *)date;
//-(BOOL)saveRecordWithShopId:(NSInteger)shopId folderId:(NSInteger)folderId typeIndexString:(NSString *)type
//                priceString:(NSString *)priceString createDate:(NSDate *)date;
@end

@implementation CsvFileReader

-(NSInteger)ImportCsv:(NSString *)csvText {

    NSArray *items;
    NSString *shopName;
    NSString *folderName;
    NSString *typeIndexString;
    NSString *priceString;
    NSString *createDateString;
    NSDate *createDate;
    NSInteger shopId;
    NSInteger folderId;
    NSInteger importCount = 0;
    NSArray *lines = [csvText componentsSeparatedByString:@"\n"];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];

    // 端末設定が和暦の場合でも、CSVの日付形式で処理する。
    inputFormatter.dateFormat = NSLocalizedString(@"csvDateFormat", nil);
    inputFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"dateLocale", nil)];
    // Notes:CSVの日付形式に合わせ、グレゴリオ暦を利用する
    // (currentCalendarを利用すると、端末設定が和暦の場合に正常動作しない)
    inputFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    // ここをちょっと修正！
    
    // 1行ずつ正当性チェックし、DBに格納
    for (NSString *lineString in lines) {
        items = [lineString componentsSeparatedByString:@","];

        // カンマが4個以上ある(不正データ)
        if([items count] != 5) {
            continue;
        }

        // 店名
        shopName = [items objectAtIndex:0];
        // ホワイトスペース&ダブルクォーテーションを除去
        shopName = [shopName stringByTrimmingCharactersInSet:
                    [NSCharacterSet characterSetWithCharactersInString:@" \""]];
        // フォルダ名
        folderName = [items objectAtIndex:1];
        folderName = [folderName stringByTrimmingCharactersInSet:
                      [NSCharacterSet characterSetWithCharactersInString:@" \""]];
        // type(支出or収入)
        typeIndexString = [items objectAtIndex:2];
        // 金額
        priceString = [items objectAtIndex:3];
        // 日付
        createDateString = [items objectAtIndex:4];
        createDateString = [createDateString stringByTrimmingCharactersInSet:
                            [NSCharacterSet characterSetWithCharactersInString:@" \""]];

        NSRange searchResult = [createDateString rangeOfString:@":"];
        if(searchResult.location == NSNotFound){
            createDateString = [NSString stringWithFormat:@"%@ %@",createDateString, @"09:00:00"];
        }
        // 時差考慮
        createDate = [inputFormatter dateFromString:createDateString];

        // 店保存
        //shopId = [self saveShopName:shopName createDate:createDate];
        // フォルダ保存
        //folderId = [self saveFolderName:folderName createDate:createDate];
        // レコード保存
        //[self saveRecordWithShopId:shopId folderId:folderId typeIndexString:typeIndexString
        //               priceString:priceString createDate:createDate];

        importCount++;
    }
    
    return importCount;
}

//-(NSInteger)saveShopName:(NSString *)name createDate:(NSDate *)date {
//    
//    ShopDataAccessor *shopDataAccessor = [[ShopDataAccessor alloc] init];
//
//    shopDataAccessor.shopName = name;
//    shopDataAccessor.createDate = date;
//
//    if(![shopDataAccessor saveIfNotExisted]) {
//        return DATA_ID_NOTSET;
//    }
//
//    return shopDataAccessor.shopId;
//}
//
//-(NSInteger)saveFolderName:(NSString *)name createDate:(NSDate *)date {
//
//    FolderDataAccessor *folderDataAccessor = [[FolderDataAccessor alloc] init];
//
//    folderDataAccessor.folderName = name;
//    folderDataAccessor.createDate = date;
//
//    if(![folderDataAccessor saveIfNotExisted]) {
//        return DATA_ID_NOTSET;
//    }
//
//    return folderDataAccessor.folderId;
//}
//
//-(BOOL)saveRecordWithShopId:(NSInteger)shopId folderId:(NSInteger)folderId typeIndexString:(NSString *)type 
//                priceString:(NSString *)priceString createDate:(NSDate *)date {
//
//    BOOL result = NO;
//
//    RecordDataAccessor *recordDataAccessor;
//    recordDataAccessor = [[RecordDataAccessor alloc] init];
//    recordDataAccessor.shopId = shopId;
//    recordDataAccessor.folderId = folderId;
//
//    // 収入 or 支出(収入以外は全て支出と見做す)
//    DATA_TYPE_INDEX typeIndex = DATA_TYPE_SHOPPING;
//    if([type integerValue] == DATA_TYPE_INCOME) {
//        typeIndex = DATA_TYPE_INCOME;
//    }
//
//    recordDataAccessor.typeIndex = typeIndex;
//    NSString *priceCheckString = [DHLibrary dhStringToStringWithMoneyFormat:priceString];
//
//    // 入力エラー
//    if([priceCheckString length] == 0) {
//        priceString = @"0";
//    }
//
//    recordDataAccessor.price = [priceString integerValue];
//    recordDataAccessor.createDate = date;
//
//    result = [recordDataAccessor save];
//
//    return result;
//}

@end
