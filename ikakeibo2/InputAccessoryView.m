//
//  InputAccessoryView.m
//  ikakeibo2
//
//  Created by daigoh on 2017/04/11.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

#import "InputAccessoryView.h"

@interface InputAccessoryView()
@end

@implementation InputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];

    if (self) {
        [self closeButtonSettings];
        [self moneyInputFieldSettings];
    }

    return self;
}

//- (void)awakeFromNib {
//}

-(void)closeButtonSettings {
    // frameの設定は不要。制約で設定するので。
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setBackgroundColor:[UIColor grayColor]];
    [_closeButton setTitle:NSLocalizedString(@"閉じる", nil) forState:UIControlStateNormal];
    
    _closeButton.translatesAutoresizingMaskIntoConstraints = false;
}

-(void)moneyInputFieldSettings {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    // view.alpha = 0.5;
    [self addSubview:_closeButton];
    [self addConstraintForCloseButton:_closeButton toItem:self];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
