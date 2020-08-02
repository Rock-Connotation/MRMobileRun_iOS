//
//  MGDSportTableView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/10.
//

#import "MGDSportTableView.h"
#import <Masonry.h>

@implementation MGDSportTableView



-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITableView *sportTableView = [[UITableView alloc] init];
        self.sportTableView = sportTableView;
        [self addSubview:sportTableView];
        self.sportTableView.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_sportTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.height.mas_equalTo(screenHeigth - 379);
       make.width.mas_equalTo(screenWidth);
       make.top.mas_equalTo(self.mas_top);
    }];
}




@end
   
