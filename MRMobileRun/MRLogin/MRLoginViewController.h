//
//  MRLoginViewController.h
//  MobileRun
//
//  Created by 郑沛越 on 2016/11/30.
//  Copyright © 2016年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRLoginView.h"
@interface MRLoginViewController : UIViewController
//登陆后跳转的主界面
@property (nonatomic,strong) NSString *invitedID;
@property (nonatomic,strong) NSString *nickName;
+ (UIViewController *)findCurrentViewController;
- (void)setTheSpringWindow;
@end
