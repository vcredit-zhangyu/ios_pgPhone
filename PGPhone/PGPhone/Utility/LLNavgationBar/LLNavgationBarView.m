//
//  LLNavgationBar.m
//  LLNavgationBar
//
//  Created by xxxx on 2017/5/12.
//  Copyright © 2017年 xxxx. All rights reserved.
//

#import "LLNavgationBarView.h"
#import <objc/runtime.h>
#import "UIView+LL_Config.h"
#import "WXAppDevice.h"

//weak
#define LL_WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
//strong
#define LL_StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;


static const CGFloat barContentHeight = 44;
static const CGFloat padding = 10;
//static const CGFloat smallPadding = 5;

@interface LLNavgationBarView ()
@property (strong ,nonatomic) UIView *leftBackView;
@property (strong ,nonatomic) UIView *rightBackView;
@property (strong ,nonatomic) UIView *contentView;
@end

@implementation LLNavgationBarView
- (void)dealloc
{
    NSLog(@"LLNavgationBarView dealloc");
}

+ (instancetype)addBarTo:(UIView *)view{
    LLNavgationBarView *barView = [[LLNavgationBarView alloc]init];
    [view addSubview:barView];
    barView.backgroundColor = [UIColor whiteColor];
    [barView make_constraintSuperView:NSLayoutAttributeTop inset:0];
    [barView make_constraintSuperView:NSLayoutAttributeLeft inset:0];
    [barView make_constraintSuperView:NSLayoutAttributeRight inset:0];
    CGFloat height = ([barView isStatusBarAddHeight] ? 20 : kStatusBarHeight) + barContentHeight;
    [barView make_constraintSuperView:NSLayoutAttributeHeight inset:height];
    return barView;
}

//判断StatusBar 是否增高
- (BOOL)isStatusBarAddHeight{
    CGFloat statusBarHeight = [WXAppDevice appStatusHeight];
    if (statusBarHeight == 40) {
        return YES;
    }
    return NO;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.barFont = [UIFont systemFontOfSize:18];
    self.barTintColor = [UIColor blackColor];    
    self.shadowView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.contentView];
}

- (void)autoAddLeftButtonItem{
    if (self.viewController.navigationController.viewControllers.count > 1 && !self.leftBarButtonItem) {
        [self.viewController.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj == self.viewController && idx > 0) {
                UIViewController *preViewController = self.viewController.navigationController.viewControllers[idx-1];
                
                NSString *title = @"返回";
                if ([preViewController.barView.titleView isKindOfClass:[UILabel class]]) {
                    UILabel *label = (UILabel *)preViewController.barView.titleView;
                    title = label.text;
                }
                @LL_WeakObj(self)
                self.backBarButtonItem = [LLBarButtonItem barButtonItemWithTitle:title image:[self drawArrow] handler:^(LLBarButtonItem *barButtonItem) {
                    @LL_StrongObj(self)
                    [self.viewController.navigationController popViewControllerAnimated:YES];
                }];
//                self.leftBarButtonItem = self.backBarButtonItem;
                *stop = YES;
            }
        }];
    }
}

/**
 绘制箭头

 @return 箭头image
 */
