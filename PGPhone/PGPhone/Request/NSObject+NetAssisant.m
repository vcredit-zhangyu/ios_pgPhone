//
//  NSObject+NetAssisant.m
//  DDCash
//
//  Created by xxxx on 2018/6/25.
//  Copyright © 2018年 openSource. All rights reserved.
//

#import "NSObject+NetAssisant.h"


@implementation NSObject (NetAssisant)


- (void)getUrl:(NSString *)url header:(NSDictionary *)header parameters:(NSDictionary *)parameters success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure{
    [[PGPHTTPManager sharedManager] dataWithUrl:url math:@"GET" header:header parameters:parameters success:success failure:failure];
}

- (void)postUrl:(NSString *)url header:(NSDictionary *)header parameters:(id)parameters success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure{
    [[PGPHTTPManager sharedManager] dataWithUrl:url math:@"POST" header:header parameters:parameters success:success failure:failure];
}

@end
