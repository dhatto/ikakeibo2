//
//  CostInputCell.m
//  ikakeibo
//
//  Created by hattori on 2016/03/13.
//  Copyright © 2016年 mashupnext. All rights reserved.
//

#import "CostInputCell.h"
#import "DHLibrary.h"
#import "InputAccessoryView.h"

@implementation CostInputCell

- (void)awakeFromNib {
    [super awakeFromNib];

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
                                                                    constant:-10.0]; // 右だけ少し空ける
    
    NSArray *layoutConstraints = @[layoutTop,
                                   layoutBottom,
                                   layoutLeft,
                                   layoutRight];

    // 生成したレイアウトを配列でまとめて設定する
    [self addConstraints:layoutConstraints];
}

-(void)moneyInputFieldSettings {

    _moneyInputField = [[DHUITextField alloc] initWithFrame:self.frame];

    _moneyInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _moneyInputField.clearsOnBeginEditing = YES;
    _moneyInputField.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:52];
    _moneyInputField.textAlignment = NSTextAlignmentCenter;
    _moneyInputField.borderStyle = UITextBorderStyleNone;
    _moneyInputField.keyboardType = UIKeyboardTypeNumberPad;
    _moneyInputField.placeholder = NSLocalizedString(@"金 額", nil);
    _moneyInputField.tag = 1;
    _moneyInputField.delegate = self;

    // 閉じるボタン付きのアクセサリビューをつける
    InputAccessoryView *view = [[InputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    [view.closeButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];

    [_moneyInputField setInputAccessoryView:view];

    // AutoLayoutで制約をつけたいので、AutoResizingMaskをオフにする
    [_moneyInputField setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self addSubview:_moneyInputField];

    // AutoLayoutで制約をつける(addSubViewの後でやる事)
    [self addConstraintTo:_moneyInputField];
}

- (NSString *)createStringAddedCommaFromInt:(int)number
{
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    [format setGroupingSeparator:@","];
    [format setGroupingSize:3];

    return [format stringForObjectValue:[NSNumber numberWithInt:number]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length != 0) {
        NSString *text = [textField.text substringFromIndex:1];
        int value = text.intValue;

        NSString *setText = [self createStringAddedCommaFromInt:value];
        textField.text = [NSString stringWithFormat:@"%@%@",
                          NSLocalizedString(@"YEN", nil), setText];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length == 0) {
        textField.text = [NSString stringWithFormat:@"%@%@",
                          NSLocalizedString(@"YEN", nil), textField.text];
    }

    return YES;
}

/*
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
*/

@end


