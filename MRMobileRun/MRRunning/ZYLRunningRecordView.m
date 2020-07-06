//
//  ZYLRunningRecordView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/2.
//

#import "ZYLRunningRecordView.h"
#import <Masonry.h>

@interface ZYLRunningRecordView ()
@property (nonatomic,strong)  UILabel *title;
@property (nonatomic,strong)  UIImageView *showLabelView;
@property (nonatomic,strong)  UIImageView *dividingLineView;
@property (nonatomic,strong)  UIImageView *iconImageView;
@property (nonatomic,strong)  UILabel *kmLabel;
@property (nonatomic,strong)  UILabel *timeLabel;
@end
@implementation ZYLRunningRecordView

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
        return self;
    }
    return self;
}

- (void)initUI{
    self.showLabelView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.showLabelView.image = [UIImage imageNamed:@"里程用时计数白色板底"];
    [self addSubview:self.showLabelView];
    [self.showLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(0 ,0 ,0 ,0));
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width);
    }];
    
    self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.iconImageView.image = [UIImage imageNamed:@"用时icon"];
    
    [self addSubview:self.iconImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo (self.showLabelView).with.insets(UIEdgeInsetsMake(61.0/1334.0*screenHeigth, 415.0/750*screenWidth,116.0/1334.0*screenHeigth, 226.0/750.0*screenWidth));
        make.top.equalTo(self.mas_top).mas_offset(25);
        make.left.equalTo(self.mas_left).mas_offset(200);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(14);
    }];
    
    self.dividingLineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.dividingLineView.image = [UIImage imageNamed:@"Group 5"];
    [self addSubview:self.dividingLineView];
    [self.dividingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo (self.showLabelView).with.insets(UIEdgeInsetsMake(54.0/1334.0*screenHeigth, 360.0/750*screenWidth, 55.0/1334.0*screenHeigth, 304.0/750.0*screenWidth));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).mas_offset(15);
        make.width.mas_equalTo(1);
        make.height.equalTo(self.mas_height).mas_offset(-40);
    }];
    
    self.kmLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.kmLabel.text = @"公里";
    self.kmLabel.font = [UIFont boldSystemFontOfSize: 12.0];
    self.kmLabel.textColor = [UIColor colorWithRed:148.0/255.0 green:147.0/255.0 blue:174.0/255.0 alpha:1];
    [self addSubview:self.kmLabel];
    [self.kmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).mas_offset(-10);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-25);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.timeLabel.text = @"用时";
    self.timeLabel.font = [UIFont boldSystemFontOfSize:12.0];
    self.timeLabel.textColor = [UIColor colorWithRed:143.0/255.0 green:142.0/255.0 blue:169.0/255.0 alpha:1];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo (self.showLabelView).with.insets(UIEdgeInsetsMake(55.0/1334.0*screenHeigth, 456.0/750*screenWidth, 113.0/1334.0*screenHeigth, 160.0/750.0*screenWidth));
        make.left.equalTo(self.iconImageView.mas_right).mas_offset(5);
        make.top.equalTo(self.iconImageView.mas_top).mas_offset(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    self.runningTimeLabel = [[MRRunningLabel alloc]init];
    self.runningTimeLabel.textColor = [UIColor blackColor];
    [self addSubview:self.runningTimeLabel];
    [self.runningTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self.showLabelView).with.insets(UIEdgeInsetsMake(75.0/1334.0*screenHeigth, 390.0/750*screenWidth, 45.0/1334.0*screenHeigth, 50.0/750.0*screenWidth));
    }];
    
    self.runningDiastanceLabel = [[MRNumLabel alloc]init];
    self.runningDiastanceLabel.text = @"0.000";
    self.runningDiastanceLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:49.0*screenWidth/414.0];
    [self addSubview:self.runningDiastanceLabel];
    [self.runningDiastanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self.showLabelView).with.insets(UIEdgeInsetsMake(38.0/1334.0*screenHeigth, 59.0/750*screenWidth, 33.0/1334.0*screenHeigth, 414.0/750.0*screenWidth));
    }];
    
}


@end
