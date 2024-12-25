//
//  PGPVersionItem.h
//  PGPhone
//
//  Created by openSource on 2024/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGPVersionItem : NSObject

@property (copy, nonatomic) NSString *appVersion;
@property (copy, nonatomic) NSString *appVersionCode;
@property (copy, nonatomic) NSString *versionRemark;
@property (copy, nonatomic) NSString *downloadUrl;

@end

NS_ASSUME_NONNULL_END
