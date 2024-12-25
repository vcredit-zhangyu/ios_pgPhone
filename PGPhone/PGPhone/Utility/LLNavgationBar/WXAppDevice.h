//
//  WXAppDevice.h
//  openSource
//
//  Created by openSource on 2023/3/23.
//  Copyright © 2023 openSource. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXAppDevice : NSObject

+ (CGFloat)appStatusHeight;

+ (CGFloat)appNavgationHeight;

+ (UIEdgeInsets)appSafeAreaInsets;

+ (UIWindowScene *)currentScenes API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
