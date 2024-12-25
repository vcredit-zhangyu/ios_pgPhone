//
//  UIView+LL_Hook.m
//  LLNavgationBar
//
//  Created by xxxx on 2017/5/12.
//  Copyright © 2017年 xxxx. All rights reserved.
//

#import "UIView+LL_Config.h"
#import <objc/runtime.h>

@implementation UIView (LL_Config)

- (UIViewController *)viewController {
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder);
    return nil;
}

+ (void)load{
    [self exchangeInstanceMethod1:@selector(didAddSubview:) method2:@selector(ll_didAddSubview:)];
}

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

- (void)ll_didAddSubview:(UIView *)subview{
    [self ll_didAddSubview:subview];
    dispatch_block_t hook = objc_getAssociatedObject(self, @selector(ll_setHook:));
    hook ? hook() : nil;
}


- (void)ll_setHook:(dispatch_block_t)hook{
    objc_setAssociatedObject(self, _cmd, hook, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

#pragma mark - simpleLayout
@implementation UIView (SimpleLayout)

#pragma mark - SuperView make_constraint
- (NSLayoutConstraint *)make_constraintSuperView:(NSLayoutAttribute)attribute inset:(CGFloat)inset{
    UIView *ofView = self.superview;
    NSLayoutAttribute toAttribute = attribute;
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        ofView = nil;
        toAttribute = NSLayoutAttributeNotAnAttribute;
    }
    return [self make_constraint:attribute toAttribute:toAttribute ofView:ofView inset:inset];
}

- (NSLayoutConstraint *)make_constraintSuperView:(NSLayoutAttribute)attribute relation:(NSLayoutRelation)relation inset:(CGFloat)inset{
    UIView *ofView = self.superview;
    NSLayoutAttribute toAttribute = attribute;
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        ofView = nil;
        toAttribute = NSLayoutAttributeNotAnAttribute;
    }
    return [self make_constraint:attribute toAttribute:toAttribute ofView:ofView relation:relation inset:inset];
}

- (NSLayoutConstraint *)make_constraintDimension:(NSLayoutAttribute)attribute inset:(CGFloat)inset{
    return [self make_constraint:attribute toAttribute:NSLayoutAttributeNotAnAttribute ofView:nil relation:NSLayoutRelationEqual inset:inset];
}

- (NSArray *)make_constraintDimensions:(CGSize)size{
    NSMutableArray *constraints = [[NSMutableArray alloc]init];
    [constraints addObject:[self make_constraintDimension:NSLayoutAttributeWidth inset:size.width]];
    [constraints addObject:[self make_constraintDimension:NSLayoutAttributeHeight inset:size.height]];
    return constraints;
}

- (NSArray *)make_constraintSuperViewWithEdges:(UIEdgeInsets)edge{
    NSMutableArray *constraints = [[NSMutableArray alloc]init];
    [constraints addObject:[self make_constraintSuperView:NSLayoutAttributeTop inset:edge.top]];
    [constraints addObject:[self make_constraintSuperView:NSLayoutAttributeLeft inset:edge.left]];
    [constraints addObject:[self make_constraintSuperView:NSLayoutAttributeBottom inset:edge.bottom]];
    [constraints addObject:[self make_constraintSuperView:NSLayoutAttributeRight inset:edge.right]];
    return constraints;
}

- (NSArray *)make_constraintSuperViewWithEdges:(UIEdgeInsets)edge excludingEdge:(UIRectEdge)excludingEdge{
    NSMutableArray *constraints = [[NSMutableArray alloc]init];
    if (excludingEdge != UIRectEdgeTop) {
        [constraints addObject:[self make_constraintSuperView:NSLayoutAttributeTop inset:edge.top]];
    }
    if (excludingEdge != UIRectEdgeLeft) {
        [constraints addObject:[self make_constraintSuperView:NSLayoutAttributeLeft inset:edge.left]];
    }
    if (excludingEdge != UIRectEdgeBottom) {
        [constraints addObject:[self make_constraintSuperView:NSLayoutAttributeBottom inset:edge.bottom]];
    }
    if (excludingEdge != UIRectEdgeRight) {
        [constraints addObject:[self make_constraintSuperView:NSLayoutAttributeRight inset:edge.right]];
    }
    return constraints;
}

#pragma mark - make_constraint
- (NSLayoutConstraint *)make_constraint:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofView:(UIView *)otherView inset:(CGFloat)inset{
    return [self make_constraint:attribute toAttribute:toAttribute ofView:otherView withMultiplier:1.0f relation:NSLayoutRelationEqual inset:inset];
}

- (NSLayoutConstraint *)make_constraint:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofView:(UIView *)otherView relation:(NSLayoutRelation)relation inset:(CGFloat)inset{
    return [self make_constraint:attribute toAttribute:toAttribute ofView:otherView withMultiplier:1.0f relation:relation inset:inset];
}

- (NSLayoutConstraint *)make_constraint:(NSLayoutAttribute)attribute toAttribute:(NSLayoutAttribute)toAttribute ofView:(UIView *)otherView withMultiplier:(CGFloat)multiplier relation:(NSLayoutRelation)relation inset:(CGFloat)inset{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (attribute == NSLayoutAttributeBottom || attribute == NSLayoutAttributeRight) {
        inset = -inset;
    }
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:relation toItem:otherView attribute:toAttribute multiplier:multiplier constant:inset];
    [self.superview addConstraint:constraint];
    return constraint;
}

@end
