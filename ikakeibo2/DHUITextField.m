//
//  DHUITextField.m
//  i家計簿
//
//  Created by 服部 太恒 on 12/01/21.
//  Copyright (c) 2012年 Touhu Soft. All rights reserved.
//

#import "DHUITextField.h"

@interface DHUITextField()
@property (nonatomic,strong) UIButton *closeButton;
@end

@implementation DHUITextField

#pragma mark - Procedure

-(void)hideKeyboard:(id)sender{
    [self endEditing:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self closeButtonSettings];
    [self moneyInputFieldSettings];
}

#pragma mark - Setup

-(void)closeButtonSettings {
    // frameの設定は不要。制約で設定するので。
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundColor:[UIColor grayColor]];
    [_closeButton setTitle:NSLocalizedString(@"閉じる", nil) forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.translatesAutoresizingMaskIntoConstraints = false;
}

-(void)moneyInputFieldSettings {
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.clearsOnBeginEditing = YES;
    self.font = [UIFont fontWithName:@"DBLCDTempBlack" size:72];
    self.textAlignment = NSTextAlignmentCenter;
    self.borderStyle = UITextBorderStyleNone;
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.placeholder = NSLocalizedString(@"金額", nil);
    self.delegate = self;

    [self setInputAccessoryView:[self createAccessoryView]];
}

-(UIView*)createAccessoryView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [view addSubview:_closeButton];
    
    [self addConstraintForCloseButton:_closeButton toItem:view];
    
    return view;
}

- (void)addConstraintForCloseButton:(UIView*)target toItem:(UIView*)toView
{
    NSLayoutConstraint *layoutTop = [NSLayoutConstraint constraintWithItem:target
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:toView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:5.0];
    
    NSLayoutConstraint *layoutBottom = [NSLayoutConstraint constraintWithItem:target
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:toView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:-5.0];
    
    NSLayoutConstraint *layoutWidth = [NSLayoutConstraint constraintWithItem:target
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0
                                                                    constant:100.0];
    
    NSLayoutConstraint *layoutRight = [NSLayoutConstraint constraintWithItem:target
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:toView
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0
                                                                    constant:-5.0];
    
    NSArray *layoutConstraints = @[layoutTop,
                                   layoutBottom,
                                   layoutWidth,
                                   layoutRight];
    
    // 生成したレイアウトを配列でまとめて設定する
    [toView addConstraints:layoutConstraints];
}

#pragma mark - textFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 先頭に¥をつける
    textField.text = [NSString stringWithFormat:@"%@%@",
                      NSLocalizedString(@"YEN", nil), textField.text];
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
 
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
 return YES;
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
