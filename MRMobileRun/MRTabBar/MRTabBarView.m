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
@implementation MRTabBarView


- (void)setArray:(NSMutableArray *)array{
    _array = array;
    self.backgroundColor = COLOR_WITH_HEX(0xFAFAFA);
    for (int i = 0; i < _array.count; i++) {
//        判断是否属于中心的button
//        如果tabBarItems不是偶数，记得加个判断（不过我觉得不可能滴）
        if (i != _array.count/2) {
//            设置正常button
            UIButton *btn = _array[i];
            btn.tag = i;
            [btn addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview: btn];
            if (kIs_iPhoneX) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).mas_offset(9*kRateY);
                    make.left.mas_equalTo(i*screenWidth/self.array.count + screenWidth/self.array.count/2-20*kRateX);
                    make.width.mas_equalTo(40*kRateX);
                    make.height.mas_equalTo(60*kRateY);
                }];
            }else{
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).mas_offset(5*kRateY);
                    make.left.mas_equalTo(i*screenWidth/self.array.count + screenWidth/self.array.count/2-20);
                    make.width.mas_equalTo(35);
                    make.height.mas_equalTo(40);
                }];
            }
            [_array replaceObjectAtIndex:i withObject: btn];
            
        }
        else{
            
            //设置中心大button
            UIButton *btn = _array[i];
            btn.tag = i;
             [btn addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if (kIs_iPhoneX) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top);
                    make.centerX.mas_equalTo(self.mas_centerX);
                    make.width.mas_equalTo(60*kRateX);
                    make.height.mas_equalTo(60*kRateX);
                }];
            }else{
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top);
                    make.centerX.mas_equalTo(self.mas_centerX);
                    make.width.mas_equalTo(40*kRateX);
                    make.height.mas_equalTo(40*kRateX);
                }];
            }
        }

    }
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
    lastItem.enabled = YES;
    // 再把这次选择的item设置为不可用
    UIButton *item = _array[selectIndex];
    item.enabled = NO;
    _selectIndex = selectIndex;
}

@end
