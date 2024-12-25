//
//  VLToast.h
//  ToastDemo
//
//  Created by openSource on 14-7-22.
//  Copyright (c) 2014年 openSource. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define DEFAULT_DISPLAY_DURATION 1.5f


@interface VLToast : NSObject
{
    NSString *text;
    UIButton *contentView;
    CGFloat  duration;
}

+ (void)showText:(NSString *)text andImage:(UIImage *)image;

/**
 *  显示信息
 *
 *  @param text_ 要显示的内容
 */
+ (void)showWithText:(NSString *) text_;

+ (void)showWithText:(NSString *)text view:(UIView *)view;

/**
 *  显示信息，并在规定的时间内消失
 *
 *  @param text_     要显示的内容
 *  @param duration_ 显示的时间
 */

+ (void)showWithText:(NSString *) text_
            duration:(CGFloat)duration_;

/**
 *  显示信息，并规定显示的位置（距Y轴顶部）
 *
 *  @param text_      显示的内容
 *  @param topOffset_ 位置（距Y轴顶部）
 */
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset_;

/**
 *  显示信息，并规定Y轴位置，在固定的时间内消失
 *
 *  @param text_     显示的内容
 *  @param topOffset Y轴顶部的位置
 *  @param duration_ 显示的时长
 */
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration_;
/**
 *  显示信息，并规定Y轴与底部的距离
 *
 *  @param text_         显示的信息
 *  @param bottomOffset_ 距离Y轴底部的位置
 */
+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_;

/**
 *  显示信息，并规定Y轴底部的距离，在固定的时间内消失
 *
 *  @param text_         要显示的内容
 *  @param bottomOffset_ 距离Y轴底部的距离
 *  @param duration_     显示时长
 */
+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_
            duration:(CGFloat) duration_;
@end
