//
//  MRTabBar.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/8.
//

#import "MRTabBar.h"
#import <Masonry.h>

@interface MRTabBar ()
@property (strong, nonatomic) NSMutableArray *btnArr;
@property (strong, nonatomic) NSMutableArray<NSString *> *textArr;
@end
@implementation MRTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.textArr = [NSMutableArray array];
        self.btnArr = [NSMutableArray array];
        [self initTabView];
    }
    return self;
}

- (void)initTabView{
    self.tabView = [[MRTabBarView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, kTabBarHeight)];
    [self addSubview: self.tabView];
    [self bringSubviewToFront:self.tabView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(kTabBarHeight);
    }];
    [self addAllChildViewController];
    [self.tabView setArray: self.btnArr];
    [self.tabView setTextArray: self.textArr];
}


- (void)addAllChildViewController{
    [self addChildViewControllertitle:@"首页" imageNamed:@"首页icon（未选中）" selectedImageNamed:@"首页icon（未许选中）" tag:0];
    [self addChildViewControllertitle:@"排行" imageNamed:@"排行榜icon （未选中）" selectedImageNamed:@"排行榜icon（选中）" tag:1];
    [self addChildViewControllertitle:@"跑步" imageNamed:@"开始跑步icon（未按）" selectedImageNamed:@"开始跑步icon（按） 2" tag:2];
    [self addChildViewControllertitle:@"邀约" imageNamed:@"邀约icon（未选中）" selectedImageNamed:@"邀约icon（选中）" tag:4];
    [self addChildViewControllertitle:@"我的" imageNamed:@"我的icon(未选中）" selectedImageNamed:@"我的icon（选中）" tag:5];
}

- (void)addChildViewControllertitle:(NSString *)title imageNamed:(NSString *)imageNamed selectedImageNamed:(NSString *)selectedImageName tag:(NSInteger)i
{
    [self.textArr addObject:title];
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed: imageNamed] forState: UIControlStateNormal];
    [btn setImage:[UIImage imageNamed: selectedImageName] forState: UIControlStateDisabled];
    [self.btnArr addObject: btn];
}

@end