- (UIImage *)drawArrow{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(9, 17), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, self.barTintColor.CGColor);
    CGContextMoveToPoint(context, 8, 1);
    CGContextAddLineToPoint(context, 1, 8.5);
    CGContextAddLineToPoint(context, 8, 16);
    CGContextDrawPath(context, kCGPathStroke);
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 修改字体大小和颜色
- (void)updateFontAndColor{
    [self.leftBarButtonItems enumerateObjectsUsingBlock:^(LLBarButtonItem * _Nonnull barItem, NSUInteger idx, BOOL * _Nonnull stop) {
        if (barItem.titleLabel) {
            barItem.titleLabel.font = self.barFont;
            barItem.titleLabel.textColor = self.barTintColor;
        }
        if (barItem == self.backBarButtonItem && self.backBarButtonItem) {
            self.backBarButtonItem.imageView.image = [self drawArrow];
        }
    }];
    if ([self.titleView isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self.titleView;
        label.font = self.barFont;
        label.textColor = self.barTintColor;
    }
    [self.rightBarButtonItems enumerateObjectsUsingBlock:^(LLBarButtonItem * _Nonnull barItem, NSUInteger idx, BOOL * _Nonnull stop) {
        if (barItem.titleLabel) {
            barItem.titleLabel.font = self.barFont;
            barItem.titleLabel.textColor = self.barTintColor;
        }
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.leftBarButtonItems.count == 0) {
        [self autoAddLeftButtonItem];
        return;
    }
}

#pragma mark - UI
- (void)updateTitleView:(UIView *)view{
    [self.contentView addSubview:view];
    [view make_constraintSuperView:NSLayoutAttributeCenterX inset:0];
    [view make_constraintSuperView:NSLayoutAttributeCenterY inset:0];
    
    
    if (view.frame.size.height > 0) {
        [view make_constraintSuperView:NSLayoutAttributeHeight inset:view.frame.size.height];
    }
    if (view.frame.size.width > 0) {
        [view make_constraintSuperView:NSLayoutAttributeWidth relation:NSLayoutRelationGreaterThanOrEqual  inset:view.frame.size.width];
    }
    [view make_constraint:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeRight ofView:self.leftBackView relation:NSLayoutRelationGreaterThanOrEqual inset:0];
}

- (void)updateLeftBarItem{
    [self.leftBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.leftBarButtonItems enumerateObjectsUsingBlock:^(LLBarButtonItem * _Nonnull barItem, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.leftBackView addSubview:barItem];
        barItem.titleLabel.font = self.barFont;
    }];
    
    [self.leftBarButtonItems enumerateObjectsUsingBlock:^(LLBarButtonItem * _Nonnull barItem, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [barItem make_constraintSuperView:NSLayoutAttributeCenterY inset:0];
        [barItem make_constraintSuperView:NSLayoutAttributeTop relation:NSLayoutRelationGreaterThanOrEqual inset:0];

        //idx == 0 设置与父试图的左边距
        if (idx == 0) {
            [barItem make_constraintSuperView:NSLayoutAttributeLeft inset:0];
        }
        //当前是否为最后一个视图 设置与父试图（otherView）的右边距
        if (idx == self.leftBarButtonItems.count - 1) {
            [barItem make_constraintSuperView:NSLayoutAttributeRight inset:0];
        }else{
            LLBarButtonItem *nextBarItem = self.leftBarButtonItems[idx + 1];
            [barItem make_constraint:NSLayoutAttributeRight toAttribute:NSLayoutAttributeLeft ofView:nextBarItem inset:padding];
        }
    }];
}

- (void)updateRightBarItem{
    [self.rightBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.rightBarButtonItems enumerateObjectsUsingBlock:^(LLBarButtonItem * _Nonnull barItem, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.rightBackView addSubview:barItem];
        barItem.titleLabel.font = self.barFont;
    }];
    
    [self.rightBarButtonItems enumerateObjectsUsingBlock:^(LLBarButtonItem * _Nonnull barItem, NSUInteger idx, BOOL * _Nonnull stop) {
        [barItem make_constraintSuperView:NSLayoutAttributeCenterY inset:0];
        [barItem make_constraintSuperView:NSLayoutAttributeTop relation:NSLayoutRelationGreaterThanOrEqual inset:0];
        //idx == 0 设置与父试图的右边距
        if (idx == 0) {
            [barItem make_constraintSuperView:NSLayoutAttributeRight inset:0];
        }
        //当前是否为最后一个视图 设置与父试图（otherView）的右边距
        if (idx == self.rightBarButtonItems.count - 1) {
            [barItem make_constraintSuperView:NSLayoutAttributeLeft inset:0];
        }else{
            LLBarButtonItem *nextBarItem = self.rightBarButtonItems[idx + 1];
            [barItem make_constraint:NSLayoutAttributeLeft toAttribute:NSLayoutAttributeRight ofView:nextBarItem inset:padding];
        }
    }];
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    if (_titleView && [_titleView isKindOfClass:[UILabel class]]) {
        UILabel *titleLabel = (UILabel *)_titleView;
        titleLabel.text = title;
        return;
    }
    UILabel *item = [[UILabel alloc]init];;
    item.font = self.barFont;
    item.textColor = self.barTintColor;
    item.textAlignment = NSTextAlignmentCenter;
    item.text = title;
    item.numberOfLines = 2;
    self.titleView = item;
}

- (void)setTitleAttributedString:(NSAttributedString *)titleAttributedString{
    _titleAttributedString = titleAttributedString;
    if (_titleView && [_titleView isKindOfClass:[UILabel class]]) {
        UILabel *titleLabel = (UILabel *)_titleView;
        titleLabel.attributedText = titleAttributedString;
        return;
    }
    UILabel *item = [[UILabel alloc]init];;
    item.font = self.barFont;
    item.textColor = self.barTintColor;
    item.textAlignment = NSTextAlignmentCenter;
    item.attributedText = titleAttributedString;
    item.numberOfLines = 2;
    self.titleView = item;
}


- (void)setTitleView:(UIView *)titleView{
    if (_titleView) {
        [_titleView removeFromSuperview];
        _titleView = nil;
    }
    _titleView = titleView;
    [self updateTitleView:titleView];
}

- (void)setBackBarButtonItem:(LLBarButtonItem *)backBarButtonItem{
    _backBarButtonItem = backBarButtonItem;
    self.leftBarButtonItem = backBarButtonItem;
}

- (void)setLeftBarButtonItem:(LLBarButtonItem *)leftBarButtonItem{
    _leftBarButtonItem = leftBarButtonItem;
    if (leftBarButtonItem) {
        self.leftBarButtonItems = @[_leftBarButtonItem];
    }else{
        self.leftBarButtonItems = nil;
    }
}

