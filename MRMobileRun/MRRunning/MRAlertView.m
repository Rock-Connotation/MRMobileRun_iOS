//
//  MRAlertView.m
//  MRAlertView
//
//  Created by RainyTunes on 2017/2/19.
//  Copyright © 2017年 We.Can. All rights reserved.
//

#import "MRAlertView.h"
#import "Masonry.h"
#import "WeKit.h"

typedef void(^MRAlertBlock)();

static const NSInteger alertColor = 0xef6253;
static const NSInteger normalColor = 0x7A5595;
static const NSInteger textColor = 0xB4ABC5;

@interface MRAlertView()
@property UIImageView *alertWindowImageView;
@property UIImageView *remindImageView;
@property UIImageView *horizonalLine;
@property UIImageView *verticalLine;
@property UILabel *alertTextLabel;
@property UILabel *alertTitleLabel;

@property NSString *remindText;
@property NSInteger remindTextLines;
@property CGFloat rateX;
@property CGFloat rateY;


//用于判断点击弹窗外区域是否隐藏

@property MRAlertBlock block;

@end
@implementation MRAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.rateX = ScreenWidth / 375;
        self.rateY = ScreenHeight / 667;
        [self initEffectView];
        [self initAlertView];
    }
    return self;
}

- (instancetype)init {
    self = [self initWithFrame:ScreenFrame];
    return self;
}


/**
 弹框的初始化

 @param title 字符串，弹框提示语
 @param block 代码块，点击确认后的回调
 @return 弹框View自身
 */
+ (instancetype)alertViewWithTitle:(NSString *)title action:(void(^)())block {
    MRAlertView *alertView = [[MRAlertView alloc] init];
    alertView.remindText = title;
    alertView.block = block;
    return alertView;
}

- (void)updateConstraints {
    
    /**
     alertWindows
     */
    
    UIEdgeInsets insets1 =  UIEdgeInsetsMake(self.rateY * 209.5, self.rateX * 36, self.rateY * 253.5, self.rateX * 33);
    [self.alertWindowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(insets1.top); //with is an optional semantic filler
        make.left.equalTo(self.mas_left).with.offset(insets1.left);
        make.bottom.equalTo(self.mas_bottom).with.offset(-insets1.bottom);
        make.right.equalTo(self.mas_right).with.offset(-insets1.right);
    }];
    
    /**
     remindIcon
     */
    
    UIEdgeInsets insets2 =  UIEdgeInsetsMake(self.rateY * 34.5, self.rateX * 121, self.rateY * 143.5, self.rateX * 159);
    [self.remindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertWindowImageView.mas_top).with.offset(insets2.top); //with is an optional semantic filler
        make.left.equalTo(self.alertWindowImageView.mas_left).with.offset(insets2.left);
        make.bottom.equalTo(self.alertWindowImageView.mas_bottom).with.offset(-insets2.bottom);
        make.right.equalTo(self.alertWindowImageView.mas_right).with.offset(-insets2.right);
    }];
    
    /**
     alertTitleLabel
     */
    
    UIEdgeInsets insets3 =  UIEdgeInsetsMake(self.rateY * 35, self.rateX * 154.5, self.rateY * 144, self.rateX * 115);
//    self.alertTitleLabel.backgroundColor = [UIColor redColor];
    [self.alertTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertWindowImageView.mas_top).with.offset(insets3.top); //with is an optional semantic filler
        make.left.equalTo(self.alertWindowImageView.mas_left).with.offset(insets3.left);
        make.width.equalTo(@(60*self.rateX));
        make.height.equalTo(@(25*self.rateY));
    }];
    
    /**
     alertTextLabel
     */
    
    UIEdgeInsets insets4 =  UIEdgeInsetsMake(self.rateY * 81, self.rateX * 30.5, self.rateY * 83, self.rateX * 32);
    self.alertTextLabel.text = self.remindText;
    [self.alertTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertWindowImageView.mas_top).with.offset(insets4.top); //with is an optional semantic filler
        make.left.equalTo(self.alertWindowImageView.mas_left).with.offset(insets4.left);
        make.bottom.equalTo(self.alertWindowImageView.mas_bottom).with.offset(-insets4.bottom);
        make.right.equalTo(self.alertWindowImageView.mas_right).with.offset(-insets4.right);
    }];
    
    /**
     horizonalLine
     */
    
    UIEdgeInsets insets5 =  UIEdgeInsetsMake(self.rateY * 148.5, self.rateX * 0, self.rateY * 54.5, self.rateX * 0);
    [self.horizonalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertWindowImageView.mas_top).with.offset(insets5.top); //with is an optional semantic filler
        make.left.equalTo(self.alertWindowImageView.mas_left).with.offset(insets5.left);
        make.bottom.equalTo(self.alertWindowImageView.mas_bottom).with.offset(-insets5.bottom);
        make.right.equalTo(self.alertWindowImageView.mas_right).with.offset(-insets5.right);
    }];
    
    /**
     verticalLine
     */
    
    UIEdgeInsets insets6 =  UIEdgeInsetsMake(self.rateY * 149.5, self.rateX * 152, self.rateY * 0, self.rateX * 153);
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertWindowImageView.mas_top).with.offset(insets6.top);
        make.left.equalTo(self.alertWindowImageView.mas_left).with.offset(insets6.left);
        make.width.equalTo(@(1*self.rateX));
        make.height.equalTo(@(54.5*self.rateY));
    }];
    
    /**
     cancelButton
     */
    
    UIEdgeInsets insets7 =  UIEdgeInsetsMake(self.rateY * 148.5, self.rateX * 0, self.rateY * 16, self.rateX * 60.5);
