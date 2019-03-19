//
//  MRHomePageTabBar.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/11/19.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRHomePageTabBar.h"
#import "Masonry.h"
@implementation MRHomePageTabBar
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        NSLog(@"\n\n\n%s\n\n\n","asd");
        self.homePageJumpBtu = [[UIButton alloc]init];
        [self.homePageJumpBtu setImage:[UIImage imageNamed:@"首页icon（未许选中）"] forState:UIControlStateSelected];
        [self.homePageJumpBtu setImage:[UIImage imageNamed:@"首页icon（未选中）"] forState:UIControlStateNormal];
        [self addSubview:self.homePageJumpBtu];
        [self.homePageJumpBtu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(26.0/1334.0*screenHeigth, 60.0/750.0*screenWidth, 57.0/1334.0*screenHeigth, 649.0/750.0*screenWidth));
        }];
        self.homePageJumpTitle = [[UILabel alloc] init];
        self.homePageJumpTitle.textColor = [UIColor colorWithRed:69.0/255.0 green:41.0/255.0 blue:115.0/255.0 alpha:1];
        [self.homePageJumpTitle setFont:[UIFont systemFontOfSize:11.5]];
        self.homePageJumpTitle.text = @"首页";
        
        [self addSubview:self.homePageJumpTitle];
        [self.homePageJumpTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(75.0/1334.0*screenHeigth, 57.0/750.0*screenWidth, 23.0/1334.0*screenHeigth,636.0/750.0*screenWidth));
        }];
        
        self.rankJumpBtu = [[UIButton alloc]init];
        [self.rankJumpBtu setImage:[UIImage imageNamed:@"排行榜icon （未选中）"] forState:UIControlStateNormal ];
        [self addSubview:self.rankJumpBtu];
        [self.rankJumpBtu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(30.5/1334.0*screenHeigth, 186.0/750.0*screenWidth, 59.2/1334.0*screenHeigth, 528.0/750.0*screenWidth));
        }];
        self.rankJumpTitle = [[UILabel alloc] init];
        self.rankJumpTitle.textColor = [UIColor colorWithRed:175.0/255.0 green:157.0/255.0 blue:206.0/255.0 alpha:1];
        [self.rankJumpTitle setFont:[UIFont systemFontOfSize:11.5]];
        self.rankJumpTitle.text = @"排行";

        [self addSubview:self.rankJumpTitle];
        [self.rankJumpTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(75.0/1334.0*screenHeigth, 182.0/750.0*screenWidth, 25.0/1334.0*screenHeigth,519.0/750.0*screenWidth));
        }];

        
        self.inviteJumpBtu = [[UIButton alloc]init];
        [self.inviteJumpBtu setImage:[UIImage imageNamed:@"邀约icon（未选中）"] forState:UIControlStateNormal ];
        [self addSubview:self.inviteJumpBtu];
        [self.inviteJumpBtu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(29.5/1334.0*screenHeigth, 538.3/750.0*screenWidth, 60.7/1334.0*screenHeigth, 176.20/750.0*screenWidth));
        }];
        self.inviteJumpTitle = [[UILabel alloc] init];
        self.inviteJumpTitle.textColor = [UIColor colorWithRed:175.0/255.0 green:157.0/255.0 blue:206.0/255.0 alpha:1];
        [self.inviteJumpTitle setFont:[UIFont systemFontOfSize:11.5]];
        self.inviteJumpTitle.text = @"邀约";
        [self addSubview:self.inviteJumpTitle];
        [self.inviteJumpTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(75.0/1334.0*screenHeigth, 532.0/750.0*screenWidth, 25.0/1334.0*screenHeigth,169.0/750.0*screenWidth));
        }];

        
        self.personalJumpBtu = [[UIButton alloc]init];
        [self.personalJumpBtu setImage:[UIImage imageNamed:@"我的icon(未选中）"] forState:UIControlStateNormal ];
        [self addSubview:self.personalJumpBtu];
        [self.personalJumpBtu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(27.0/1334.0*screenHeigth, 650.1/750.0*screenWidth, 61.5/1334.0*screenHeigth, 74.3/750.0*screenWidth));
        }];
        self.personalJumpTitle = [[UILabel alloc] init];
        self.personalJumpTitle.textColor = [UIColor colorWithRed:175.0/255.0 green:157.0/255.0 blue:206.0/255.0 alpha:1];
        [self.personalJumpTitle setFont:[UIFont systemFontOfSize:11.5]];
        self.personalJumpTitle.text = @"我的";
        [self addSubview:self.personalJumpTitle];
        [self.personalJumpTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(75.0/1334.0*screenHeigth, 643.0/750.0*screenWidth, 25.0/1334.0*screenHeigth,58.0/750.0*screenWidth));
        }];
        [self initbeginRuningBtu];

        self.homePageJumpBtu.selected = YES;
        self.rankJumpBtu.selected = NO;
        self.beginRunningBtu.selected = NO;
        self.inviteJumpBtu.selected = NO;
        self.personalJumpBtu.selected = NO;

    }
    
    [self addEvens];
    return self;
}

- (void)initbeginRuningBtu{
    

    self.beginRunningBtu = [[MRStartRunningBtu alloc]init];
    [self addSubview:self.beginRunningBtu.beginRunningBtuImageView];
    [self addSubview:self.beginRunningBtu.beginRunningBtu];
    
    [self.beginRunningBtu.beginRunningBtuImageView
     mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(-40.0/1334.0*screenHeigth, 305.0/750.0*screenWidth, 10.0/1334.0*screenHeigth, 293.0/750.0*screenWidth));
     }];
    
    [self.beginRunningBtu.beginRunningBtu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(-40.0/1334.0*screenHeigth, 305.0/750*screenWidth, 10.0/1334.0*screenHeigth, 293.0/750.0*screenWidth));
    }];
    
    //设置开始跑步按钮
}

