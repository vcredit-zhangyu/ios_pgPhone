//
//  PGPDeviceItem.h
//  PGPhone
//
//  Created by openSource on 2024/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGPDeviceItem : NSObject


@property (copy, nonatomic) NSString *deviceCharge;
@property (copy, nonatomic) NSString *deviceModel;
@property (copy, nonatomic) NSString *deviceName;
@property (copy, nonatomic) NSString *deviceNo;
@property (copy, nonatomic) NSString *deviceResolution;
@property (copy, nonatomic) NSString *deviceStatus;
@property (copy, nonatomic) NSString *deviceSystem;
@property (copy, nonatomic) NSString *deviceSystemVersion;
@property (copy, nonatomic) NSString *deviceType;
@property (copy, nonatomic) NSString *expireDate;
@property (copy, nonatomic) NSString *id;

@end

NS_ASSUME_NONNULL_END
