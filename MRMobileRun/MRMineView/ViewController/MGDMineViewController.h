//
//  MGDMineViewController.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/10.
//

#import <UIKit/UIKit.h>
#import "MGDTopView.h"
#import "MGDBaseInfoView.h"
#import "MGDMiddleView.h"
#import "MGDSportTableView.h"
#import "MGDSportTableViewCell.h"
#import "MRTabBarView.h"


NS_ASSUME_NONNULL_BEGIN

@interface MGDMineViewController : UIViewController

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) MGDTopView *topview;

@property (nonatomic, strong) MGDBaseInfoView *baseView;

@property (nonatomic, strong) MGDMiddleView *middleView;

@property (nonatomic, strong) MGDSportTableView *sportTableView;

@property (nonatomic, strong) MRTabBarView *tabView;


@end

NS_ASSUME_NONNULL_END
