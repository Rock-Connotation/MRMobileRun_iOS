//
//  XIGInviteTableViewCell.m
//  MobileRun
//
//  Created by xiaogou134 on 2017/11/19.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "XIGInviteTableViewCell.h"

@implementation XIGInviteTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"XIGInviteTableViewCell";
    XIGInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil] firstObject];
        
    }
//    else
//    {
//        //删除cell的所有子视图
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
