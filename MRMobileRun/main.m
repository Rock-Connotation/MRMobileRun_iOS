//
//  main.m
//  MRMobileRun
//
//  Created by liangxiao on 2019/3/5.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MoreIsFirst"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MineIsFirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
