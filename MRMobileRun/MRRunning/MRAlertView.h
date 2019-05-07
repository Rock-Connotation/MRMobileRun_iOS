//
//  MRAlertView.h
//  MRAlertView
//
//  Created by RainyTunes on 2017/2/19.
//  Copyright © 2017年 We.Can. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRAlertView : UIView
+ (instancetype)alertViewWithTitle:(NSString *)title action:(void(^)())handler;
@property UIButton *okButton;
@property UIButton *cancelButton;
@property UIView *effectView;
@property (nonatomic,strong)NSString *hideIdentifier;

@end
