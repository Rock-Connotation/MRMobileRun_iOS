//
//  ZYLRunningTabView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/2.
//

#import "ZYLRunningTabView.h"
#import <Masonry.h>

@interface ZYLRunningTabView ()

@property (nonatomic,strong) UIImageView *navImageView;
//导航栏底部图片
@property (nonatomic,strong) UIImageView *bottomImageView;
//视图底部图片
@end

@implementation ZYLRunningTabView
- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, screenWidth, 160);
        [self initUI];
        
        return self;
    }
    return self;
}

- (void)initUI{
    [self initpauseAndResumeBtu];
    [self initstopBtu];
    [self initBackGruondView];
}


- (void)initpauseAndResumeBtu{
    //初始化暂停继续按钮
    self.pauseAndResumeBtu = [[MRPauseAndResumeBtu alloc]init];
//    self.pauseAndResumeBtu.contentEdgeInsets = UIEdgeInsetsMake(screenHeigth *48.0 /1334,screenWidth *56.0/750, screenHeigth *64.0 /1334, screenWidth *52.0/750);
    [self addSubview:self.pauseAndResumeBtu];
    [self.pauseAndResumeBtu setTitle:@"暂停" forState:UIControlStateNormal];
    if (kIs_iPhoneX) {
        [self.pauseAndResumeBtu mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(1074.0/1334.0*screenHeigth, 121.0/750*screenWidth, 50.0/1334.0*screenHeigth, 422.0/750.0*screenWidth));
            make.left.equalTo(self.mas_left).mas_offset(50);
            make.centerY.equalTo(self.mas_centerY).mas_offset(0);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(120);
        }];
    }else{
        [self.pauseAndResumeBtu mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(1074.0/1334.0*screenHeigth, 121.0/750*screenWidth, 50.0/1334.0*screenHeigth, 422.0/750.0*screenWidth));
            make.left.equalTo(self.mas_left).mas_offset(50);
            make.centerY.equalTo(self.mas_centerY).mas_offset(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(100);
        }];
    }
}

- (void)initstopBtu{
    //初始化结束按钮
    
    self.stopBtu = [[MRStopBtu alloc]init];
    [self addSubview:self.stopBtu];
//    self.stopBtu.contentEdgeInsets = UIEdgeInsetsMake(screenHeigth *48.0 /1334,screenWidth *60.0/750, screenHeigth *64.0 /1334, screenWidth *56.0/750);
    if (kIs_iPhoneX) {
        [self.stopBtu mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(1074.0/1334.0*screenHeigth, 121.0/750*screenWidth, 50.0/1334.0*screenHeigth, 422.0/750.0*screenWidth));
            make.right.equalTo(self.mas_right).mas_offset(-50);
            make.centerY.equalTo(self.mas_centerY).mas_offset(0);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(120);
        }];
    }else{
        [self.stopBtu mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(1074.0/1334.0*screenHeigth, 121.0/750*screenWidth, 50.0/1334.0*screenHeigth, 422.0/750.0*screenWidth));
            make.right.equalTo(self.mas_right).mas_offset(-50);
            make.centerY.equalTo(self.mas_centerY).mas_offset(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(100);
        }];
    }
    
}




- (void)initBackGruondView{
    self.bottomImageView = [[UIImageView alloc]init];
    self.bottomImageView.image = [UIImage imageNamed:@"按钮底"];
    [self addSubview:self.bottomImageView];
    [self sendSubviewToBack:self.bottomImageView];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(997.0/1334.0*screenHeigth, 0 , 0, 0));
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.navImageView = [[UIImageView alloc]init];
    self.navImageView.image = [UIImage imageNamed:@"开始跑步nav+状态栏底"];
    [self addSubview:self.navImageView];
    [self sendSubviewToBack:self.navImageView];
    [self.navImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(0, 0 , 1206.0/1334.0*screenHeigth, 0));
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
}



@end
