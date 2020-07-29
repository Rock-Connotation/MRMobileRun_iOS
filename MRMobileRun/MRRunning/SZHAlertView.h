//
//  SZHAlertView.h
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZHAlertView : UIView
@property (nonatomic, strong) UILabel *messageLbl; //信息框
@property (nonatomic, strong) UIButton *endBtn; //结束按钮
@property (nonatomic, strong) UIButton *ContinueRunBtn; //继续跑步按钮

- (instancetype)initWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
