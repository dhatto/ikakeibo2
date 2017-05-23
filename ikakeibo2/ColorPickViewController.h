//
//  ColorPickViewController..h
//  ikakeibo2
//
//  Created by daigoh on 2017/05/23.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Pods/Color-Picker-for-iOS/ColorPicker/HRColorPickerView.h"

@interface ColorPickViewController : UIViewController
@property (weak, nonatomic) IBOutlet HRColorPickerView *picker;
@property (nonatomic, strong) UIColor *color;

@end
