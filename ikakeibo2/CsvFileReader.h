//
//  CsvFileReader.h
//  i家計簿
//
//  Created by 服部 太恒 on 12/04/22.
//  Copyright (c) 2012年 TouhuSoft. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CsvFileReader : NSObject

-(NSInteger)ImportCsv:(NSString *)csvText;

@end
