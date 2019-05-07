//
//  MRPauseAndResumeBtu.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/2/9.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRPauseAndResumeBtu.h"

@interface MRPauseAndResumeBtu ()

@property (nonatomic,strong) UIImageView *pauseAndResumeImageView;

@end

@implementation MRPauseAndResumeBtu

//这个是暂停和继续按钮
- (instancetype)init{
    if (self =[super init]) {
        [self initpauseAndResumeBtu];
        return self;
    }
    return self;

}

- (void)initpauseAndResumeBtu{
    self.frame = CGRectMake(0, 0, 183, 183);
    [self setTitle:@"暂停" forState:UIControlStateNormal];

    [self setBackgroundImage:[UIImage imageNamed:@"暂停按钮"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0*screenWidth/414.0];
    
    self.contentEdgeInsets = UIEdgeInsetsMake(screenHeigth *59.0 /1334,screenWidth *59.0/750, screenHeigth *95.0 /1334, screenWidth *47.0/750);


}

- (void)pause{
    if ([self.titleLabel.text isEqualToString:@"暂停"]) {
        
    [self setBackgroundImage:[UIImage imageNamed:@"继续按钮"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
    [self setTitle:@"继续" forState:UIControlStateNormal];
    }
}

- (void)resume{
    
    if ([self.titleLabel.text isEqualToString:@"继续"]) {

    [self setBackgroundImage:[UIImage imageNamed:@"暂停按钮"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self setTitle:@"暂停" forState:UIControlStateNormal];
    }
}
@end
