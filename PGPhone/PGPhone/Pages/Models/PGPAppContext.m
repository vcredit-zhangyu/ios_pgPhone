//
//  PGPAppContext.m
//  PGPhone
//
//  Created by openSource on 2024/6/12.
//

//#import "PGPAppContext.h"
#import "NSObject+NetAssisant.h"
#import "PGPAppDataMacros.h"


static NSString *const kUserDefault_userRole = @"userRole";


@implementation PGPAppContext

+ (instancetype)share{
    static PGPAppContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[self alloc] init];
    });
    return context;
}



@end
