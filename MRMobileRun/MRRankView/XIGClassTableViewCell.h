//
//  XIGClassTableViewCell.h
//  MobileRun
//
//  Created by xiaogou134 on 2017/11/25.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XIGClassTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
