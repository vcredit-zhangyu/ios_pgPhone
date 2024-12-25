//
//  LLBarButtonItem.m
//  LLNavgationBar
//
//  Created by xxxx on 2017/5/17.
//  Copyright © 2017年 xxxx. All rights reserved.
//

#import "LLBarButtonItem.h"
#import "UIView+LL_Config.h"

@interface LLBarButtonItem ()

@property (copy ,nonatomic) NSString *title;

@property (strong ,nonatomic) UIImage *image;

@end

@implementation LLBarButtonItem

+ (instancetype)barButtonItemWithTitle:(NSString *)title handler:(void(^)(LLBarButtonItem *barButtonItem))handler{
    return [[LLBarButtonItem alloc]initWithTitle:title image:nil handler:handler];
}

+ (instancetype)barButtonItemWithImage:(UIImage *)image handler:(void(^)(LLBarButtonItem *barButtonItem))handler{
    return [[LLBarButtonItem alloc]initWithTitle:nil image:image handler:handler];
}

+ (instancetype)barButtonItemWithTitle:(NSString *)title image:(UIImage *)image handler:(void(^)(LLBarButtonItem *barButtonItem))handler{
    return [[LLBarButtonItem alloc] initWithTitle:title image:image handler:handler];
}

+ (instancetype)barButtonItemWithCustomView:(UIView *)view handler:(void(^)(LLBarButtonItem *barButtonItem))handler{
    return [[LLBarButtonItem alloc]initWithView:view handler:handler];
}

- (instancetype)initWithView:(UIView *)view handler:(void(^)(LLBarButtonItem *barButtonItem))handler{
    self = [super init];
    if (self) {
        _customView = view;
        _hanlder = handler;
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image handler:(void(^)(LLBarButtonItem *barButtonItem))handler{
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _hanlder = handler;
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    //添加首饰
    if (_hanlder) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tap];
    }
    
    //设置layout
    if (self.customView) {
        self.customView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.customView];
        [self setCustomViewLayout];
        return;
    }
    
    if (self.title) {
        [self addSubview:self.titleLabel];
        self.titleLabel.text = self.title;
    }
    
    if (self.image) {
        [self addSubview:self.imageView];
        self.imageView.image = self.image;
    }
    [self setTitleAndImageLayout];
}


- (void)setCustomViewLayout{
    [self.customView make_constraintSuperViewWithEdges:kMakeEdge(0, 0, 0, 0)];
    if (self.customView.frame.size.height > 0) {
        [self.customView make_constraintSuperView:NSLayoutAttributeHeight inset:MIN(44, self.customView.frame.size.height)];
    }
    if (self.customView.frame.size.width > 0) {
        [self.customView make_constraintSuperView:NSLayoutAttributeWidth inset:self.customView.frame.size.width];
    }
}

- (void)setTitleAndImageLayout{
    if (self.image) {
        [self.imageView make_constraintSuperView:NSLayoutAttributeLeft inset:0];
        [self.imageView make_constraintSuperView:NSLayoutAttributeTop inset:0];
        [self.imageView make_constraintSuperView:NSLayoutAttributeBottom inset:0];
    }
    if (self.title) {
        [self.titleLabel make_constraintSuperView:NSLayoutAttributeCenterY inset:0];
        [self.titleLabel make_constraintSuperView:NSLayoutAttributeRight inset:0];
    }
    if (self.title && self.image) {
        [self.imageView make_constraint:NSLayoutAttributeRight toAttribute:NSLayoutAttributeLeft ofView:self.titleLabel inset:5];
    }else if (self.title){
        [self.titleLabel make_constraintSuperView:NSLayoutAttributeLeft inset:0];
        [self.titleLabel make_constraintSuperView:NSLayoutAttributeTop inset:0];
        [self.titleLabel make_constraintSuperView:NSLayoutAttributeBottom inset:0];
    }else if (self.image) {
        [self.imageView make_constraintSuperView:NSLayoutAttributeRight inset:0];
        [self.imageView make_constraintSuperView:NSLayoutAttributeWidth inset:self.image.size.width];
        [self.imageView make_constraintSuperView:NSLayoutAttributeHeight inset:self.image.size.height];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(44.0, bounds.size.width) - bounds.size.width;
    CGFloat heightDelta = MAX(44.0, bounds.size.height) - bounds.size.height;
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

#pragma mark - 点击事件
- (void)tapGesture:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.hanlder) {
            self.hanlder(self);
        }
    }
}

#pragma mark - getter
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
    }
    return _titleLabel;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

@end
