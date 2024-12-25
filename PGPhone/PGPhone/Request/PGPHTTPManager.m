//
//  LLZHTTPManager.m
//  DDCash
//
//  Created by xxxx on 2018/6/25.
//  Copyright © 2018年 openSource. All rights reserved.
//

#import "PGPHTTPManager.h"

@implementation PGPHTTPManager

+ (instancetype)sharedManager{
    static PGPHTTPManager *g_httpManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_httpManager = [[self alloc]init];
    });
    return g_httpManager;
}


- (NSURLSessionDataTask *)dataWithUrl:(NSString *)url
                                 parm:(NSDictionary *)parm
                              success:(HttpSuccessBlock)success
                              failure:(HttpFailureBlock)failure{
    return [self dataWithUrl:url parm:parm timeout:60 success:success failure:failure];
}

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
                              failure:(HttpFailureBlock)failure{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary *newParm = [parm mutableCopy];
    
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:url parameters:newParm error:nil];
    
    
    NSURLSessionDataTask *sessionTask = nil;
    __block NSTimeInterval lastTime = 0;
    sessionTask = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:error.userInfo ? : @{}];
                if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
                    userInfo[kResponeSatusCode] = [NSString stringWithFormat:@"%d",(int)((NSHTTPURLResponse *)response).statusCode];
                }
                userInfo[kRequestTimeout] = [NSString stringWithFormat:@"%@",([NSDate date].timeIntervalSince1970 - lastTime - request.timeoutInterval) > 0 ? @"true" : @"false"];
                error = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
                failure(sessionTask, error);
            }
        } else {
            if (success) {
                success(sessionTask,responseObject);
            }
        }
    }];
    [sessionTask resume];
    return sessionTask;
}


- (void)post_dataWithUrl:(NSString *)url header:(NSDictionary *)header parameters:(NSDictionary *)parameters success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure{
    [self dataWithUrl:url math:@"POST" header:header parameters:parameters success:success failure:failure];
}

- (void)dataWithUrl:(NSString *)url math:(NSString *)math header:(NSDictionary *)header parameters:(id)parameters success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    id newParm = [parameters mutableCopy];
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:math URLString:url parameters:newParm error:nil];
    request.timeoutInterval = 10;
    
    if (header) {
        for (NSString *key in header.allKeys) {
            [request setValue:header[key] forHTTPHeaderField:key];
        }
    }
    
    NSURLSessionDataTask *sessionTask = nil;
    sessionTask = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"#########################################\nurl = %@\nparm = %@\nresponse = %@\n error = %@\n#########################################", url,parameters , responseObject, error.description);
        if (error) {
            if (failure) {
                failure(sessionTask, error);
            }
        } else {
            if (success) {
                // "encryption" =1  返回加密的data数据
                success(sessionTask,responseObject);
            }
        }
    }];
    [sessionTask resume];
    
}

/**
 *  sessionManager的getter方法
 *
 *  @return 返回值weAFURLSessionManager
 */
- (AFURLSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"multipart/form-data",nil];
        _sessionManager.responseSerializer = responseSerializer;
        AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        //如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO
        //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        securityPolicy.validatesDomainName = NO;
        //validatesCertificateChain 是否验证整个证书链，默认为YES
        //设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
        //GeoTrust Global CA
        //    Google Internet Authority G2
        //        *.google.com
        //那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
        //如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证；
        _sessionManager.securityPolicy = securityPolicy;
        
    }
    return _sessionManager;
}


@end