- (void)setLeftBarButtonItems:(NSArray<LLBarButtonItem *> *)leftBarButtonItems{
    _leftBarButtonItems = leftBarButtonItems;
    [self updateLeftBarItem];
}

- (void)setRightBarButtonItem:(LLBarButtonItem *)rightBarButtonItem{
    _rightBarButtonItem = rightBarButtonItem;
    if (_rightBarButtonItem) {
        self.rightBarButtonItems = @[_rightBarButtonItem];
    }else{
        self.rightBarButtonItems = nil;
    }
}

- (void)setRightBarButtonItems:(NSArray<LLBarButtonItem *> *)rightBarButtonItems{
    _rightBarButtonItems = rightBarButtonItems;
    [self updateRightBarItem];
}

- (void)setBarFont:(UIFont *)barFont{
    _barFont = barFont;
    if (!barFont) {
        _barFont = [UIFont systemFontOfSize:16];
    }
    [self updateFontAndColor];
}

- (void)setBarTintColor:(UIColor *)barTintColor{
    _barTintColor = barTintColor;
    if (!barTintColor) {
        _barTintColor = [UIColor blackColor];
    }
    [self updateFontAndColor];
}

#pragma mark - Properties
- (void)setBarViewHidden:(BOOL)barViewHidden{
    [self setBarViewHidden:barViewHidden animated:NO];
}

- (void)setBarViewHidden:(BOOL)barViewHidden animated:(BOOL)animated{
    _barViewHidden = barViewHidden;
    CGFloat topInset = 0;
    if (barViewHidden) {
        topInset = -self.frame.size.height;
    }
    [self setTopInset:topInset animated:animated];
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = !barViewHidden;
        } completion:^(BOOL finished) {
            self.hidden = barViewHidden;
        }];
    }else{
        self.alpha = !barViewHidden;
        self.hidden = barViewHidden;
    }
}

- (void)setTopInset:(CGFloat)topInset{
    [self setTopInset:topInset animated:NO];
}

- (void)setTopInset:(CGFloat)topInset animated:(BOOL)animated{
    _topInset = topInset;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.layer.transform = CATransform3DMakeTranslation(0, topInset, 0);
        } completion:^(BOOL finished) {
        }];
    }else{
        self.layer.transform = CATransform3DMakeTranslation(0, topInset, 0);
    }
}


#pragma mark - views

- (UIView *)leftBackView{
    if (_leftBackView == nil) {
        _leftBackView = [[UIView alloc]init];
        _leftBackView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_leftBackView];
        
        [_leftBackView make_constraintSuperView:NSLayoutAttributeLeft inset:padding];
        [_leftBackView make_constraintSuperView:NSLayoutAttributeTop inset:0];
        [_leftBackView make_constraintSuperView:NSLayoutAttributeHeight inset:barContentHeight];
    }
    return _leftBackView;
}

- (UIView *)rightBackView{
    if (_rightBackView == nil) {
        _rightBackView = [[UIView alloc]init];
        _rightBackView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_rightBackView];
        
        [_rightBackView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_rightBackView make_constraintSuperView:NSLayoutAttributeTop inset:0];
        [_rightBackView make_constraintSuperView:NSLayoutAttributeRight inset:padding];
        [_rightBackView make_constraintSuperView:NSLayoutAttributeHeight inset:barContentHeight];
    }
    return _rightBackView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        [_contentView make_constraintSuperViewWithEdges:kMakeEdge(0, 0, 0, 0) excludingEdge:UIRectEdgeTop];
        [_contentView make_constraintDimension:NSLayoutAttributeHeight inset:barContentHeight];
    }
    return _contentView;
}

- (UIView *)shadowView{
    if (_shadowView == nil) {
        _shadowView = [[UIView alloc]init];
        [self addSubview:_shadowView];
        [_shadowView make_constraintSuperViewWithEdges:kMakeEdge(0, 0, 0, 0) excludingEdge:UIRectEdgeTop];
        [_shadowView make_constraintSuperView:NSLayoutAttributeHeight inset:1];
    }
    return _shadowView;
}

#pragma mark - bar 添加到父试图中
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (!self.viewController.navigationController.navigationBarHidden) {
        [self.viewController.navigationController setNavigationBarHidden:YES animated:YES];
    }
    @LL_WeakObj(self);
    [self.superview ll_setHook:^{
        @LL_StrongObj(self);
        [self.superview bringSubviewToFront:self];
    }];
}


@end

@implementation UIViewController (NavgationBar)

- (LLNavgationBarView *)barView{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[LLNavgationBarView class]]) {
            return (LLNavgationBarView *)view;
        }
    }
    return nil;
}

//- (void)setTitle:(NSString *)title{
//    self.barView.title = title;
//    self.navigationItem.title = title;
//}

@end

