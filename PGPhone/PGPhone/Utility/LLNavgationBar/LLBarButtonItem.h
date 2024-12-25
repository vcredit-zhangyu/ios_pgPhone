//
//  LLBarButtonItem.h
//  LLNavgationBar
//
//  Created by xxxx on 2017/5/17.
//  Copyright © 2017年 xxxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLBarButtonItem : UIView

@property (strong ,nonatomic) UILabel *titleLabel;

@property (strong ,nonatomic) UIImageView *imageView;

@property (strong ,nonatomic) UIView *customView;

@property (copy ,nonatomic) void(^hanlder)(LLBarButtonItem *barButtonItem);

+ (instancetype)barButtonItemWithTitle:(NSString *)title handler:(void(^)(LLBarButtonItem *barButtonItem))handler;

+ (instancetype)barButtonItemWithImage:(UIImage *)image handler:(void(^)(LLBarButtonItem *barButtonItem))handler;

+ (instancetype)barButtonItemWithTitle:(NSString *)title image:(UIImage *)image handler:(void(^)(LLBarButtonItem *barButtonItem))handler;

+ (instancetype)barButtonItemWithCustomView:(UIView *)view handler:(void(^)(LLBarButtonItem *barButtonItem))handler;

@end



