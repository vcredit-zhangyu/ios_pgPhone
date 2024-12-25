//
//  LLNavgationBar.h
//  LLNavgationBar
//
//  Created by xxxx on 2017/5/12.
//  Copyright © 2017年 xxxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLBarButtonItem.h"

#define kStatusBarHeight [WXAppDevice appStatusHeight]

@interface LLNavgationBarView : UIView

/**
 创建一个BarView 加到View上面

 @param view BarView 将要添加到view上
 @return BarView
 */
+ (instancetype)addBarTo:(UIView *)view;

@property (copy ,nonatomic) NSString *title; //谁知标题,位于bar中间 默认为nil

@property (copy ,nonatomic) NSAttributedString *titleAttributedString;

@property (strong ,nonatomic) UIView *titleView;//自定义标题 ，位于bar中间

@property (strong ,nonatomic) LLBarButtonItem *backBarButtonItem;//返回BarButtonItem

@property (strong ,nonatomic) LLBarButtonItem *leftBarButtonItem;//设置左边的ButtonItem

@property (strong ,nonatomic) LLBarButtonItem *rightBarButtonItem;//设置右边的ButtonItem

@property (strong ,nonatomic) NSArray<LLBarButtonItem *> *leftBarButtonItems;//设置左边的ButtonItem 多个

@property (strong ,nonatomic) NSArray<LLBarButtonItem *> *rightBarButtonItems;//设置右边的ButtonItem 多个

@property (strong ,nonatomic) UIView *shadowView; //底部的线条

#pragma mark - 配置信息
@property (strong ,nonatomic) UIFont *barFont;// bar 字体大小

@property (strong ,nonatomic) UIColor *barTintColor;// bar 文字颜色

#pragma mark - 
@property (assign ,nonatomic) BOOL barViewHidden; //bar 是否隐藏
- (void)setBarViewHidden:(BOOL)barViewHidden animated:(BOOL)animated;

@property (assign ,nonatomic) CGFloat topInset; //bar 距离顶部的距离
- (void)setTopInset:(CGFloat)topInset animated:(BOOL)animated;
@end

@interface UIViewController (NavgationBar)

@property (readonly) LLNavgationBarView *barView;

@end
