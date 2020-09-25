//
//  MGDRecordTableView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/14.
//

#import "MGDRecordTableView.h"
#import <Masonry.h>

@implementation MGDRecordTableView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITableView *recordTableView = [[UITableView alloc] init];
        self.recordTableView = recordTableView;
        self.recordTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:recordTableView];
    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [_recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.height.mas_equalTo(screenHeigth - 394);
//       make.width.mas_equalTo(screenWidth);
//       make.top.mas_equalTo(self.mas_top);
//    }];
//}

@end
