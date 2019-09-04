




//
//  MRDataBaseView.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/12.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRDataBaseView.h"
#import "MAsonry.h"
#import "MRTimeReversalModel.h"
@implementation MRDataBaseView

- (instancetype)init{
    if (self = [super init]) {
        
        

        [self initUI];
        return self;
    }
    return self;
}

- (void)initUI{
    
    self.dataBaseImageView = [[UIImageView alloc]init];
    self.dataBaseImageView.image = [UIImage imageNamed:@"数据底板"];
    self.dataBaseImageView.frame = self.frame;
    [self addSubview:self.dataBaseImageView];
    [self.dataBaseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(0/1334.0*screenHeigth, 0/750.0*screenWidth, 0/1334.0*screenHeigth, 0/750.0*screenWidth));
        
    }];
    
    self.timeIconImageView = [[UIImageView alloc]init];
    self.timeIconImageView.image = [UIImage imageNamed:@"用时icon2"];
    self.timeIconImageView.frame = self.frame;
    [self addSubview:self.timeIconImageView];
    [self.timeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(154/1334.0*screenHeigth, 44.0/750.0*screenWidth, 116.0/1334.0*screenHeigth, 684.0/750.0*screenWidth));
        
    }];
    
    
    self.line = [[UIImageView alloc]init];
    self.line.image = [UIImage imageNamed:@"分割线4"];
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(110.0/1334.0*screenHeigth, 42.0/750.0*screenWidth, 182.0/1334.0*screenHeigth, 43.0/750.0*screenWidth));
        
    }];
    
    self.timeCostLabel = [[UILabel alloc]init];
    self.timeCostLabel.font = [UIFont boldSystemFontOfSize:22];
    self.timeCostLabel.text = @"用时";
    self.timeCostLabel.textColor = [UIColor colorWithRed:161.0/255.0 green:160.0/255.0 blue:185.0/255.0 alpha:1 ];
    self.timeCostLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:12 *screenWidth/414.0];
    [self addSubview:self.timeCostLabel];
    [self.timeCostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(148.0/1334.0*screenHeigth, 85.0/750.0*screenWidth, 113.0/1334.0*screenHeigth, 618.0/750.0*screenWidth));
        
    }];
    
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:32*screenWidth/414.0];
    self.timeLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:24.0/255.0 blue:103.0/255.0 alpha:1 ];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(197.0/1334.0*screenHeigth, 40.0/750.0*screenWidth, 27.0/1334.0*screenHeigth, 509.0/750.0*screenWidth));
        
    }];


    
    self.kmLabel = [[UILabel alloc]init];
    self.kmLabel.font = [UIFont boldSystemFontOfSize:14*screenWidth/414.0];
    self.kmLabel.text = @"KM";
    self.kmLabel.textColor = [UIColor colorWithRed:161.0/255.0 green:160.0/255.0 blue:185.0/255.0 alpha:1 ];
    [self addSubview:self.kmLabel];
    [self.kmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(226.0/1334.0*screenHeigth, 664.0/750.0*screenWidth, 28.0/1334.0*screenHeigth, 43.0/750.0*screenWidth));
    }];
    
    
    self.distanceLabel = [[UILabel alloc]init];
    self.distanceLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:68*screenWidth/414.0];
    self.distanceLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:24.0/255.0 blue:103.0/255.0 alpha:1 ];
    self.distanceLabel.text = @"78.0";
    [self addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(137.0/1334.0*screenHeigth, 442.0/750.0*screenWidth, 13.0/1334.0*screenHeigth, 100.0/750.0*screenWidth));
    }];
    self.distanceLabel.textAlignment = NSTextAlignmentRight;

    
    self.dateOne = [[UILabel alloc]init];
    self.dateOne.font = [UIFont boldSystemFontOfSize: 13*screenWidth/414.0];
    self.dateOne.text = @"2016/12/12";
    self.dateOne.textColor = [UIColor colorWithRed:161.0/255.0 green:160.0/255.0 blue:185.0/255.0 alpha:1 ];
    [self addSubview:self.dateOne];
    [self.dateOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(40.0/1334.0*screenHeigth, 41.0/750.0*screenWidth, 214.0/1334.0*screenHeigth, 564.0/750.0*screenWidth));
    }];
    
    self.dateTwo = [[UILabel alloc]init];
    self.dateTwo.font = [UIFont boldSystemFontOfSize: 13*screenWidth/414.0];
    self.dateTwo.text = @"16:03";
    self.dateTwo.textColor = [UIColor colorWithRed:161.0/255.0 green:160.0/255.0 blue:185.0/255.0 alpha:1 ];
    [self addSubview:self.dateTwo];
    [self.dateTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(39.0/1334.0*screenHeigth, 640.0/750.0*screenWidth, 215.0/1334.0*screenHeigth, 30.0/750.0*screenWidth));
    }];
}


@end
