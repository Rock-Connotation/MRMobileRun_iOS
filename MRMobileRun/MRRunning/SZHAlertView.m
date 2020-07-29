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
                           make.left.equalTo(self.mas_left).offset(Width * 0.0588);
                           make.top.equalTo(self.mas_top).offset(Height * 0.68);
                           make.size.mas_equalTo(CGSizeMake(130, 44));
                       }];
                       
                       self.endBtn.titleLabel.hidden = NO;
                       [self.endBtn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.center.mas_equalTo(self.endBtn.center);
                           make.height.mas_equalTo(22);
                           make.width.mas_equalTo(self.endBtn.mas_width);
                       }];
                       self.endBtn.titleLabel.textColor = [UIColor whiteColor];
                       self.endBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC" size: 16];
                       self.endBtn.titleLabel.text = @"结束";
                       self.endBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                       
                       self.endBtn.backgroundColor = [UIColor colorWithRed:79/255.0 green:84/255.0 blue:93/255.0 alpha:1.0];
                       self.endBtn.layer.cornerRadius = 12;
                       
                   /*
                        继续跑步按钮
                                   */
                       self.ContinueRunBtn = [[UIButton alloc] init];
                       [self addSubview:self.ContinueRunBtn];
                       [self.ContinueRunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.left.equalTo(self.endBtn.mas_right).offset(Width *0.0293);
                           make.right.equalTo(self.mas_right).offset(Width *0.0566);
                           make.centerY.height.equalTo(self.endBtn);
                       }];
                       self.ContinueRunBtn.titleLabel.hidden = NO;
                       [self.ContinueRunBtn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.center.mas_equalTo(self.ContinueRunBtn.center);
                           make.height.mas_equalTo(22);
                           make.width.equalTo(self.ContinueRunBtn.mas_width);
                       }];
                       self.ContinueRunBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                       self.ContinueRunBtn.titleLabel.textColor = [UIColor whiteColor];
                       self.ContinueRunBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC" size: 16];
                       self.ContinueRunBtn.titleLabel.text = @"继续跑步";
                       
                       self.ContinueRunBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:197/255.0 blue:217/255.0 alpha:1.0];
                       self.ContinueRunBtn.layer.cornerRadius = 12;
                
        /*
                       中间的label文本
                                       */
                       self.messageLbl = [[UILabel alloc] init];
                       [self addSubview:self.messageLbl];
                       [self.messageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.centerX.equalTo(self);
                           make.width.mas_equalTo(Width *0.576);
                           make.top.equalTo(self.mas_top).offset(Height *0.235);
                           make.bottom.equalTo(self.endBtn.mas_top);
                       }];
                       self.messageLbl.textAlignment = NSTextAlignmentCenter;
                       self.messageLbl.textColor = [UIColor colorWithRed:51/255.0 green:55/255.0 blue:57/255.0 alpha:1.0];
                       self.messageLbl.font = [UIFont fontWithName:@"PingFangSC" size: 16];
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.messageLbl.text = title;
    }
    return  self;
}
@end
