//
//  CustomNavigationController.m
//  CustomNavigationBarDemo
//
//  Created by jimple on 14-1-6.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import "CustomNavigationController.h"
#import "CustomViewController.h"

@interface CustomNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@end

@implementation CustomNavigationController


//- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
//    self = [super initWithRootViewController:rootViewController];
//    if (self) {
//        self.navigationBar.barTintColor = [UIColor whiteColor];
//        self.navigationBarHidden = YES;
//    }
//    return self;
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.wantsFullScreenLayout = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
    [self setNavigationBarHidden:NO];       // 使导航条有效
    [self.navigationBar setHidden:YES];     // 隐藏导航条，但由于导航条有效，系统的返回按钮页有效，所以可以使用系统的右滑返回手势。
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        if (self.viewControllers.count <= 1) {
            self.interactivePopGestureRecognizer.enabled = NO;
            return;
        }
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CustomViewController *lastVC = self.viewControllers.lastObject;
    if ([lastVC respondsToSelector:@selector(isInteractivePopGesture)]) {
        return [lastVC isInteractivePopGesture];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//// 是否可右滑返回
//- (void)navigationCanDragBack:(BOOL)bCanDragBack
//{
//    if (IsiOS7Later)
//    {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }else
//    {
//        
//    }
//}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}
@end
