//
//  MainViewController.m
//  PGPhone
//
//  Created by xxxx on 2024/3/21.
//

#import "MainViewController.h"
#import "YYKit.h"
#import "NSObject+NetAssisant.h"
#import "PGPHeaderBackTableView.h"
#import "keyChain.h"
#import "VLToast.h"
#import "UIView+Design.h"
#import "PGPAppDataMacros.h"
#import "PGPDeviceItem.h"
#import "MJExtension.h"
#import "PGPFeedbackAlertView.h"

static NSString *const kDeviceIdKey = @"pgphone_deviceId";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet PGPHeaderBackTableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;


@property (strong, nonatomic) IBOutlet UIView *alertView;

@property (strong, nonatomic) IBOutlet UIView *expireAlertView;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *alertContentView;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;


@property (weak, nonatomic) IBOutlet UILabel *modelLabel;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *deviceIdLabel;

@property (weak, nonatomic) IBOutlet UILabel *systemNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *systemVersionLabel;

@property (weak, nonatomic) IBOutlet UILabel *pxLabel;


@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *personLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;

@property (strong, nonatomic) PGPDeviceItem *item;

@property (assign, nonatomic) BOOL  canBeRequest;

@property (copy, nonatomic) NSString *appVersion;

@end
// machineModel iPhone14,4 对应映射表 https://api.ipsw.me/v4/devices
@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navgationBar.hidden = YES;
    
    self.appVersion = UIDevice.currentDevice.systemVersion;

    self.systemVersionLabel.text = self.appVersion;
    
    self.appVersionLabel.text = [NSString stringWithFormat:@"%@_%@", [UIApplication sharedApplication].appVersion, [UIApplication sharedApplication].appBuildVersion];
    
    [self queryMachineNameWithId:UIDevice.currentDevice.machineModel];
    
    self.tableView.backgroundImageView.image = [UIImage imageNamed:@"home_bg"];
    
    self.tableView.backgroundImageView.frame = CGRectMake(0, -[WXAppDevice appStatusHeight], [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 328.0 / 375.0);
    
    CGFloat height = [UIScreen mainScreen].bounds.size.width * 190 / 375.0;
    self.tableView.pullImageView.image = [UIImage imageNamed:@"icon_pull_bg"];
    self.tableView.pullImageView.frame = CGRectMake(0, -[WXAppDevice appStatusHeight] - height, [UIScreen mainScreen].bounds.size.width, height);
    
    NSString *deviceId = [keyChain load:kDeviceIdKey];
//    deviceId = @"";
    if (deviceId && deviceId.length > 0) {
        self.deviceIdLabel.text = deviceId;
        self.canBeRequest = YES;
        [self queryMachineInfo];
        [self submitRecord];
    }else{
        [self showAlertView];
    }
    
    [self scrollViewDidScroll:self.tableView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryMachineInfo) name:UIApplicationDidBecomeActiveNotification object:nil];
    });
}

