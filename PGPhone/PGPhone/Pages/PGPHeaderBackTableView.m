//
//  DDHeaderBackTableView.m
//  DDCash
//
//  Created by xxxx on 2018/9/18.
//  Copyright © 2018年 openSource. All rights reserved.
//

#import "PGPHeaderBackTableView.h"

@interface PGPHeaderBackTableView ()

@property (strong ,nonatomic) UIImageView *backgroundImageView;


@property (strong ,nonatomic) UIImageView *pullImageView;


@end

@implementation PGPHeaderBackTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)didAddSubview:(UIView *)subview{
//    if (self.tableHeaderView) {
//        [self sendSubviewToBack:self.tableHeaderView];
//    }
    if (_backgroundImageView) {
        [self sendSubviewToBack:_backgroundImageView];
    }
    if (_pullImageView) {
        [self sendSubviewToBack:_pullImageView];
    }
}


#pragma mark -

- (UIImageView *)pullImageView{
    if (_pullImageView == nil) {
        _pullImageView = [[UIImageView alloc] init];
        _pullImageView.contentMode = UIViewContentModeScaleToFill;
        
        [self addSubview:_pullImageView];
        [self sendSubviewToBack:_pullImageView];
    }
    return _pullImageView;
}

- (UIImageView *)backgroundImageView{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        
        [self addSubview:_backgroundImageView];
        [self sendSubviewToBack:_backgroundImageView];
    }
    return _backgroundImageView;
}

@end
