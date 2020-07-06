//
//  MRLoginTextField.m
//  MobileRun
//
//  Created by 郑沛越 on 2016/12/3.
//  Copyright © 2016年 郑沛越. All rights reserved.
//

#import "MRLoginTextField.h"

@interface MRLoginTextField()

@end

@implementation MRLoginTextField

- (instancetype)initTextFieldWithFrame:(CGRect)frame{
    if (self = [super init]) {
        [self initTextField:frame];
    }
    return self;
}

- (void)initTextField:(CGRect )frame{
    self.textField = [[UITextField alloc]init];
    //初始化文本框
    self.textField.frame = CGRectMake(screenWidth *(frame.origin.x + 107)/750,screenHeigth *(frame.origin.y )/1334,screenWidth* (frame.size.width - 107)/750,screenHeigth * (frame.size.height)/1334);
    //设置文本框位置
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,(screenWidth +107)/750,(screenHeigth +35)/1334)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    //设置文本框光标位置
    
    self.textField.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    //设置字体和字体大小

    self.textField.returnKeyType = UIReturnKeyDone;
    
    self.textImage = [[UIImageView alloc]init];
    //初始化文本框图片
    self.textImage.frame = CGRectMake(screenWidth  *frame.origin.x/750,screenHeigth* frame.origin.y/1334,screenWidth* frame.size.width/750,screenHeigth* frame.size.height/1334);
    
    self.iconImage = [[UIImageView alloc]init];
    //初始化文本框icon
    self.iconImage.frame = CGRectMake
    (screenWidth* ( frame.origin.x + 50)/750,screenHeigth *(frame.origin.y + 37)/1334,screenWidth *28/750,screenHeigth *28/1334);
    //设置icon位置
    
    
    [self addSubview:self.iconImage];
    [self addSubview:self.textImage];
    
}

/*
// Only override drawRect: if you perform custom drawing.
   - (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
