//
//  SZHAlertView.m
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/29.
//
#import <Masonry.h>
#import "SZHAlertView.h"

#define Width self.bounds.size.width
#define Height self.bounds.size.height
@implementation SZHAlertView

- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        /**
        分享的那个小界面
        */
        UIView *AlertView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            AlertView.backgroundColor = SZHAlertColor;
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:AlertView];
        [AlertView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(screenWidth * 0.0906);
//            make.top.equalTo(self.mas_top).offset(screenHeigth * 0.335);
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(screenWidth * 0.816,screenHeigth * 0.2463));
        }];
        AlertView.layer.cornerRadius = 16;
        AlertView.layer.shadowRadius = 6;
/*
结束按钮
            */
        self.endBtn = [[UIButton alloc] init];
        [AlertView addSubview:_endBtn];
        [self.endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(AlertView.mas_left).offset(18);
            make.top.equalTo(AlertView.mas_top).offset(136);
            make.size.mas_equalTo(CGSizeMake(130, 44));
        }];
        if (@available(iOS 11.0, *)) {
            self.endBtn.backgroundColor = GrayColor;
        } else {
            // Fallback on earlier versions
        }
        self.endBtn.layer.cornerRadius = 12;
                       
                    //给endBtn添加label
        UILabel *endBtnTitleLel = [[UILabel alloc] init];
        if (@available(iOS 11.0, *)) {
            endBtnTitleLel.textColor = SZHAlertTextColor;
        } else {
            // Fallback on earlier versions
        }
        
        endBtnTitleLel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
        endBtnTitleLel.text = @"结束";
        endBtnTitleLel.textAlignment = NSTextAlignmentCenter;
        if (@available(iOS 11.0, *)) {
            endBtnTitleLel.textColor = SZHAlertEndBtnTexteColor;
        } else {
            // Fallback on earlier versions
        }
        [self.endBtn addSubview:endBtnTitleLel];
        [endBtnTitleLel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.endBtn.center);
            make.height.mas_equalTo(22);
            make.width.mas_equalTo(self.endBtn.mas_width);
        }];
        
                       
                   /*
                        继续跑步按钮
                                   */
        self.ContinueRunBtn = [[UIButton alloc] init];
        [AlertView addSubview:self.ContinueRunBtn];
        [self.ContinueRunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.endBtn.mas_right).offset(11);
            make.size.centerY.equalTo(self.endBtn);
        }];
        self.ContinueRunBtn.titleLabel.backgroundColor = [UIColor redColor];
        //给继续跑步按钮添加lable
        UILabel *continueBtnTitleLbl = [[UILabel alloc] init];
        continueBtnTitleLbl.textColor = [UIColor whiteColor];
        continueBtnTitleLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
        continueBtnTitleLbl.textAlignment = NSTextAlignmentCenter;
        continueBtnTitleLbl.text = @"继续跑步";
        [self.ContinueRunBtn addSubview:continueBtnTitleLbl];
        [continueBtnTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.ContinueRunBtn.center);
            make.height.mas_equalTo(22);
            make.width.equalTo(self.ContinueRunBtn.mas_width);
        }];
                       
        self.ContinueRunBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:197/255.0 blue:217/255.0 alpha:1.0];
        self.ContinueRunBtn.layer.cornerRadius = 12;
                
        /*
                       中间的label文本
                                       */
        self.messageLbl = [[UILabel alloc] init];
        [AlertView addSubview:self.messageLbl];
        [self.messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.mas_equalTo(216);
            make.top.equalTo(AlertView.mas_top).offset(47);
//            make.bottom.equalTo(self.endBtn.mas_top);
                       }];
        self.messageLbl.numberOfLines = 0;
        self.messageLbl.textAlignment = NSTextAlignmentCenter;
        if (@available(iOS 11.0, *)) {
            self.messageLbl.textColor = bottomTitleColor;
        } else {
            // Fallback on earlier versions
        }
        self.messageLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
        
        self.messageLbl.text = title;
       
        self.AlertView = AlertView;
        
        [self addUnabledViews];
    }
    return  self;
}

//添加四周的蒙板
- (void)addUnabledViews{
    //顶部蒙板
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.AlertView.mas_top);
    }];
    topView.alpha = 0.05;
    topView.userInteractionEnabled = NO;
    
    //左边蒙板
    UIView *leftView = [[UIView alloc] init];
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.AlertView.mas_left);
        make.top.bottom.equalTo(self.AlertView);
    }];
    leftView.alpha = 0.05;
    leftView.userInteractionEnabled = NO;
    
    //右边的蒙板
    UIView *rightView = [[UIView alloc] init];
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.AlertView);
        make.right.equalTo(self);
        make.left.equalTo(self.AlertView.mas_right);
    }];
    rightView.alpha = 0.05;
    rightView.userInteractionEnabled = NO;
    
    
    //下面的蒙板
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.AlertView.mas_bottom);
    }];
    
    topView.backgroundColor = [UIColor blackColor];
    leftView.backgroundColor = [UIColor blackColor];
    rightView.backgroundColor = [UIColor blackColor];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.05;
    bottomView.userInteractionEnabled = NO;
}
@end
