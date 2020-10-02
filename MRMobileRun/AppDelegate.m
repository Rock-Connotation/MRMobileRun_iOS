//
//  AppDelegate.m
//  MRMobileRun
//
//  Created by liangxiao on 2019/3/5.
//

#import "AppDelegate.h"
#import "MRTabBarController.h"
#import "ZYLMainViewController.h"
#import "ZYLLoginViewController.h"
#import "MRLoginModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MGDTabBarViewController.h"
#define BUGLY_APPID @"354f05b571"
#define BUGLY_APPKEY @"c423889d-fa34-4de8-aa6c-8e29305d03b6"

//高德地图的key
#define MAMAP_KEY @"030a8e0b2b3c762f76c33bf8eeb6ce11"
#define NewKey @"c99a9b7d1464962d9a11a2726f83f670"
#define YCKey @"f88d0c41a8c63e93cadd7d78901ab5c0"
#define YCTestKey @"eec603f5701c69575d743998d449d1b0" //杨诚的测试用的key
@interface AppDelegate ()
@property (nonatomic, strong) MGDTabBarViewController *tabBarVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   // [AMapServices sharedServices].apiKey = MAMAP_KEY; //将高德地图的key配置在代码中
    [AMapServices sharedServices].apiKey = YCTestKey; //杨诚的测试用的key
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = COLOR_WITH_HEX(0xFAFAFA);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    ZYLLoginViewController *loginVC = [[ZYLLoginViewController alloc] init];
//    ZYLMainViewController *mainVC = [[ZYLMainViewController alloc] init];
    MGDTabBarViewController *tabVC = [[MGDTabBarViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController: tabVC];
    self.window.rootViewController = nav;
    if ([user valueForKey:@"password"]) {
        self.window.rootViewController = nav;
        MRLoginModel *model = [[MRLoginModel alloc] init];
        [model postRequestWithStudentID:[user valueForKey:@"studentID"] andPassword:[user valueForKey:@"password"]];
        [self.window makeKeyAndVisible];
    }
    else{
        self.window.rootViewController = loginVC;
        [self.window makeKeyAndVisible];
    }
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"程序进入前台状态,处于活跃状态");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

@end