- (void)addEvens{
    [self.rankJumpBtu addTarget:self action:@selector(clicktabBarRankBtuDown) forControlEvents:UIControlEventTouchDown];
    
    [self.personalJumpBtu addTarget:self action:@selector(clicktabBarPersonalBtuDown) forControlEvents:UIControlEventTouchDown];
    

    [self.inviteJumpBtu addTarget:self action:@selector(clicktabBarInviteBtuDown) forControlEvents:UIControlEventTouchDown];
    //
    [self.rankJumpBtu addTarget:self action:@selector(clicktabBarRankBtuOutside) forControlEvents:UIControlEventTouchDragOutside];
    
    [self.personalJumpBtu addTarget:self action:@selector(clicktabBarPersonalBtuOutside) forControlEvents:UIControlEventTouchDragOutside];
    
    [self.beginRunningBtu.beginRunningBtu addTarget:self action:@selector(clicktabBarRunningBtuDown) forControlEvents:UIControlEventTouchDown];
    
    [self.beginRunningBtu.beginRunningBtu addTarget:self action:@selector(clicktabBarRunningBtuOutside) forControlEvents:UIControlEventTouchDragOutside];
    
    [self.inviteJumpBtu addTarget:self action:@selector(clicktabBarInviteBtuOutside) forControlEvents:UIControlEventTouchDragOutside];
}

- (void)clicktabBarInviteBtuDown{
    self.inviteJumpBtu.selected = YES;
    self.inviteJumpTitle.textColor = [UIColor colorWithRed:0 green:0 blue:31.0/255.0 alpha:1];
    self.homePageJumpBtu.selected = NO;
    self.homePageJumpTitle.textColor = [UIColor colorWithRed:175.0/255.0 green:157.0/255.0 blue:206.0/255.0 alpha:1];
    
    NSLog(@"\n\n\n%@\n\n\n",@"sd");
}

- (void)clicktabBarRankBtuDown{
    self.rankJumpBtu.selected = YES;
    self.rankJumpTitle.textColor = [UIColor colorWithRed:0 green:0 blue:31.0/255.0 alpha:1];
    self.homePageJumpBtu.selected = NO;
    self.homePageJumpTitle.textColor = [UIColor colorWithRed:175.0/255.0 green:157.0/255.0 blue:206.0/255.0 alpha:1];
    NSLog(@"\n\n\n%@\n\n\n",@"sd");
    
}

- (void)clicktabBarRunningBtuDown{
    self.homePageJumpBtu.selected = NO;
    self.homePageJumpTitle.textColor = [UIColor colorWithRed:175.0/255.0 green:157.0/255.0 blue:206.0/255.0 alpha:1];
    
    self.beginRunningBtu.beginRunningBtuImageView.image =[UIImage imageNamed:@"开始跑步icon（按） 2"];
    
    
}

- (void)clicktabBarPersonalBtuDown{
    self.personalJumpBtu.selected = YES;
    self.personalJumpTitle.textColor = [UIColor colorWithRed:0 green:0 blue:31.0/255.0 alpha:1];
    self.homePageJumpBtu.selected = NO;
    self.homePageJumpTitle.textColor = [UIColor colorWithRed:175.0/255.0 green:157.0/255.0 blue:206.0/255.0 alpha:1];
    NSLog(@"\n\n\n%@\n\n\n",@"sd");
}


//
- (void)clicktabBarInviteBtuOutside{
    self.homePageJumpBtu.selected = YES;
    self.homePageJumpTitle.textColor = [UIColor colorWithRed:0 green:0 blue:31.0/255.0 alpha:1];
    self.inviteJumpBtu.selected = NO;
    self.inviteJumpTitle.textColor = [UIColor colorWithRed:69.0/255.0 green:41.0/255.0 blue:115.0/255.0 alpha:1];
    NSLog(@"\n\n\n%@\n\n\n",@"sd");
}

- (void)clicktabBarRankBtuOutside{
    self.rankJumpBtu.selected = NO;
    self.homePageJumpTitle.textColor = [UIColor colorWithRed:0 green:0 blue:31.0/255.0 alpha:1];
    self.homePageJumpBtu.selected = YES;
    self.rankJumpTitle.textColor = [UIColor colorWithRed:69.0/255.0 green:41.0/255.0 blue:115.0/255.0 alpha:1];
    NSLog(@"\n\n\n%@\n\n\n",@"sd");
}

- (void)clicktabBarRunningBtuOutside{
    self.homePageJumpBtu.selected = YES;
    self.homePageJumpTitle.textColor = [UIColor colorWithRed:0 green:0 blue:31.0/255.0 alpha:1];
    
    self.beginRunningBtu.beginRunningBtuImageView.image =[UIImage imageNamed:@"开始跑步icon（未按）"];
    
}

- (void)clicktabBarPersonalBtuOutside{
    self.personalJumpBtu.selected = NO;
    self.homePageJumpTitle.textColor = [UIColor colorWithRed:0 green:0 blue:31.0/255.0 alpha:1];
    self.homePageJumpBtu.selected = YES;
    self.personalJumpTitle.textColor = [UIColor colorWithRed:69.0/255.0 green:41.0/255.0 blue:115.0/255.0 alpha:1];
    NSLog(@"\n\n\n%@\n\n\n",@"sd");;
}

@end
