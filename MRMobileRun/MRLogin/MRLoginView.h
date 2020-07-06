//
//  MRLoginView.h
//  MobileRun
//
//  Created by 郑沛越 on 2016/11/30.
//  Copyright © 2016年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRLoginBtu.h"
#import "MRLoginTextField.h"

@interface MRLoginView : UIView<UITextFieldDelegate>
- (instancetype)init;

@property(nonatomic,strong) MRLoginBtu *loginBtu;
//登录按钮
@property(nonatomic,strong) UITextField *idTextfield;
//账户名输入文本框
@property(nonatomic,strong) UITextField *passWordTextfield;
//密码输入文本框
@property(nonatomic,strong) MRLoginTextField *idTextfieldView;
//账户名输入文本框视图
@property(nonatomic,strong) MRLoginTextField *passWordTextFieldView;
//密码输入文本框视图

@end
