//
//  AppDelegate.m
//  PGPhone
//
//  Created by openSource on 2024/3/21.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "CustomNavigationController.h"
#import <IQKeyboardManager.h>
#import "PGPAppContext.h"
#import "PGPVersionViewController.h"


@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    
    
    self.window.rootViewController = [[CustomNavigationController alloc] initWithRootViewController:[[PGPVersionViewController alloc] init]];
    
    IQKeyboardManager.sharedManager.keyboardDistanceFromTextField = 150;
    
    return YES;
}


- (void)setMainRootViewController{
    self.window.rootViewController = [[CustomNavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];

}


- (void)changeMainRootViewController{
    [(CustomNavigationController *)self.window.rootViewController setViewControllers:@[[[MainViewController alloc] init]] animated:YES];
}



@end
