//
//  ZYLBackBtn.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/6.
//

#import "ZYLBackBtn.h"
#import <Masonry.h>

@interface ZYLBackBtn ()
@property (strong, nonatomic) UIImageView *img;
@end


@implementation ZYLBackBtn

- (instancetype)init{
    if (self =[super init]) {
        [self initStopBtu];
        return self;
    }
    return self;
    
}

- (void)initStopBtu{
    self.frame = CGRectMake(0, 0, 15, 15);
    self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 10, 20)];
    self.img.image = [UIImage imageNamed:@"返回箭头4"];
    [self addSubview: self.img];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(5);
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(10);
    }];
}
@end
