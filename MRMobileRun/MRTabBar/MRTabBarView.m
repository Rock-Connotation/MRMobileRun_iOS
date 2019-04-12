//
//  MRTabBarView.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/3/23.
//

/*
 TabBar view
 
 
 */

#import "MRTabBarView.h"
#define SELECTED_COLOR [UIColor colorWithRed:0 green:0 blue:31.0/255.0 alpha:1]
#define DEFAULT_COLOR [UIColor colorWithRed:175.0/255.0 green:157.0/255.0 blue:206.0/255.0 alpha:1]
#define screenHeigth [UIScreen mainScreen].bounds.size.height
#define screenWidth [UIScreen mainScreen].bounds.size.width
@implementation MRTabBarView


- (void)setTextArray:(NSMutableArray *)textArray{
    _textArray = textArray;
    self.labArray = [NSMutableArray array];
    CGFloat WIDTH = self.bounds.size.width;
    NSLog(@"%f",WIDTH);
    for (int i = 0; i < _array.count; i++) {
//        判断是否属于中心的button
//        如果tabBarItems不是偶数，记得加个判断（不过我觉得不可能滴）
        if (i != _array.count/2) {
//            设置正常button
            UIButton *btn = _array[i];
            btn.tag = i;
            [btn addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview: btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).mas_offset(9);
                make.left.mas_equalTo(i*WIDTH/self.textArray.count + WIDTH/self.textArray.count/2-10);
                make.width.mas_equalTo(20);
                make.height.mas_equalTo(20);
            }];
            [_array replaceObjectAtIndex:i withObject: btn];
            
            UILabel *lab = [[UILabel alloc] init];
            lab.textColor = [UIColor colorWithRed:69.0/255.0 green:41.0/255.0 blue:115.0/255.0 alpha:1];
            lab.textAlignment = NSTextAlignmentCenter;
            [lab setFont:[UIFont systemFontOfSize:11.5]];
            NSString *str = self.textArray[i];
            lab.text = str;
            [self.labArray addObject:lab];
            [self addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btn.mas_bottom).mas_offset(3);
                make.centerX.equalTo(btn.mas_centerX);
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(15);
            }];
        }
        else{
            
            //设置中心大button
            [self.labArray addObject: [[UILabel alloc] init]];
            UIButton *btn = _array[i];
            btn.tag = i;
             [btn addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.top.equalTo(self.mas_top).mas_offset(-30);
                 make.centerX.mas_equalTo(self.mas_centerX);
                make.width.mas_equalTo(80);
                make.height.mas_equalTo(80);
             }];
        }

    }
        UILabel *lab = self.labArray[0];
        lab.textColor = SELECTED_COLOR;
    self.selectIndex = 0;
}

- (void)selectedItem:(UIButton *)sender
{
    // button的tag对应tabBarController的selectedIndex
    // 设置选中button的样式
    self.selectIndex = sender.tag;
    // 让代理来处理切换viewController的操作
    if ([self.delegate respondsToSelector:@selector(tabBarView:didSelectedItemAtIndex:)]) {
        [self.delegate tabBarView:self didSelectedItemAtIndex:sender.tag];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    // 先把上次选择的item设置为可用
    UIButton *lastItem = _array[_selectIndex];
    UILabel *lastLab = self.labArray[_selectIndex];
    lastLab.textColor = DEFAULT_COLOR;
    lastItem.enabled = YES;
    // 再把这次选择的item设置为不可用
    UIButton *item = _array[selectIndex];
    UILabel *lab = self.labArray[selectIndex];
    lab.textColor = SELECTED_COLOR;
    item.enabled = NO;
    _selectIndex = selectIndex;
}

@end
