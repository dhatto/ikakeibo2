//
//  CsvFileReader.m
//  i家計簿
//
//  Created by 服部 太恒 on 12/04/22.
//  Copyright (c) 2012年 TouhuSoft. All rights reserved.
//

#import "CsvFileReader.h"
#import "DHLibrary.h"
#import "ikakeibo2-Swift.h"

@interface CsvFileReader()
@end

@implementation CsvFileReader

-(NSInteger)ImportCsv:(NSString *)csvText {

    NSArray *items;
    NSString *shopName;
    NSString *itemName;
    NSString *typeString;
    NSString *priceString;
    NSString *createDateString;
    NSDate *createDate;
    NSInteger importCount = 0;
    NSInteger type = 0;
    
    //TODO: Numbersの場合、\r\nなのだが、\nだけの場合もある。要注意...。
    NSArray *lines = [csvText componentsSeparatedByString:@"\r\n"];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];

    // 端末設定が和暦の場合でも、CSVの日付形式で処理する。
    inputFormatter.dateFormat = NSLocalizedString(@"defaultDateFormat", nil);
    inputFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];

    // Notes:CSVの日付形式に合わせ、グレゴリオ暦を利用する
    // (currentCalendarを利用すると、端末設定が和暦の場合に正常動作しない)
    inputFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

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
        // 項目名
        itemName = [items objectAtIndex:1];
        itemName = [itemName stringByTrimmingCharactersInSet:
                      [NSCharacterSet characterSetWithCharactersInString:@" \""]];

        // (支出or収入)
        typeString = [items objectAtIndex:2];
        // 金額
        priceString = [items objectAtIndex:3];
        // 日付
        createDateString = [items objectAtIndex:4];
        createDateString = [createDateString stringByTrimmingCharactersInSet:
                            [NSCharacterSet characterSetWithCharactersInString:@" \""]];

        NSRange searchResult = [createDateString rangeOfString:@":"];
        if(searchResult.location == NSNotFound) {
            createDateString = [NSString stringWithFormat:@"%@ %@",createDateString, @"09:00:00"];
        }

        // 時差考慮
        createDate = [inputFormatter dateFromString:createDateString];

        if([typeString isEqualToString:@"収入"]) {
            [RealmDataCenter addIncomeWithName:itemName order:0];
            type = 0;
        } else {
            [RealmDataCenter addItemWithName:itemName order:0];
            type = 1;
        }

        [RealmDataCenter addShopWithShopName:shopName order:0];
        // 支払方法は未実装
        //[RealmDataCenter addPaymentWithPaymentName:payment order:0];
        
        [RealmDataCenter addCostWithShopName:shopName
                                        type:type
                                    itemName:itemName
                                 paymentName:@""
                                       value:priceString.intValue
                                        date:createDate];

        importCount++;
    }

    return importCount;
}

@end
