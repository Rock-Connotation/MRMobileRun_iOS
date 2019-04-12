//
//  XIGSegementView.m
//  MobileRun
//
//  Created by xiaogou134 on 2017/11/19.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "XIGSegementView.h"
#import <YYkit.h>
#define DefaultTitleHeight (30 *screenHeigth/667)
#define DefaultTitleBackGroundColor ([UIColor clearColor])
#define DefaultTitleTextNormalColor ([UIColor grayColor])
#define DefaultTitleTextFocusColor ([UIColor blackColor])
@interface XIGSegementView()<UIScrollViewDelegate>
@property NSArray <UIViewController *> *controllers;
@property UIScrollView *mainScrollView;
@property UIScrollView *titleScrollView;
@property UIView *sliderView;
@property NSInteger currentIndex;
@property CGFloat titleBtnWidth;
@property NSMutableArray <UIButton *> *btnArray;
@end
@implementation XIGSegementView
- (instancetype)initWithFrame:(CGRect)frame andControllers:(NSArray <UIViewController *> *)controllers WithStyle:(NSString *)style{
    self = [self initWithFrame:frame];
    if(self){
        self.controllers = controllers;
        if (self.controllers.count >=4) {
            self.titleBtnWidth = self.width/4;
        }
        else{
            self.titleBtnWidth = self.width/self.controllers.count;
        }
        self.titleViewStyle = style;
        [self setDefault];
        [self initWithTitleView:style];
        [self initWithMainView];
       
    }
    return self;
    
}
- (void)setDefault{
    _titleHight = DefaultTitleHeight;
    _titleBackGroundColor = DefaultTitleBackGroundColor;
    _titleTextNormalColor = DefaultTitleTextNormalColor;
    _titleTextFocusColor = DefaultTitleTextFocusColor;
}
- (void)initWithTitleView:(NSString *)style {
    _titleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, _titleHight)];
    _titleScrollView.contentSize = CGSizeMake(self.titleBtnWidth * self.controllers.count,_titleHight);
    _titleScrollView.bounces = NO;
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.showsVerticalScrollIndicator = NO;
    _titleScrollView.backgroundColor = _titleBackGroundColor;
    [_titleScrollView flashScrollIndicators];
    
//    UIView *cuttingLine = [[UIView alloc]initWithFrame:CGRectMake(0, kTitleHeight-1, _titleScrollView.contentSize.width, 1)];
//    cuttingLine.backgroundColor = [UIColor colorWithRed:226/255.0 green:227/255.0 blue:229/255.0 alpha:1];
    
    _btnArray = [NSMutableArray<UIButton *> array];
    for (int i = 0; i < self.controllers.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*self.titleBtnWidth, 0, self.titleBtnWidth, _titleHight);
        [btn setTitle:self.controllers[i].title forState:UIControlStateNormal];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:_titleTextNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleTextFocusColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_titleScrollView addSubview:btn];
        [_btnArray addObject:btn];
    }
    _currentIndex = 0;
    [_btnArray firstObject].selected = YES;
    if ([style isEqualToString:@"custom"]) {
        _sliderView = [[UIView alloc]initWithFrame:CGRectMake(0, _titleHight-2, self.titleBtnWidth, 2)];
        _sliderView.backgroundColor = [UIColor colorWithHexString:@"65b2ff"];
    }
//    [_titleScrollView addSubview:cuttingLine];
    [_titleScrollView addSubview:self.sliderView];
    [self addSubview:self.titleScrollView];
}

- (void)initWithMainView {
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _titleHight, self.width, self.height-_titleHight)];
    
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.contentSize = CGSizeMake(self.controllers.count*self.width, 0);
    
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    
    for (int i = 0; i < _controllers.count; i++) {
        UIView *view = self.controllers[i].view;
        view.frame = CGRectMake(i * self.width, 0, self.width, self.height-_titleHight);
        [_mainScrollView addSubview:view];
    }
    
    [self addSubview:self.mainScrollView];
    
}

- (void)clickBtn:(UIButton *)sender {
    //    [self.backScrollView setContentOffset:CGPointMake(sender.tag*ScreenWidth, 0) animated:YES];
    [self.mainScrollView setContentOffset:CGPointMake(sender.tag * self.width, 0) animated:YES];
    
    //    [UIView animateWithDuration:0.2f animations:^{
    //        _mainScrollView.contentOffset = CGPointMake(sender.tag * self.width, 0);
    //    } completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger currentIndex = round(_mainScrollView.contentOffset.x / self.width);
    
    if (currentIndex != self.currentIndex) {
        self.btnArray[self.currentIndex].selected = NO;
        if ([_titleViewStyle isEqualToString:@"custom"]) {
            [UIView animateWithDuration:0.2f animations:^{
                _sliderView.frame = CGRectMake(currentIndex * _titleBtnWidth, _titleHight - 2, _titleBtnWidth, 2);
            }];
        }
        [UIView animateWithDuration:0.2f animations:^{
            if (self.btnArray[currentIndex].frame.origin.x < self.width/2) {
                [_titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            } else if (self.titleScrollView.contentSize.width - self.btnArray[currentIndex].frame.origin.x <= self.width/2) {
                [_titleScrollView setContentOffset:CGPointMake(self.controllers.count*_titleBtnWidth-self.width, 0) animated:YES];
            } else {
                [_titleScrollView setContentOffset:CGPointMake(self.btnArray[currentIndex].frame.origin.x-self.width/2+self.titleBtnWidth/2, 0) animated:YES];
            }
            
        } completion:nil];
        if ([self.eventDelegate respondsToSelector:@selector(eventWhenScrollSubViewWithIndex:)]) {
            [self.eventDelegate eventWhenScrollSubViewWithIndex:currentIndex];
        }
        self.currentIndex = currentIndex;
        self.btnArray[self.currentIndex].selected = YES;
    }
    
}
-(void)setTitleTextFocusColor:(UIColor *)titleTextFocusColor{
    _titleTextFocusColor = titleTextFocusColor;
    for (UIButton *btn in _btnArray) {
        [btn setTitleColor:titleTextFocusColor forState:UIControlStateSelected];
    }
}
-(void)setTitleTextNormalColor:(UIColor *)titleTextNormalColor{
    _titleTextNormalColor = titleTextNormalColor;
    for (UIButton *btn in _btnArray) {
        [btn setTitleColor:titleTextNormalColor forState:UIControlStateNormal];
    }
}
-(void)setTitleBackGroundColor:(UIColor *)titleBackGroundColor{
    _titleBackGroundColor = titleBackGroundColor;
    _titleScrollView.backgroundColor = titleBackGroundColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
