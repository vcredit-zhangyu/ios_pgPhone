//
//  CustomViewController.m
//  CustomNavigationBarDemo
//
//  Created by jimple on 14-1-6.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomNavigationController.h"
#import "HexColors.h"

@interface CustomViewController ()


@end

@implementation CustomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)dealloc{
    
}

#pragma mark - 生命周期


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self addNavgationView];
}

- (void)addNavgationView{
    self.navgationBar = [LLNavgationBarView addBarTo:self.view];
    
    [self setBackView];
    
    self.navgationBar.barFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    
    self.navgationBar.backgroundColor = UIColor.clearColor;
    self.navgationBar.shadowView.hidden = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.navigationController.viewControllers.count > 1) {
            self.isNeedBackView = YES;
        }else{
            self.isNeedBackView = NO;
        }
    });
}

- (void)setBackView {
    //左上角返回按钮
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 48, 44)];
        
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[[UIImage imageNamed:@"icon_arrow_left"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    backButton.tintColor = [UIColor colorWithHexString:@"#333333"];
    backButton.frame = CGRectMake(0, 0, 48, 44);
    [backButton setTitleColor:backButton.tintColor forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 2)];
    [backButton addTarget:self action:@selector(back_event:) forControlEvents:UIControlEventTouchUpInside];
    self.leftbackBtn = backButton;
    [self.backView addSubview:backButton];

    self.navgationBar.backBarButtonItem = [LLBarButtonItem barButtonItemWithCustomView:self.backView handler:nil];
}

- (void)setLeftBtnColor:(UIColor *)leftBtnColor{
    _leftBtnColor = leftBtnColor;
    if(self.leftbackBtn){
        self.leftbackBtn.tintColor = leftBtnColor;
    }
}



-(void)back_event:(UIButton *)sender
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setIsNeedBackView:(BOOL)isNeedBackView{
    _isNeedBackView = isNeedBackView;
    self.backView.hidden = !isNeedBackView;
}



- (BOOL)isInteractivePopGesture{
    return YES;
}

@end
