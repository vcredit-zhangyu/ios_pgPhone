//
//  PGPHTTPManager.h
//  DDCash
//
//  Created by xxxx on 2018/6/25.
//  Copyright © 2018年 openSource. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^HttpSuccessBlock)(NSURLSessionDataTask *task, id response);
typedef void(^HttpFailureBlock)(NSURLSessionDataTask *task, NSError *error);

static NSString *const kResponeSatusCode = @"responseStatusCode";
static NSString *const kRequestTimeout = @"requestTimeout";

@interface PGPHTTPManager : NSObject

@property (nonatomic, strong) AFURLSessionManager *sessionManager;


+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)dataWithUrl:(NSString *)url
                                 parm:(NSDictionary *)parm
                              success:(HttpSuccessBlock)success
                              failure:(HttpFailureBlock)failure;


/// 发起请求
/// @param url url
/// @param parm 参数书
/// @param timeout 接口超时时间  大于0有效 小于等0的时候为默认值
/// @param success s
/// @param failure f
- (NSURLSessionDataTask *)dataWithUrl:(NSString *)url
                                 parm:(NSDictionary *)parm
                              timeout:(NSTimeInterval)timeout
                              success:(HttpSuccessBlock)success
                              failure:(HttpFailureBlock)failure;



- (void)dataWithUrl:(NSString *)url math:(NSString *)math header:(NSDictionary *)header parameters:(NSDictionary *)parameters success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;


- (void)post_dataWithUrl:(NSString *)url header:(NSDictionary *)header parameters:(NSDictionary *)parameters success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;



@end
