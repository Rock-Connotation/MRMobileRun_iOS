//
//  XIGClassTableViewCell.m
//  MobileRun
//
//  Created by xiaogou134 on 2017/11/25.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "XIGClassTableViewCell.h"

@implementation XIGClassTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"XIGClassTableViewCell";
    XIGClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil] firstObject];
        
    }
//    else
//    {
//        while ([cell.contentView.subviews lastObject] != nil)
//        {
//            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
//        }
//    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
