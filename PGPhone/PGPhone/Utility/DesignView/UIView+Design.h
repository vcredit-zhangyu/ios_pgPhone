//
//  UIView+Design.h
//  MFShop
//
//  Created by xxxx on 2017/7/25.
//  Copyright © 2017年 xxxx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (Design)

@property(nonatomic,assign) IBInspectable CGFloat cornerRadius;
@property(nonatomic,assign) IBInspectable CGFloat borderWidth;
@property(nonatomic,assign) IBInspectable UIColor *borderColor;
@property(nonatomic,assign) IBInspectable UIColor *shadowColor;
@property(nonatomic,assign) IBInspectable CGFloat shadowRadius;
@property(nonatomic,assign) IBInspectable CGFloat shadowOpacity;
@property(nonatomic,assign) IBInspectable CGSize shadowOffset;
//绘制渐变色背景
- (void)drawGradientWithFromColor:(UIColor *)fromColor endColor:(UIColor *)endColor viewSize:(CGSize)size;
//绘制从上到下渐变色背景
//endY:0~1.0
- (void)drawYGradientWithFromColor:(UIColor *)fromColor endColor:(UIColor *)endColor viewSize:(CGSize)size endY:(CGFloat)endY;
//绘制圆角
- (void)addRoundedCornersWithRadius:(CGFloat)radius rectCorner:(UIRectCorner)rectCorner size:(CGSize)viewSize;
@end
