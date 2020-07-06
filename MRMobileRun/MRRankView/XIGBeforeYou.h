//
//  XIGBeforeYou.h
//  MobileRun
//
//  Created by xiaogou134 on 2017/11/19.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XIGBeforeYou : UIView
@property (weak, nonatomic) IBOutlet UILabel *diffNumKindLabel;
@property (weak, nonatomic) IBOutlet UILabel *diffNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordKindLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankingLabl;
-(void)setKindLabel:(NSString *)kind;
@end
