//
//  CostInputCell.h
//  ikakeibo
//
//  Created by hattori on 2016/03/13.
//  Copyright © 2016年 mashupnext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHUITextField.h"

@protocol CostInputCellDelegate <NSObject>
@optional
- (void)didEndEditingCost: (int)value;
@end

@interface CostInputCell : UITableViewCell<UITextFieldDelegate>
- (int)textFieldFormat:(UITextField *)textField;
@property (nonatomic, strong) id<CostInputCellDelegate> delegate;
@property (nonatomic, strong) DHUITextField *moneyInputField;
@end


