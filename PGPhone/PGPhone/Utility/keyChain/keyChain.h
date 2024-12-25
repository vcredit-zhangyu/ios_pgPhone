//
//  keyChain.h
//  SvUDID
//
//  Created by luo on 16/2/2.
//  Copyright © 2016年 maple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
@interface keyChain : NSObject


// 保存数据到keychain
+ (void)save:(NSString *)service data:(id)data;

// 从 keychain 取出以保存的数据
+ (id)load:(NSString *)service;

// 删除 keychain中保存的数据
+ (void)delete:(NSString *)service;


@end
