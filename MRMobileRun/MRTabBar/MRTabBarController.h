//
//  MRTabBarController.h
//  MobileRun
//
//  Created by 郑沛越 on 2017/11/20.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRHomePageTabBar.h"
//#import "MRHomePageViewController.h"
//#import "MRPersonaInformationViewController.h"
//#import "MRRankViewController.h"
//#import "MRRunningViewController.h"

@interface MRTabBarController : UITabBarController
@property(nonatomic) MRHomePageTabBar *homePageTabBar;
@end
