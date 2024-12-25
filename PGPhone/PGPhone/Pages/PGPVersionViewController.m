//
//  PGPVersionViewController.m
//  PGPhone
//
//  Created by openSource on 2024/6/19.
//

#import "PGPVersionViewController.h"
#import "PGPAppDataMacros.h"
#import "AppDelegate.h"
#import "PGPVersionItem.h"
#import "YYKit.h"
#import "MJExtension.h"

@interface PGPVersionViewController ()


@property (strong, nonatomic) IBOutlet UIView *alertView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) PGPVersionItem *item;

@end

@implementation PGPVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self queryVersion];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)queryVersion{
    [self getUrl:[NSString stringWithFormat:@"%@%@", kNet_host, kNet_queryVersion] header:nil parameters:@{@"appPlatform":@"ios"} success:^(NSURLSessionDataTask *task, id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [response[@"code"] integerValue];
            if (code == 0) {
                self.item = [PGPVersionItem mj_objectWithKeyValues:response[@"data"]];
                NSInteger currentVersion = [self.item.appVersion integerValue];
                NSInteger buildVersion = [[UIApplication sharedApplication].appBuildVersion integerValue];
                if (currentVersion > buildVersion) {
                    [self showVersionAlertView];
                    return;
                }
            }
        }
        [self setMainRootViewController];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([AFNetworkReachabilityManager sharedManager].isReachable) {
            [self setMainRootViewController];
        }else{
            [self checkNet];
        }
    }];
}

- (IBAction)actionForClick:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.item.downloadUrl] options:@{} completionHandler:^(BOOL success) {

    }];
}



- (void)showVersionAlertView {
    
    self.contentLabel.text = self.item.versionRemark;
    
    self.alertView.frame = self.view.bounds;
    [self.view addSubview:self.alertView];
    
    
//    item.download_url = @"https://www.baidu.com";
//    item.versionRemark = [NSString stringWithFormat:@"卧槽 %d", [NSThread isMainThread]];

//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本" message:item.versionRemark preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alert addAction:[UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.download_url] options:@{} completionHandler:^(BOOL success) {
//            exit(0);
//        }];
//    }]];
//    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setMainRootViewController{
    [(AppDelegate *)[UIApplication sharedApplication].delegate setMainRootViewController];
}

//开始网络监听
-(void)checkNet{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if ([AFNetworkReachabilityManager sharedManager].isReachable) {
            [self queryVersion];
        }
    }];
}


@end
