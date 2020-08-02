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
                /*
                            结束按钮
                                       */
                       self.endBtn = [[UIButton alloc] init];
                       [self addSubview:_endBtn];
                       [self.endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.left.equalTo(self.mas_left).offset(18);
                           make.top.equalTo(self.mas_top).offset(136);
                           make.size.mas_equalTo(CGSizeMake(130, 44));
                       }];
                       
                    //给endBtn添加label
        UILabel *endBtnTitleLel = [[UILabel alloc] init];
        endBtnTitleLel.textColor = [UIColor whiteColor];
        endBtnTitleLel.font = [UIFont fontWithName:@"PingFangSC" size: 16];
        endBtnTitleLel.text = @"结束";
        endBtnTitleLel.textAlignment = NSTextAlignmentCenter;
        [self.endBtn addSubview:endBtnTitleLel];
        [endBtnTitleLel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.endBtn.center);
            make.height.mas_equalTo(22);
            make.width.mas_equalTo(self.endBtn.mas_width);
        }];
        
                       self.endBtn.backgroundColor = [UIColor colorWithRed:79/255.0 green:84/255.0 blue:93/255.0 alpha:1.0];
                       self.endBtn.layer.cornerRadius = 12;
                       
                   /*
                        继续跑步按钮
                                   */
                       self.ContinueRunBtn = [[UIButton alloc] init];
                       [self addSubview:self.ContinueRunBtn];
                       [self.ContinueRunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.left.equalTo(self.endBtn.mas_right).offset(11);
                           make.size.centerY.equalTo(self.endBtn);
                       }];
        self.ContinueRunBtn.titleLabel.backgroundColor = [UIColor redColor];
        //给继续跑步按钮添加lable
        UILabel *continueBtnTitleLbl = [[UILabel alloc] init];
        continueBtnTitleLbl.textColor = [UIColor whiteColor];
        continueBtnTitleLbl.font = [UIFont fontWithName:@"PingFangSC" size: 16];
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
                       [self addSubview:self.messageLbl];
                       [self.messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.centerX.equalTo(self);
                           make.width.mas_equalTo(216);
                           make.top.equalTo(self.mas_top).offset(47);
                           make.bottom.equalTo(self.endBtn.mas_top);
                       }];
                       self.messageLbl.numberOfLines = 0;
                       self.messageLbl.textAlignment = NSTextAlignmentCenter;
                       self.messageLbl.textColor = [UIColor colorWithRed:51/255.0 green:55/255.0 blue:57/255.0 alpha:1.0];
                       self.messageLbl.font = [UIFont fontWithName:@"PingFangSC" size: 16];
        
        
//        if (@available(iOS 11.0, *)) {
//            self.backgroundColor = WhiteColor;
//        } else {
//            // Fallback on earlier versions
//        }
        self.backgroundColor = [UIColor whiteColor];
        self.messageLbl.text = title;
        self.layer.cornerRadius = 16;
    }
    return  self;
}
@end
