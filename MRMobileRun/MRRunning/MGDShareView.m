//
//  MGDShareView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/28.
//

#import "MGDShareView.h"
#import <Masonry.h>

@interface MGDShareView()

@property (nonatomic, strong)NSArray *shareBtns;

@end

@implementation MGDShareView

- (instancetype)initWithShotImage:(NSString *)shotImage logoImage:(NSString *)logo QRcodeImage:(NSString *)QRcode {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        //整体的透明的背景
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backView];
        
        //底部的按钮的View
        _bottomView = [[UIView alloc] init];
        [self.backView addSubview:_bottomView];
        
        //创建五个按钮，后面约束一下内部的位置
        CGFloat gap = (screenWidth - 52 - 250) / 4;
        for (int i = 1;i <= 5; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            CGFloat x = 26 + (gap + 50) * (i-1);
            [self.bottomView addSubview:btn];
            if (kIs_iPhoneX) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.popView.mas_bottom).mas_offset(24);
                    make.left.mas_equalTo(self.mas_left).mas_offset(x);
                    make.bottom.mas_equalTo(self.cancelBtn.mas_top).mas_offset(-18);
                    make.width.equalTo(@50);
                }];
            }else {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.popView.mas_bottom).mas_offset(69);
                    make.left.mas_equalTo(self.mas_left).mas_offset(x);
                    make.bottom.mas_equalTo(self.cancelBtn.mas_top).mas_offset(-15);
                    make.width.equalTo(@50);
                }];
            }
            
        }
        
        //弹出的View
        _popView = [[UIView alloc] init];
        _popView.layer.shadowOpacity = 1;
        _popView.layer.shadowRadius = 6;
        _popView.layer.shadowOffset = CGSizeMake(0, 2);
        [self showView];
        [self.backView addSubview:_popView];
        
        //截图
        _shotImage = [[UIImageView alloc] init];
        _shotImage.backgroundColor = [UIColor blueColor];
        [self.popView addSubview:_shotImage];
        
        //两个小的UIImageview
        _logoImage = [[UIImageView alloc] init];
        _logoImage.backgroundColor = [UIColor lightGrayColor];
        _logoImage.layer.cornerRadius = 6;
        [self.popView addSubview:_logoImage];
        
        _QRImage = [[UIImageView alloc] init];
        _QRImage.backgroundColor = [UIColor lightGrayColor];
        _QRImage.layer.cornerRadius = 6;
        [self.popView addSubview:_QRImage];
        
        _shareLab = [[UILabel alloc] init];
        _shareLab.textAlignment = NSTextAlignmentLeft;
        _shareLab.numberOfLines = 0;
        _shareLab.text = @"长按识别二维码\n加入约跑和我一起跑步";
        [self.popView addSubview:_shareLab];
        
        //取消按钮
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        [self.backView addSubview:_cancelBtn];
        
        if (@available(iOS 11.0, *)) {
            self.bottomView.backgroundColor = bottomColor;
            self.shareLab.tintColor = MGDTextColor2;
            [self.cancelBtn setBackgroundColor:MGDColor1];
            self.popView.backgroundColor = bottomColor;
        } else {
                   // Fallback on earlier versions
        }
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    if (kIs_iPhoneX) {
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(67);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(screenHeigth - 67);
        }];
        
        [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top).mas_offset(67);
            make.left.mas_equalTo(self.mas_left).mas_offset(15);
            make.right.mas_equalTo(self.mas_right).mas_offset(-15);
            make.height.mas_equalTo(566);
        }];
        
        [_shotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.popView.mas_top);
            make.left.mas_equalTo(self.popView.mas_left);
            make.right.mas_equalTo(self.popView.mas_right);
            make.height.equalTo(@489);
        }];
        
        [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shotImage.mas_bottom).mas_offset(11);
            make.left.mas_equalTo(self.popView.mas_left).mas_offset(12);
            make.height.equalTo(@54);
            make.width.equalTo(@54);
        }];
        
        [_QRImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shotImage.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(self.popView.mas_right).mas_offset(-15);
            make.width.equalTo(@54);
            make.height.equalTo(@54);
        }];
        
        [_shareLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shotImage.mas_bottom).mas_offset(23);
            make.left.mas_equalTo(self.logoImage.mas_right).mas_offset(15);
            make.width.equalTo(@125);
            make.height.equalTo(@34);
        }];
        _shareLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.cancelBtn.mas_top);
            make.left.mas_equalTo(self.backView.mas_left);
            make.right.mas_equalTo(self.backView.mas_right);
            make.height.equalTo(@129);
        }];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.equalTo(@80);
        }];
        
    }else {
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(40);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(screenHeigth - 40);
        }];
        
        [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top);
            make.left.mas_equalTo(self.mas_left).mas_offset(41);
            make.right.mas_equalTo(self.mas_right).mas_offset(-42);
            make.height.mas_equalTo(480);
        }];
        
        [_shotImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backView.mas_top);
            make.left.mas_equalTo(self.popView.mas_left);
            make.right.mas_equalTo(self.popView.mas_right);
            make.height.equalTo(@415);
        }];
        
        [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shotImage.mas_bottom).mas_offset(9);
            make.left.mas_equalTo(self.backView.mas_left).mas_offset(51);
            make.height.equalTo(@46);
            make.width.equalTo(@46);
        }];
        
        [_QRImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shotImage.mas_bottom).mas_offset(8);
            make.right.mas_equalTo(self.backView.mas_right).mas_offset(-54);
            make.width.equalTo(@46);
            make.height.equalTo(@46);
        }];
        
        [_shareLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.shotImage.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(self.logoImage.mas_right).mas_offset(12);
            make.width.equalTo(@135);
            make.height.equalTo(@28);
        }];
        _shareLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 10];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.cancelBtn.mas_top);
            make.left.mas_equalTo(self.backView.mas_left);
            make.right.mas_equalTo(self.backView.mas_right);
            make.height.equalTo(@162);
        }];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.equalTo(@46);
        }];
    }
}

-(void)showView{

    [[UIApplication sharedApplication].keyWindow addSubview:self];

    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);

    self.popView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.popView.alpha = 0;
    [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.popView.transform = transform;
        self.popView.alpha = 1;
    } completion:^(BOOL finished) {

    }];
    
}

@end
