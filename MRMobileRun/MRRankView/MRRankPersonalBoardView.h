//
//  MRRankClassBoardView.h
//  AnotherDemo
//
//  Created by RainyTunes on 2017/2/24.
//  Copyright © 2017年 We.Can. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRRankPersonalBoardView : UIView
@property UIImageView *avatarImageView;
@property UILabel *nameLabel;
@property UILabel *rankLabel;
@property UILabel *distanceLabel;
@property UILabel *gapDistanceLabel;

+ (instancetype)boardView;
@end
