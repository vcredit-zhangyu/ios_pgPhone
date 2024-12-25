//
//  PGPFeedbackAlertView.h
//  PGPhone
//
//  Created by xxxx on 2024/9/24.
//

#import <UIKit/UIKit.h>
#import "QMUITextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGPFeedbackAlertView : UIView<QMUITextViewDelegate>

@property (weak, nonatomic) IBOutlet QMUITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@end

NS_ASSUME_NONNULL_END
