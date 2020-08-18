//
//  ZYLPersonalBackGroud.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/4/12.
//

#import "ZYLPersonalBackGroud.h"
#import <Masonry.h>
@interface ZYLPersonalBackGroud()
@property (nonatomic,strong) UIImageView *dividingLine;
//两个文本框之间的分割线
@property (nonatomic,strong) UIImageView *dividingLineTwo;
//第二个个文本框之间的分割线
@property (nonatomic,strong) UIImageView *backgroundImageView;
//整个界面的底板背景
@property (nonatomic,strong) UIImageView *whiteBackground;
//第一个文本框下的白色底板
@property (nonatomic,strong) UIImageView *whiteBackgroundTwo;
//界面标题
@property (nonatomic,strong) MRChineseLabel *avatarLabel;
//头像文字标签
@property (nonatomic,strong) MRChineseLabel *nicknameLabel;
//昵称文字标签
@property (nonatomic,strong) MRChineseLabel *classLabel;
//班级文字标签
@property (nonatomic,strong) MRChineseLabel *stuNumLabel;
//学号文字标签
@property (nonatomic,strong) MRChineseLabel *stuNum;
//学号
@property (nonatomic,strong) MRChineseLabel *classID;
//班级号
@end

@implementation ZYLPersonalBackGroud
- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, screenWidth, screenHeigth);
        [self initBackground];
        return self;
    }
    return self;
    
}


- (void)initBackground{
    
    [self initBackgroundView];
    [self initLabel];
    
    [self bringSubviewToFront:self.dividingLine];
    //将分割线置于视图顶层防止
    
    
    
}

- (void)initBackgroundView{
    self.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:247.0/255.0 blue:249.0/255.0 alpha:1.0];
    
    
    self.dividingLine = [[UIImageView alloc] init];
    self.dividingLine.image = [UIImage imageNamed:@"分割线2"];
    [self addSubview:self.dividingLine];
    [self.dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(304.0/1334.0*screenHeigth, 1.0/750*screenWidth, 1029.0/1334.0*screenHeigth, 42.0/750.0*screenWidth));
    }];
    
    self.whiteBackground = [[UIImageView alloc] init];
    self.whiteBackground.image = [UIImage imageNamed:@"信息底板"];
    [self addSubview:self.whiteBackground];
    [self.whiteBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(128.0/1334.0*screenHeigth, 0.0/750*screenWidth, 906.0/1334.0*screenHeigth, 0.0/750.0*screenWidth));
    }];
    
    self.dividingLineTwo = [[UIImageView alloc] init];
    self.dividingLineTwo.image = [UIImage imageNamed:@"分割线2"];
    [self addSubview:self.dividingLineTwo];
    [self.dividingLineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(617.0/1334.0*screenHeigth, 0,  716.0/1334.0*screenHeigth ,44.0/750.0*screenWidth));
    }];
    
    self.whiteBackgroundTwo = [[UIImageView alloc] init];
    self.whiteBackgroundTwo.image = [UIImage imageNamed:@"信息底板"];
    [self addSubview:self.whiteBackgroundTwo];
    [self.whiteBackgroundTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(476.0/1334.0*screenHeigth, 0.0/750*screenWidth, 571.0/1334.0*screenHeigth, 0.0/750.0*screenWidth));
    }];
    [self sendSubviewToBack:self.whiteBackgroundTwo];
}

- (void)initLabel{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    self.titleLabel = [[MRChineseLabel alloc] init];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.titleLabel setFontWithSize:19.0*screenWidth/414.0 andTitle:@"个人信息"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(59.0/1334.0*screenHeigth, 304.0/750*screenWidth, 1225.0/1334.0*screenHeigth, 301.0/750.0*screenWidth));
    }];
    //个人信息文字标签
    
    self.avatarLabel = [[MRChineseLabel alloc] init];
    self.avatarLabel.textColor = [UIColor blackColor];
    [self.avatarLabel setFontWithSize:16.0*screenWidth/414.0 andTitle:@"头像"];
    [self.avatarLabel setTextColor:[UIColor colorWithRed:141.0/255.0 green:140.0/255.0 blue:168.0/255.0 alpha:1]];
    [self addSubview:self.avatarLabel];
    [self.avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(199.0/1334.0*screenHeigth, 40.0/750*screenWidth, 1093.0/1334.0*screenHeigth, 649.0/750.0*screenWidth));
    }];
    
    
    self.classLabel = [[MRChineseLabel alloc] init];
    self.classLabel.textColor = [UIColor blackColor];
    [self.classLabel setFontWithSize:16.0*screenWidth/414.0 andTitle:@"班级"];
    [self.classLabel setTextColor:[UIColor colorWithRed:160.0/255.0 green:159.0/255.0 blue:187.0/255.0 alpha:1]];
    
    [self addSubview:self.classLabel];
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(523.0/1334.0*screenHeigth, 40.0/750*screenWidth, 769.0/1334.0*screenHeigth, 649.0/750.0*screenWidth));
    }];
    
    self.stuNumLabel = [[MRChineseLabel alloc] init];
    self.stuNumLabel.textColor = [UIColor blackColor];
    [self.stuNumLabel setFontWithSize:16.0*screenWidth/414.0 andTitle:@"学号"];
    [self.stuNumLabel setTextColor:[UIColor colorWithRed:141.0/255.0 green:140.0/255.0 blue:168.0/255.0 alpha:1]];
    [self addSubview:self.stuNumLabel];
    [self.stuNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(664.0/1334.0*screenHeigth, 40.0/750*screenWidth, 628.0/1334.0*screenHeigth, 649.0/750.0*screenWidth));
    }];
    
    
    self.nicknameLabel = [[MRChineseLabel alloc] init];
    self.nicknameLabel.textColor = [UIColor blackColor];
    [self.nicknameLabel setFontWithSize:16.0*screenWidth/414.0 andTitle:@"昵称"];
    [self.nicknameLabel setTextColor:[UIColor colorWithRed:160.0/255.0 green:159.0/255.0 blue:187.0/255.0 alpha:1]];
    
    [self addSubview:self.nicknameLabel];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(354.0/1334.0*screenHeigth, 40.0/750*screenWidth, 940.0/1334.0*screenHeigth, 649.0/750.0*screenWidth));
    }];
    
    self.classID = [[MRChineseLabel alloc] init];
    self.classID.textColor = [UIColor blackColor];
    [self.classID setFontWithSize:16.0*screenWidth/414.0 andTitle:[user objectForKey:@"class_id"]];
    [self.classID setTextColor:[UIColor blackColor]];
    
    [self addSubview:self.classID];
    [self.classID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(526.0/1334.0*screenHeigth, 530.0/750.0*screenWidth, 766.0/1334.0*screenHeigth, 43.0/750.0*screenWidth));
    }];
    
    self.stuNum = [[MRChineseLabel alloc] init];
    self.stuNum.textColor = [UIColor blackColor];
    [self.stuNum setFontWithSize:15.0*screenWidth/414.0 andTitle:[user
                                                                  objectForKey:@"studentID"]];
    [self.stuNum setTextColor:[UIColor blackColor]];
    
    [self addSubview:self.stuNum];
    [self.stuNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo (self).with.insets(UIEdgeInsetsMake(667.0/1334.0*screenHeigth, 532.0/750*screenWidth, 624.0/1334.0*screenHeigth, 43.0/750.0*screenWidth));
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