- (void)queryMachineNameWithId:(NSString *)ID {
    [self getUrl:@"https://api.ipsw.me/v4/devices" header:nil parameters:nil success:^(NSURLSessionDataTask *task, id response) {
        NSArray *list = response;
        for (NSDictionary *item in list) {
            if ([item[@"identifier"] isEqualToString:ID]) {
                NSLog(@"%@", item[@"name"]);
                
                self.modelLabel.text = item[@"name"];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}

- (void)queryMachineInfo{
    if (!self.canBeRequest) {
        return;
    }
    [PGPAppContext share].deviceId = [keyChain load:kDeviceIdKey];

    [self getUrl:[NSString stringWithFormat:@"%@%@", kNet_host, kNet_queryDeviceInfo] header:nil parameters:@{@"deviceNo": [PGPAppContext share].deviceId} success:^(NSURLSessionDataTask *task, id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [response[@"code"] integerValue];
            if (code == 0) {
                self.item = [PGPDeviceItem mj_objectWithKeyValues:response[@"data"]];
                if (self.item.expireDate && self.item.expireDate.length > 0) {
                    NSDate *expireDate = [NSDate dateWithString:[NSString stringWithFormat:@"%@ 23:59:59", self.item.expireDate] format:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *currentDate = [NSDate date];
                    [self setExpireAlertViewHidden:(currentDate.timeIntervalSince1970 - expireDate.timeIntervalSince1970 < 0)];
                }else{
                    [self setExpireAlertViewHidden:YES];
                }
                
                if (self.item
                    && self.item.id
                    && ![self.item.deviceSystemVersion isEqualToString:self.appVersion]) {
                    [self updateAppVersion: self.item.id];
                }
                
            }else if (code == 99) {
                [self showDeviceIdErrorAlert];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        if (self.item == nil) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self queryMachineInfo];
            });
        }
    }];
}

- (void)updateAppVersion:(NSString *)versionId{
//    NSString *deviceId = [keyChain load:@"pgphone_deviceId"];
    [self postUrl:[NSString stringWithFormat:@"%@%@", kNet_host, kNet_versionCommit] header:nil parameters:@{@"deviceId" : versionId, @"deviceSystemVersion": self.appVersion} success:^(NSURLSessionDataTask *task, id response) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}


- (void)submitRecord {
    [self postUrl:[NSString stringWithFormat:@"%@%@", kNet_host, kNet_activeRecord] header:nil parameters:@{@"deviceNo": [PGPAppContext share].deviceId, @"activeDateTime": [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]} success:^(NSURLSessionDataTask *task, id response) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//MARK: - alert

- (void)showDeviceIdErrorAlert {
    self.canBeRequest = NO;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未查询到设备，请确认输入的序列号。" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"重新查询" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.canBeRequest = YES;
        [self queryMachineInfo];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.textField.text = [keyChain load:kDeviceIdKey];
        [self showAlertView];
        
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertView {
    if (self.textField.delegate) {
        [self.view addSubview:self.alertView];
    }else{
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.delegate = self;
        self.alertView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        [self.view addSubview:self.alertView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.alertContentView addRoundedCornersWithRadius:16 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight  size:self.alertContentView.frame.size];
        });
    }
}

- (void)setExpireAlertViewHidden:(BOOL)hidden{
    if (hidden) {
        [self.expireAlertView removeFromSuperview];
    }else{
        [self.view addSubview:self.expireAlertView];
        self.expireAlertView.frame = self.view.bounds;
    }
}


//MARK: - action
- (IBAction)actionForClick:(UIButton *)sender {
    NSString *deviceId = self.textField.text;
    deviceId = [deviceId stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (deviceId > 0) {
//        self.deviceIdLabel.text = deviceId;
        self.canBeRequest = YES;
        [keyChain save:kDeviceIdKey data:deviceId];
        [self.alertView removeFromSuperview];
        [self queryMachineInfo];
        [self submitRecord];
    }else{
        [VLToast showWithText:@"请输入序列号!"];
    }
}


- (IBAction)actionForSuggestion:(UIButton *)sender {
    PGPFeedbackAlertView *alertView = [[NSBundle mainBundle] loadNibNamed:@"PGPFeedbackAlertView" owner:nil options:nil].lastObject;
    alertView.frame = self.view.bounds;
    [self.view addSubview:alertView];
}

//MARK: - setter
- (void)setItem:(PGPDeviceItem *)item{
    _item = item;
    self.modelLabel.text = item.deviceModel;
    self.nameLabel.text = item.deviceName;
    self.systemNameLabel.text = item.deviceSystem;
//    self.systemVersionLabel.text = item.deviceSystemVersion;
    self.pxLabel.text = item.deviceResolution;
    self.stateLabel.text = item.deviceStatus;
    self.personLabel.text = item.deviceCharge;
    self.dateLabel.text = item.expireDate;
    self.deviceIdLabel.text = item.deviceNo;
}

//MARK: - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cells[indexPath.row];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < -self.tableView.pullImageView.frame.size.height) {
        scrollView.contentOffset = CGPointMake(0, -self.tableView.pullImageView.frame.size.height);
        return;
    }
    if (scrollView.contentOffset.y > 80) {
        self.statusImageView.alpha = 1;
    }else{
        self.statusImageView.alpha = scrollView.contentOffset.y / 80.0;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
       // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48) return NO; // 48 unichar for 0
        if (character > 57 && character < 65) return NO; //
        if (character > 90 && character < 97) return NO;
        if (character > 122) return NO;

    }
    return YES;
}


@end
