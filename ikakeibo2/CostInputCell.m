//
//  CostInputCell.m
//  ikakeibo
//
//  Created by hattori on 2016/03/13.
//  Copyright © 2016年 mashupnext. All rights reserved.
//

#import "CostInputCell.h"
#import "DHUITextField.h"

@interface CostInputCell()
@property (nonatomic,strong) DHUITextField *moneyInputField;
@property (nonatomic,strong) UIButton *closeButton;
@end

@implementation CostInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    [self closeButtonSettings];
    [self moneyInputFieldSettings];
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

- (void)addConstraintTo:(UIView*)target
{
    NSLayoutConstraint *layoutTop = [NSLayoutConstraint constraintWithItem:target
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.0];
    
    NSLayoutConstraint *layoutBottom = [NSLayoutConstraint constraintWithItem:target
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0.0];
    
    NSLayoutConstraint *layoutLeft = [NSLayoutConstraint constraintWithItem:target
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0
                                                                   constant:0.0];
    
    NSLayoutConstraint *layoutRight = [NSLayoutConstraint constraintWithItem:target
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0
                                                                    constant:-10.0];
    
    NSArray *layoutConstraints = @[layoutTop,
                                   layoutBottom,
                                   layoutLeft,
                                   layoutRight];

    // 生成したレイアウトを配列でまとめて設定する
    [self addConstraints:layoutConstraints];
}

-(void)moneyInputFieldSettings {

    NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.frame));

    _moneyInputField = [[DHUITextField alloc] initWithFrame:self.frame];
    //_moneyInputField = [[DHUITextField alloc] initWithFrame:CGRectMake(10, 10, 200, 44)];

    _moneyInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //todo _moneyInputField.tag = viewRowTypePriceInput;

    _moneyInputField.clearsOnBeginEditing = YES;
    _moneyInputField.font = [UIFont fontWithName:@"DBLCDTempBlack" size:36];
    _moneyInputField.textAlignment = UITextAlignmentRight;
    _moneyInputField.borderStyle = UITextBorderStyleNone;
    _moneyInputField.keyboardType = UIKeyboardTypeNumberPad;
    _moneyInputField.placeholder = NSLocalizedString(@"金額", nil);

    // TextFieldに閉じるボタンを貼付け
    [_moneyInputField setAccessoryView:CGRectMake(0,0,320,35) backgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] subView:_closeButton];

    // AutoResizingMaskでのレイアウトをオフにする
    [_moneyInputField setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self addSubview:_moneyInputField];
    [self addConstraintTo:_moneyInputField];
}


@end


