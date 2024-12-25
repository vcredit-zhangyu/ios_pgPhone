//
//  UIView+LL_Hook.h
//  LLNavgationBar
//
//  Created by xxxx on 2017/5/12.
//  Copyright © 2017年 xxxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LL_Config)

@property (readonly) UIViewController *viewController;

- (void)ll_setHook:(dispatch_block_t)hook;

@end



#define kMakeEdge(top,left,bottom,right) UIEdgeInsetsMake(top, left, bottom, right)
@interface UIView (SimpleLayout)

#pragma mark - SuperView make_constraint
- (NSLayoutConstraint *)make_constraintSuperView:(NSLayoutAttribute)attribute inset:(CGFloat)inset;

//设置自身尺寸  width  height
- (NSLayoutConstraint *)make_constraintDimension:(NSLayoutAttribute)attribute inset:(CGFloat)inset;

- (NSArray *)make_constraintDimensions:(CGSize)size;

- (NSLayoutConstraint *)make_constraintSuperView:(NSLayoutAttribute)attribute relation:(NSLayoutRelation)relation inset:(CGFloat)inset;

- (NSArray *)make_constraintSuperViewWithEdges:(UIEdgeInsets)edge;

- (NSArray *)make_constraintSuperViewWithEdges:(UIEdgeInsets)edge excludingEdge:(UIRectEdge)excludingEdge;

#pragma mark - make_constraint
- (NSLayoutConstraint *)make_constraint:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofView:(UIView *)otherView inset:(CGFloat)inset;

- (NSLayoutConstraint *)make_constraint:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofView:(UIView *)otherView relation:(NSLayoutRelation)relation inset:(CGFloat)inset;
/**
 设置约束

 @param attribute 自身属性
 @param toAttribute 要约束的属性
 @param otherView 要约束的view
 @param multiplier 比例
 @param relation 1.0f
 @param inset 偏移量
 @return NSLayoutConstraint
 */
- (NSLayoutConstraint *)make_constraint:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofView:(UIView *)otherView withMultiplier:(CGFloat)multiplier relation:(NSLayoutRelation)relation inset:(CGFloat)inset;

@end
