//
//  MGDButtonsView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/27.
//

#import "MGDButtonsView.h"
#import <Masonry.h>

@implementation MGDButtonsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
        _backView.userInteractionEnabled = YES;
        [self addSubview:_backView];
        
        _overBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _overBtn.layer.cornerRadius = 12;
        //测试颜色
        [_overBtn setBackgroundColor:[UIColor colorWithRed:100/255.0 green:104/255.0 blue:111/255.0 alpha:1.0]];
        [_overBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.backView addSubview:_overBtn];
        
        _shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _shareBtn.layer.cornerRadius = 12;
        //测试颜色
        [_shareBtn setBackgroundColor:[UIColor colorWithRed:85/255.0 green:213/255.0 blue:226/255.0 alpha:1.0]];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.backView addSubview:_shareBtn];
        
        
        if (@available(iOS 11.0, *)) {
            [self.overBtn setTitleColor:OverColor forState:UIControlStateNormal];
            [self.overBtn setBackgroundColor:OverBackColor];
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}

- (void)layoutSubviews {
    if (kIs_iPhoneX) {
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.equalTo(@100);
        }];
    }else {
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.equalTo(@66);
        }];
    }
    
    [_overBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_top).mas_offset(10);
        make.left.mas_equalTo(self.backView.mas_left).mas_offset(18);
        make.width.equalTo(@164);
        make.height.equalTo(@44);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.overBtn);
        make.right.mas_equalTo(self.mas_right).mas_offset(-18);
        make.width.mas_equalTo(self.overBtn);
        make.height.mas_equalTo(self.overBtn);
    }];
}



@end
