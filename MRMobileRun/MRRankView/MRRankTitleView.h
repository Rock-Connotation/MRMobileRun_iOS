//
//  MRRankTitleView.h
//  AnotherDemo
//
//  Created by RainyTunes on 2017/2/24.
//  Copyright © 2017年 We.Can. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRRankTitleView : UIView
@property UIImageView *arrowImageView;
@property UIButton *firstTabButton;
@property UIButton *secondTabButton;
@property (nonatomic,strong) UIButton *backButton;
@property UILabel *firstTabLabel;
@property UILabel *secondTabLabel;
+ (instancetype)titleView;

@end
