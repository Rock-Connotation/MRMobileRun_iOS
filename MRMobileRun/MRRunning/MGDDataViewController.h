//
//  MGDDataViewController.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/27.
//

#import <UIKit/UIKit.h>
#import "MGDOverView.h"
#import "MGDDataView.h"
#import "MGDButtonsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGDDataViewController : UIViewController

@property (nonatomic ,strong) UIScrollView *backScrollView;

@property (nonatomic ,strong) MGDOverView *overView;

@property (nonatomic ,strong) MGDDataView *dataView;

@property (nonatomic ,strong) MGDButtonsView *twoBtnView;

@end

NS_ASSUME_NONNULL_END
