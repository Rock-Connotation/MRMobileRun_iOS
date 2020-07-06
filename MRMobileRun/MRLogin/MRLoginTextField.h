//
//  MRLoginTextField.h
//  MobileRun
//
//  Created by 郑沛越 on 2016/12/3.
//  Copyright © 2016年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRLoginTextField : UITextField
- (instancetype)initTextFieldWithFrame:(CGRect)frame;

@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) UIImageView *textImage;
@property(nonatomic,strong) UIImageView *iconImage;
@end
