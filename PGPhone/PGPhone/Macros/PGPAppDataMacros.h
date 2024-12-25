//
//  PGPAppDataMacros.h
//  PGPhone
//
//  Created by openSource on 2024/4/25.
//

#ifndef PGPAppDataMacros_h
#define PGPAppDataMacros_h

#import "PGPAppContext.h"
#import "NSObject+NetAssisant.h"
#import "NSDate+WX.h"

#if EnvironmentDev
static NSString *const kNet_host = @"http://xxxxxx";
#else
static NSString *const kNet_host = @"http://xxxxxx";
#endif

/// 查询设备信息
static NSString *const kNet_queryDeviceInfo = @"/vzy/device/info/query";

/// 提交设备使用记录
static NSString *const kNet_commitAppRecord = @"/vzy/device/app/commit";

/// 查询当前版本信息
static NSString *const kNet_queryVersion = @"/vzy/app/version/query";

/// 提交信息
static NSString *const kNet_versionCommit = @"/vzy/device/info/update";

/// 提交日活
static NSString *const kNet_activeRecord = @"/vzy/device/active/record";

/// 提交反馈
static NSString *const kNet_feedbackCommit = @"/vzy/device/feedback/commit";

#endif /* PGPAppDataMacros_h */
