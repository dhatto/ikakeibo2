//
//  CostInputCell.h
//  ikakeibo
//
//  Created by hattori on 2016/03/13.
//  Copyright © 2016年 mashupnext. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHUITextField.h"

@interface CostInputCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, weak) id<UITextFieldDelegate> delegate;
@property (nonatomic,strong) DHUITextField *moneyInputField;

@end
