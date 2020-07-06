//
//  ZYLButtonNoticeView.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLButtonNoticeView : UIView
@property (nonatomic, strong) UILabel *noticeLab;
- (instancetype)initWithText:(NSString *)text;
+ (instancetype)viewInitWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
