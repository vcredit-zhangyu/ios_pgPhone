//
//  CustomViewController.h
//  CustomNavigationBarDemo
//
//  Created by jimple on 14-1-6.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLNavgationBar.h"

@interface CustomViewController : UIViewController


@property (nonatomic,strong) LLNavgationBarView *navgationBar;

@property (nonatomic,strong) UIView *backView;
@property (nonatomic ,strong)UIButton *leftbackBtn;

@property (assign ,nonatomic) BOOL  isNeedBackView;
@property (nonatomic,strong) UIColor *leftBtnColor;


/**
 是否允许该页面侧滑

 @return YES or NO
 */
- (BOOL)isInteractivePopGesture;

@end
