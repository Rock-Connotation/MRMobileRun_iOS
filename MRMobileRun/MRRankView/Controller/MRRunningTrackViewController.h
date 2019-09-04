//
//  MRRunningTrackViewController.h
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/12.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRRunningTrackView.h"
@interface MRRunningTrackViewController : UIViewController


@property (nonatomic,strong) MRRunningTrackView *runningTrackView;


@property (nonatomic,strong) NSMutableArray *locationAry;
@end
