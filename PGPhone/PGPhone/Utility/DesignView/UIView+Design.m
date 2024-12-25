//
//  UIView+Design.m
//  MFShop
//
//  Created by xxxx on 2017/7/25.
//  Copyright © 2017年 xxxx. All rights reserved.
//

#import "UIView+Design.h"

@implementation UIView (Design)

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

-(CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

-(CGFloat)borderWidth{
    return self.layer.borderWidth;
}

-(UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)drawGradientWithFromColor:(UIColor *)fromColor endColor:(UIColor *)endColor viewSize:(CGSize)size{
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@0.1, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    [self.layer insertSublayer:gradientLayer atIndex:0];
//    [self.layer addSublayer:gradientLayer];
}
- (void)drawYGradientWithFromColor:(UIColor *)fromColor endColor:(UIColor *)endColor viewSize:(CGSize)size endY:(CGFloat)endY{
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, endY);
    [self.layer insertSublayer:gradientLayer atIndex:0];
}


//绘制圆角
- (void)addRoundedCornersWithRadius:(CGFloat)radius rectCorner:(UIRectCorner)rectCorner size:(CGSize)viewSize {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, viewSize.width, viewSize.height) byRoundingCorners:rectCorner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end
