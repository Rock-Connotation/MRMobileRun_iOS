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
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"km"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"min"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cal"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SportList"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SportMoreList"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CellData"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
