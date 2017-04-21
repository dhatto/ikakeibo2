//
//  DHLibrary.h
//  ikakeibo2
//
//  Created by daigoh on 2017/03/25.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef DHLibrary_h
#define DHLibrary_h

@interface DHLibrary : NSObject
/*
 // UserDefaultsLibrary
 + (void)setReadMonthCount:(NSInteger)value;
 + (NSInteger)getReadMonthCount;
 
 // PurchaseLibrary
 + (BOOL)dhIsAppPurchased;
 + (BOOL)dhSaveAppPurchasedInfo:(NSString *)purchase;
 
 // DocumentLibrary
 + (NSString *)dhFileExistsInDocumentsDirectory:(NSString *)fileName;
 
 // CalendarLibrary
 + (void)dhShowInViewInCalendar:(id)actionSheetDelegate initialDate:(NSDate *)date
 pickerTag:(NSInteger)tag targetView:(UIView *)view;
 
 // DateLibrary
 + (NSDate *)dhDateToDate:(NSDate *)target;
 + (NSString *)dhDateToString:(NSDate *)target;*/
 + (NSString *)dhDateToStringOnlyYearMonth:(NSDate *)target;
 + (NSDateComponents *)dhDateToJSTComponents:(NSDate *)from;

/* + (NSString *)dhDateToStringOnlyDay:(NSDate *)target;
 
 + (NSString *)dhDateFormat;
 + (NSString *)dhDateFormatOnlyYearMonth;
 + (NSString *)dhDateFormatOnlyYearMonthDay;
 + (NSString *)dhDateFormatOnlyDay;
 
 */

// StringLibrary
// "1000" -> ¥1,000
+ (NSString *)dhStringToStringWithMoneyFormat:(NSString *)target;
// "¥1,000" -> 1000
+ (NSInteger)dhStringWithMoneyFormatToInteger:(NSString *)target;

@end

#endif /* DHLibrary_h */
