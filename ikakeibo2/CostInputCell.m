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
    // frameの設定は不要。制約で設定するので。
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundColor:[UIColor grayColor]];
    [_closeButton setTitle:NSLocalizedString(@"閉じる", nil) forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.translatesAutoresizingMaskIntoConstraints = false;
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
                                                                    constant:-10.0]; // 右だけ少し空ける
    
    NSArray *layoutConstraints = @[layoutTop,
                                   layoutBottom,
                                   layoutLeft,
                                   layoutRight];

    // 生成したレイアウトを配列でまとめて設定する
    [self addConstraints:layoutConstraints];
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

-(void)moneyInputFieldSettings {

//    NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
//    NSLog(@"%@",NSStringFromCGRect(self.frame));

    _moneyInputField = [[DHUITextField alloc] initWithFrame:self.frame];

    _moneyInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _moneyInputField.clearsOnBeginEditing = YES;
    _moneyInputField.font = [UIFont fontWithName:@"DBLCDTempBlack" size:36];
    _moneyInputField.textAlignment = NSTextAlignmentRight;
    _moneyInputField.borderStyle = UITextBorderStyleNone;
    _moneyInputField.keyboardType = UIKeyboardTypeNumberPad;
    _moneyInputField.placeholder = NSLocalizedString(@"金額", nil);

//    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    // view.alpha = 0.5;
    [view addSubview:_closeButton];

    [self addConstraintForCloseButton:_closeButton toItem:view];

    // TextFieldに閉じるボタンを貼付け
    // このやり方だと、accessoryViewとsubViewの間に制約を設定できない（accessoryViewが取得できないため）
    // subViewの幅を端末サイズ一杯にすれば、制約が無くてもうまく配置できそうだが、端末が回転されるとデザインが崩れてしまう。
    // [_moneyInputField setAccessoryView: CGRectMake(0, 0, 0, 50) // この値は、高さしか見ていない模様
    //                       backgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] subView:view];

    [_moneyInputField setInputAccessoryView:view];

    // AutoLayoutで制約をつけたいので、AutoResizingMaskをオフにする
    [_moneyInputField setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self addSubview:_moneyInputField];

    // AutoLayoutで制約をつける(addSubViewの後でやる事)
    [self addConstraintTo:_moneyInputField];
}

@end


