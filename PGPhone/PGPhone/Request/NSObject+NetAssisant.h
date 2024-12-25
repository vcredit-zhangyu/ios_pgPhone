//
//  NSObject+NetAssisant.h
//  DDCash
//
//  Created by xxxx on 2018/6/25.
//  Copyright © 2018年 openSource. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGPHTTPManager.h"

@interface NSObject (NetAssisant)



- (void)getUrl:(NSString *)url header:(NSDictionary *)header parameters:(NSDictionary *)parameters success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

- (void)postUrl:(NSString *)url header:(NSDictionary *)header parameters:(id)parameters success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;



@end
