//
//  WXAppDevice.m
//  openSource
//
//  Created by openSource on 2023/3/23.
//  Copyright © 2023 openSource. All rights reserved.
//

#import "WXAppDevice.h"

@implementation WXAppDevice

+ (CGFloat)appStatusHeight{
    CGFloat top = [WXAppDevice appSafeAreaInsets].top;
    return  top > 0 ? top : 20;
}

+ (UIEdgeInsets)appSafeAreaInsets{
    if (@available(iOS 11.0, *)){
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets;
    }
    return UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0);
}

+ (CGFloat)appNavgationHeight{
    return [WXAppDevice appStatusHeight] + 44;
}

+ (UIWindowScene *)currentScenes API_AVAILABLE(ios(13.0)){
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive){
            return scene;
        }
    }
    return nil;
}


@end
