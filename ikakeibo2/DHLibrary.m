//
//  DHLibrary.m
//  ikakeibo2
//
//  Created by daigoh on 2017/03/25.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

#import "DHLibrary.h"

@implementation DHLibrary

#pragma mark - StringLibrary
/*
 #pragma mark - UserDefaultsLibrary
 
 + (void)setReadMonthCount:(NSInteger)value{
 // UserDefaultsに保存
 [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"readMonthCount"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 }
 
 + (NSInteger)getReadMonthCount{
 
 NSInteger monthCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"readMonthCount"];
 NSInteger result = 0;
 
 switch (monthCount) {
 case 0:
 result = 3;
 break;
 case 1:
 result = 6;
 break;
 case 2:
 result = 12;
 break;
 case 3:
 default:
 result = NSIntegerMax;
 break;
 }
 
 return result;
 }
 
 #pragma mark - PurchaseLibrary
 // 課金済みかどうか確認
 + (BOOL)dhIsAppPurchased {
 
 NSFileManager *fileManager = [NSFileManager defaultManager];
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
 NSString *libraryDirectory = [paths objectAtIndex:0];
 
 // Library/PrivateDocuments/p があればOKとする。
 NSString *privateDocs = [libraryDirectory stringByAppendingPathComponent:@"PrivateDocuments"];
 NSString *path = [privateDocs stringByAppendingPathComponent:@"p"];
 
 BOOL success = [fileManager fileExistsAtPath:path];
 if (!success) {
 return NO;
 }
 
 return YES;
 }
 
 // 課金情報を保存
 + (BOOL)dhSaveAppPurchasedInfo:(NSString *)purchase {
 
 NSFileManager *fileManager = [NSFileManager defaultManager];
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
 NSString *libraryDirectory = [paths objectAtIndex:0];
 
 // Libraryディレクトリの場合は、Privateディレクトリを掘るのがマナー
 NSString *privateDocs = [libraryDirectory stringByAppendingPathComponent:@"PrivateDocuments"];
 BOOL success = [fileManager fileExistsAtPath:privateDocs];
 if (!success) {
 success = [fileManager createDirectoryAtPath:privateDocs withIntermediateDirectories:YES attributes:nil error:NULL];
 }
 
 // 文字列をハッシュにして書き込む
 NSString *saveString = [NSString stringWithFormat:@"%d", purchase.hash];
 // pというファイルに課金情報を書き込む
 NSString *path = [privateDocs stringByAppendingPathComponent:@"p"];
 success = [saveString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
 
 return success;
 }
 
 #pragma mark - DocumentLibrary
 
 + (NSString *)dhFileExistsInDocumentsDirectory:(NSString *)fileName {
 
 NSFileManager *fileManager = [NSFileManager defaultManager];
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 
 NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
 BOOL success = [fileManager fileExistsAtPath:path];
 
 if (!success) {
 return nil;
 }
 
 return path;
 }
 
 #pragma mark - CalendarLibrary
 + (void)dhShowInViewInCalendar:(id)actionSheetDelegate initialDate:(NSDate *)date
 pickerTag:(NSInteger)tag targetView:(UIView *)view{
 
 UIActionSheet *actionSheet;
 UIDatePicker *datePicker;
 NSCalendar *calendar;
 
 actionSheet = [[UIActionSheet alloc] initWithTitle:nil
 delegate:actionSheetDelegate
 cancelButtonTitle:nil
 destructiveButtonTitle:nil
 otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
 
 // Add the picker
 datePicker = [[UIDatePicker alloc] init];
 datePicker.datePickerMode = UIDatePickerModeDate;
 
 calendar = [[NSCalendar alloc] initWithCalendarIdentifier:
 [[NSCalendar currentCalendar] calendarIdentifier]];
 [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier: NSLocalizedString(@"dateLocate", nil)]];
 [datePicker setCalendar:calendar];
 
 datePicker.date = date;
 datePicker.tag = tag;
 
 actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
 
 // タブの中のviewを指定すると警告が出る。
 [actionSheet addSubview:datePicker];
 [actionSheet showInView:view];
 
 CGRect menuRect = actionSheet.frame;
 menuRect.origin.y = 130;
 menuRect.size.height = 295;
 actionSheet.frame = menuRect;
 
 CGRect pickerRect = datePicker.frame;
 pickerRect.origin.y = 85;
 datePicker.frame = pickerRect;
 }
 
 #pragma mark - DateLibrary
 // グリニッジ標準時で時間を初期化して返す
 + (NSDate *)dhDateToDate:(NSDate *)target{
 
 NSTimeInterval interval = [target timeIntervalSince1970];
 // 時差9時間を引くには↓だが、0時に買い物というのも変なので、あえてしない(9:00に買い物した事にする)。
 //interval += 60*60*9;
 
 // 分秒を算出
 int pastSeconds = ( (int)interval % (60 * 60 * 24) );
 // 設定された日付の0:00:00にして返す
 NSDate *result =  [target dateByAddingTimeInterval:(0 - pastSeconds)];
 
 return result;
 }
 
 // NSDateをNSStringにして返却
 // DateFormatは端末の言語設定を取得して自動判別する
 // 2012-4-1 00:00:00 or 平成24年4月1日 00:00:00
 + (NSString *)dhDateToString:(NSDate *)target{
 NSString *retValue;
 
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 
 dateFormatter.dateFormat = [DHLibrary dhDateFormat];
 dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"dateLocale", nil)];
 dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:
 [[NSCalendar currentCalendar] calendarIdentifier]];
 
 retValue = [dateFormatter stringFromDate:target];
 
 return retValue;
 }
 */

 // NSDateをNSStringにして返却
 // DateFormatは端末の言語設定を取得して自動判別する
 // 2012-4-1 or 平成24年4月1日
