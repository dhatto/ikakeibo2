//
//  LoadingView.m
//  ikakeibo2
//
//  Created by daigoh on 2017/05/02.
//  Copyright © 2017年 touhuSoft. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

-(void)startAnimating {
    [self addIndicatorView];
    
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:1];
    [indicator startAnimating];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.5f;

    return self;
}

- (void)addIndicatorView {
    // インジケータ作成
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [indicator setCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
    indicator.tag = 1;

    // ローディングビューに追加
    [self addSubview:indicator];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
