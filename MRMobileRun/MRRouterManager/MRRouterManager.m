//
//  MRRouterManager.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/5.
//

#import "MRRouterManager.h"
#import <MGJRouter.h>
#import "ZYLMainViewController.h"
#import "ZYLPersonalViewController.h"
#import "ZYLRunningViewController.h"
#import "XIGRankViewViewController.h"
#import "LJJInviteRunVC.h"
#import "MRLoginViewController.h"

@implementation MRRouterManager
+ (void)load {
    
    [MGJRouter registerURLPattern:kMainVCPageURL toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        ZYLMainViewController *vc = [[ZYLMainViewController alloc] init];
        [navigationVC pushViewController:vc animated:YES];
    }];
    
    
    [MGJRouter registerURLPattern:kLoginVCPageURL toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        MRLoginViewController *vc = [[MRLoginViewController alloc] init];
        [navigationVC pushViewController:vc animated:YES];
    }];
    
    [MGJRouter registerURLPattern:kRankVCPageURL toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
//        void(^block)(NSString *) = routerParameters[MGJRouterParameterUserInfo][@"block"];
        XIGRankViewViewController *vc = [[XIGRankViewViewController alloc] init];
//        vc.clicked = block;
        [navigationVC pushViewController:vc animated:YES];
    }];
    
    
    [MGJRouter registerURLPattern:kRunningVCPageURL toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        //        void(^block)(NSString *) = routerParameters[MGJRouterParameterUserInfo][@"block"];
        ZYLRunningViewController *vc = [[ZYLRunningViewController alloc] init];
        //        vc.clicked = block;
        [navigationVC pushViewController:vc animated:YES];
    }];
    
    [MGJRouter registerURLPattern:kPersonnalVCPageURL toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        ZYLPersonalViewController *vc = [[ZYLPersonalViewController alloc] init];
        [navigationVC pushViewController:vc animated:YES];
    }];
    
    [MGJRouter registerURLPattern:kInviteVCPageURL toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        //        void(^block)(NSString *) = routerParameters[MGJRouterParameterUserInfo][@"block"];
        LJJInviteRunVC *vc = [[LJJInviteRunVC alloc] init];
        //        vc.clicked = block;
        [navigationVC pushViewController:vc animated:YES];
    }];
}
@end
