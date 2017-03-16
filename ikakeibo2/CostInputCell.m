//
//  CostInputCell.m
//  ikakeibo
//
//  Created by hattori on 2016/03/13.
//  Copyright © 2016年 mashupnext. All rights reserved.
//

#import "CostInputCell.h"
#import "DHUITextField.h"
//#import "KBRecordInputViewController.h"

@interface CostInputCell()
@property (nonatomic,strong) DHUITextField *moneyInputField;
@property (nonatomic,strong) UIButton *closeButton;
@end

@implementation CostInputCell

// ↓呼び出されない
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//
//    //レイアウトをアップデート
//    //[self updateLayout];
//
//    return self;
//}

- (void)awakeFromNib {
    // Initialization code
    [self closeButtonSettings];
    [self moneyInputFieldSettings];

    //self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Procedure
-(void)hideKeyboard:(id)sender{
    [self endEditing:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setup

-(void)closeButtonSettings {
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(260,5,50,25);
    [_closeButton setTitle:NSLocalizedString(@"×", nil) forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)moneyInputFieldSettings {

    NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.frame));
    
    _moneyInputField = [[DHUITextField alloc] initWithFrame:CGRectMake
             (0, 0, self.frame.size.width, 44 * 1.5)];
    
    _moneyInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //todo _moneyInputField.tag = viewRowTypePriceInput;
    
    _moneyInputField.clearsOnBeginEditing = YES;
    _moneyInputField.font = [UIFont fontWithName:@"DBLCDTempBlack" size:36];
    _moneyInputField.textAlignment = UITextAlignmentRight;
    _moneyInputField.borderStyle = UITextBorderStyleNone;
    _moneyInputField.keyboardType = UIKeyboardTypeNumberPad;
    _moneyInputField.placeholder = NSLocalizedString(@"金額", nil);

    //.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //.backgroundColor = [UIColor blueColor];

    // TextFieldに閉じるボタンを貼付け
    [_moneyInputField setAccessoryView:CGRectMake(0,0,320,35) backgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] subView:_closeButton];

    [self.contentView addSubview:_moneyInputField];
}


@end


