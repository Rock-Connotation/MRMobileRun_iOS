//
//  ZYLLoginView.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/11/13.
//

#import <UIKit/UIKit.h>
#import "ZYLLoginField.h"
#import "ZYLLoginButton.h"
#import "ZYLWelcomeLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYLLoginView : UIView
@property (nonatomic, strong) ZYLWelcomeLabel *welcomeLab;
@property (nonatomic, strong) ZYLLoginField *usernameField;
@property (nonatomic, strong) ZYLLoginField *passwordField;
@property (nonatomic, strong) ZYLLoginButton *loginBtn;
@end

NS_ASSUME_NONNULL_END
