//
//  MRTabBarController.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

#import <UIKit/UIKit.h>
@class MRTabBarView;
//@protocol MRTabBarControllerDelegate <NSObject>
//
//- (void)hideTabBarView:(MRTabBarView *)tabbar;
//
//@end

NS_ASSUME_NONNULL_BEGIN

@interface MRTabBarController : UITabBarController
@property (strong, nonatomic) MRTabBarView *tabView;
//@property (assign, nonatomic) id<MRTabBarControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
