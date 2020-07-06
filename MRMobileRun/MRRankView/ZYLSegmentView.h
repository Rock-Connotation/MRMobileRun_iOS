//
//  ZYLSegmentView.h
//  MRMobileRun
//
//  Created by 丁磊 on 2019/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectIndexBlock)(NSInteger selectIndex);
@interface ZYLSegmentView : UIView
//默认背景颜色
@property (nonatomic, strong) UIColor *bgColor;

//默认字体颜色
@property (nonatomic, strong) UIColor *titleColor;

//选中字体颜色
@property (nonatomic, strong) UIColor *selectTitleColor;
//滚动条颜色
@property (nonatomic, strong) UIColor *scrollViewColor;

@property (nonatomic, copy) SelectIndexBlock selectBlock;

@property (nonatomic, assign) NSInteger selectedIndex;
//外部调用的接口
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray selectImageArray:(NSArray *)selectImageArray titleArray:(NSArray *)titleArray defaultSelectIndex:(NSInteger)selectedIndex selectBlock:(SelectIndexBlock)selectBlock;

- (void)selectedIndex:(NSInteger)selectIndex;
@end

NS_ASSUME_NONNULL_END
