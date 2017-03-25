//
//  DHLibrary.m
//  ikakeibo2
//
//  Created by daigoh on 2017/03/25.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHLibrary.h"

@implementation DHLibrary

#pragma mark - StringLibrary

// "1000" -> ¥1,000
+ (NSString *)dhStringToStringWithMoneyFormat:(NSString *)target {
    
    NSInteger price = [target integerValue];
    
    // 0円以下で入力されている or 数値に変換出来ない or 100万以上の金額
    if(price <= 0 || 10000000 <= price) {
        return nil;
    }
    
    // 3桁毎に「,」付加
    NSMutableString *retValue = [NSMutableString stringWithFormat:@"%ld", (long)price];
    NSUInteger length = retValue.length;
    
    for(NSInteger i = 1, j = 0; i < length; i++) {
        if(i % 3 == 0) {
            [retValue insertString:NSLocalizedString(@",", nil) atIndex:retValue.length - i - j];
            j++;
        }
    }
    
    // 仕上げに¥マーク付加
    [retValue insertString:NSLocalizedString(@"YEN", nil) atIndex:0];
    
    return retValue;
}

// "¥1,000" -> 1000
+ (NSInteger)dhStringWithMoneyFormatToInteger:(NSString *)target{
    if(target == Nil) {
        return 0;
    }
    
    NSMutableString *retValue = [NSMutableString stringWithString:target];
    
    [retValue replaceOccurrencesOfString:NSLocalizedString(@",", nil) withString:@""
                                 options:NSLiteralSearch range:NSMakeRange(0, [retValue length])];
    
    [retValue replaceOccurrencesOfString:NSLocalizedString(@"YEN", nil) withString:@""
                                 options:NSLiteralSearch range:NSMakeRange(0, [retValue length])];
    
    return retValue.integerValue;
}

@end
