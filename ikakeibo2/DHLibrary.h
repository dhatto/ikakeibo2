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
// "1000" -> ¥1,000
+ (NSString *)dhStringToStringWithMoneyFormat:(NSString *)target;
// "¥1,000" -> 1000
+ (NSInteger)dhStringWithMoneyFormatToInteger:(NSString *)target;

@end

#endif /* DHLibrary_h */