+ (NSString *)dhDateToStringOnlyYearMonth:(NSDate *)target{
    NSString *retValue;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    dateFormatter.dateFormat = [DHLibrary dhDateFormatOnlyYearMonth];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];

    dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:
                              [[NSCalendar currentCalendar] calendarIdentifier]];

    retValue = [dateFormatter stringFromDate:target];

    return retValue;
}

// NSDateからNSDateComponentsを生成し、JST日付を得る。
+ (NSDateComponents *)dhDateToJSTComponents:(NSDate *)from {
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *result =
        [calendar components:NSCalendarUnitYear|
                             NSCalendarUnitMonth|
                             NSCalendarUnitDay|
                             NSCalendarUnitHour|
                             NSCalendarUnitMinute|
                             NSCalendarUnitSecond fromDate:from];

    return result;
}

// 1ヶ月後のNSDateを作る関数。使う？
//+(void)test {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSDate *today = [formatter dateFromString:@"2014-05-29 19:30:00"];
//    
//    // 1年2ヶ月後を指定
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setYear:1];
//    [comps setMonth:2];
//    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDate *date = [calendar dateByAddingComponents:comps toDate:today options:0];
//    
//    NSLog(@"%@", [formatter stringFromDate:today]);
//    // > 2014-05-29 19:30:00
//    
//    NSLog(@"%@", [formatter stringFromDate:date]);
//    // > 2015-07-29 19:30:00
//}


/*
 // NSDateをNSStringにして返却
 // DateFormatは端末の言語設定を取得して自動判別する
 // 1日
 + (NSString *)dhDateToStringOnlyDay:(NSDate *)target{
 NSString *retValue;
 
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 
 dateFormatter.dateFormat = [DHLibrary dhDateFormatOnlyDay];
 dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"dateLocale", nil)];
 dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:
 [[NSCalendar currentCalendar] calendarIdentifier]];
 
 retValue = [dateFormatter stringFromDate:target];
 
 return retValue;
 }
 
 // 端末の言語環境設定（カレンダー)に合わせたDateFormatを返却
 + (NSString *)dhDateFormat {
 NSString *result;
 
 NSString *calendarIdentifier = [[NSCalendar currentCalendar] calendarIdentifier];
 if([calendarIdentifier isEqualToString:@"japanese"]) {
 result = NSLocalizedString(@"japaneseDateFormat", nil);
 } else {
 result = NSLocalizedString(@"defaultDateFormat", nil);
 }
 
 return result;
 }
 */

 // 端末の言語環境設定（カレンダー)に合わせたDateFormatを返却
 + (NSString *)dhDateFormatOnlyYearMonth {
    NSString *result;

    NSString *calendarIdentifier = [[NSCalendar currentCalendar] calendarIdentifier];

     if([calendarIdentifier isEqualToString:@"japanese"]) {
        result = @"GGyy年M月";
    } else {
        result = @"yyyy年M月";
    }

     return result;
}


// 端末の言語環境設定（カレンダー)に合わせたDateFormatを返却
+ (NSString *)dhDateFormatOnlyYearMonthDay {
    NSString *result;

    NSString *calendarIdentifier = [[NSCalendar currentCalendar] calendarIdentifier];
    if([calendarIdentifier isEqualToString:@"japanese"]) {
    result = NSLocalizedString(@"japaneseDateFormatYearMonthDay", nil);
    } else {
    result = NSLocalizedString(@"defaultDateFormatYearMonthDay", nil);
    }

    return result;
}
 
// 端末の言語環境設定（カレンダー)に合わせたDateFormatを返却
// + (NSString *)dhDateFormatOnlyDay {
// NSString *result;
// 
// NSString *calendarIdentifier = [[NSCalendar currentCalendar] calendarIdentifier];
// if([calendarIdentifier isEqualToString:@"japanese"]) {
// result = NSLocalizedString(@"japaneseDateFormatDay", nil);
// } else {
// result = NSLocalizedString(@"defaultDateFormatDay", nil);
// }
// 
// return result;
// }


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
