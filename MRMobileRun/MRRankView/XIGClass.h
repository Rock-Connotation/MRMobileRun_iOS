//
//  XIGClass.h
//  MobileRun
//
//  Created by xiaogou134 on 2017/11/20.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XIGClass : UIView
@property (weak, nonatomic) IBOutlet UILabel *diffKindLabel;
@property (weak, nonatomic) IBOutlet UILabel *diffNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordKindLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *stuNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *randkingLabel;
-(void)setKindLabel:(NSString *)kind;
@end