//    self.cancelButton.backgroundColor = [UIColor blueColor];
    [self.cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertWindowImageView.mas_top).with.offset(insets7.top); //with is an optional semantic filler
        make.left.equalTo(self.alertWindowImageView.mas_left).with.offset(insets7.left);
        make.width.equalTo(@(153*self.rateX));
        make.height.equalTo(@(54.5*self.rateY));
    }];
    
    /**
     okButton
     */
    
    UIEdgeInsets insets8 = UIEdgeInsetsMake(self.rateY * 148.5, self.rateX * 153, self.rateY * 16.5, self.rateX * 208.5);
//    self.okButton.backgroundColor = [UIColor blackColor];
    [self.okButton addTarget:self action:@selector(clickOkButton) forControlEvents:UIControlEventTouchUpInside];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertWindowImageView.mas_top).with.offset(insets8.top); //with is an optional semantic filler
        make.left.equalTo(self.alertWindowImageView.mas_left).with.offset(insets8.left);
        make.width.equalTo(@(153*self.rateX));
        make.height.equalTo(@(54.5*self.rateY));
    }];
    [super updateConstraints];
}

- (void)initEffectView {
    self.effectView = [[UIView alloc] initWithFrame:ScreenFrame];
    self.effectView.backgroundColor = [UIColor colorWithRed:114.0/255 green:109.0/255 blue:131.0/255 alpha:0.62];
    self.effectView.userInteractionEnabled = YES;
    if ([self.hideIdentifier isEqualToString:@"Yes"]) {
        [self.effectView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEffectView)]];
    }

    
    [self addSubview:self.effectView];
}

- (void)initAlertView {
    UIImage *alertWindowImage = [UIImage imageNamed:@"过短弹窗"];
    self.alertWindowImageView = [[UIImageView alloc] initWithImage:alertWindowImage];
    self.alertWindowImageView.userInteractionEnabled = YES;
    [self addSubview:self.alertWindowImageView];
    
    UIImage *remindIcon = [UIImage imageNamed:@"提示icon"];
    self.remindImageView = [[UIImageView alloc] initWithImage:remindIcon];
    [self.alertWindowImageView addSubview:self.remindImageView];
    
    UIImage *lineImage1 = [UIImage imageNamed:@"横分割线2"];
    self.horizonalLine = [[UIImageView alloc] initWithImage:lineImage1];
    [self.alertWindowImageView addSubview:self.horizonalLine];
    
    UIImage *lineImage2 = [UIImage imageNamed:@"束分割线2"];
    self.verticalLine = [[UIImageView alloc] initWithImage:lineImage2];
    [self.alertWindowImageView addSubview:self.verticalLine];
    
    self.cancelButton = [[UIButton alloc] init];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:UIColorFromRGB(alertColor) forState:UIControlStateNormal];
    [self.alertWindowImageView addSubview:self.cancelButton];
    
    self.okButton = [[UIButton alloc] init];
    [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.okButton setTitleColor:UIColorFromRGB(normalColor) forState:UIControlStateNormal];
    [self.alertWindowImageView addSubview:self.okButton];
    
    
    self.alertTextLabel = [[UILabel alloc] init];
    self.alertTextLabel.numberOfLines = -1;
    self.alertTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertTextLabel setText:self.remindText];
    self.alertTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [self.alertTextLabel setTextColor:UIColorFromRGB(textColor)];
    self.remindTextLines = self.remindText.length / 2 / (243.5 * self.rateX / 14);
    [self.alertWindowImageView addSubview:self.alertTextLabel];
    
    self.alertTitleLabel = [[UILabel alloc] init];
    [self.alertTitleLabel setText:@"提示"];
    self.alertTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0 * screenHeigth/667.0];
    [self.alertTitleLabel setTextColor:UIColorFromRGB(textColor)];
    [self.alertWindowImageView addSubview:self.alertTitleLabel];
    
    self.hideIdentifier = @"Yes";
    
}

- (void)clickOkButton {
    self.hidden = YES;
    self.block();
}

- (void)clickCancelButton {
    self.hidden = YES;
}

- (void)clickEffectView {
    self.hidden = YES;
}


+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
