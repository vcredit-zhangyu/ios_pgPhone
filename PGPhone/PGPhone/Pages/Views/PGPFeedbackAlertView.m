//
//  PGPFeedbackAlertView.m
//  PGPhone
//
//  Created by xxxx on 2024/9/24.
//

#import "PGPFeedbackAlertView.h"
#import "VLToast.h"
#import "NSObject+NetAssisant.h"
#import "PGPAppDataMacros.h"
#import "keyChain.h"

@implementation PGPFeedbackAlertView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.textView.delegate = self;
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 8, 10, 8);
}

- (void)textViewDidChange:(UITextView *)textView{
    if (!textView.markedTextRange) {
        self.numberLabel.text = [NSString stringWithFormat:@"%ld / 100", textView.text.length];
    }
}


- (IBAction)actionForCancel:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)actionForSubmit:(id)sender {
    NSString *feedback = self.textView.text;
    if (feedback.length == 0) {
        [VLToast showWithText:@"说点什么吧!"];
        return;
    }
    
    NSString *deviceId = [keyChain load:@"pgphone_deviceId"];
    
    [self postUrl:[NSString stringWithFormat:@"%@%@", kNet_host, kNet_feedbackCommit] header:nil parameters:@{@"deviceNo" : deviceId, @"content": feedback} success:^(NSURLSessionDataTask *task, id response) {
        [self removeFromSuperview];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



@end
