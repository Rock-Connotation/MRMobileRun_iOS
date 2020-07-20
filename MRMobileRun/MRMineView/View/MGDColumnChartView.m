//
//  MGDColumnChartView.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/7/18.
//

#import "MGDColumnChartView.h"
#import <Masonry.h>

#define LINECOLOR [UIColor colorWithRed:85/255.0 green:213/255.0 blue:226/255.0 alpha:1.0]
#define BACKGROUNDCOLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]
#define COLUMNCHARTCOLOR [UIColor colorWithRed:255/255.0 green:92/255.0 blue:119/255.0 alpha:1.0]
#define XLABELCOLOR [UIColor colorWithRed:51/255.0 green:55/255.0 blue:57/255.0 alpha:1.0]
#define YLABELCOLOR [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
#define topMargin screenHeigth * 0.06
#define leftMargin screenWidth * 0.0667
#define bottomMargin screenHeigth * 0.0375
#define XLen screenWidth * 0.8693
#define YLen screenHeigth * 0.2444
#define chartViewH screenHeigth * 0.3418



@interface MGDColumnChartView () {
    CGFloat _itemBottomY;
    CGFloat _oneItemH;
    NSArray *_currentHeaderItem;
    NSInteger _firstIndex;
    bool _isLayoutChart;
}

//月份滑动
@property (nonatomic, strong) UIScrollView *headerView;
//月份按钮
@property (nonatomic, strong) NSMutableArray *headerBtns;
//下划线
@property (nonatomic, strong) UIView *linePointView;
//下划线宽度
@property (nonatomic, assign) CGFloat linePointW;
//月份滑动高度
@property (nonatomic, assign) CGFloat headerH;
//年份选择
@property (nonatomic, strong) UIButton *yearLabel;
//柱形图滑动
@property (nonatomic, strong) UIScrollView *ChartScrollView;
//柱形图
@property (nonatomic, strong) UIView *chartView;
//柱形图柱子数组
@property (nonatomic, strong) NSMutableArray *chartItems;

@end

@implementation MGDColumnChartView

- (UIView *)linePointView
{
    if (_linePointView == nil) {
        _linePointView = [[UIView alloc] init];
        _linePointView.frame = CGRectMake(0, _headerH - 5, _linePointW, 4);
        _linePointView.backgroundColor = LINECOLOR;
        _linePointView.layer.cornerRadius = 2.0;
        [self.headerView addSubview:_linePointView];
    }
    return _linePointView;
}

- (NSMutableArray *)headerBtns
{
    if (_headerBtns == nil) {
        _headerBtns = [NSMutableArray array];
    }
    return _headerBtns;
}

- (NSMutableArray *)chartItems
{
    if (_chartItems == nil) {
        _chartItems = [NSMutableArray array];
    }
    return _chartItems;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initChild];
    }
    return self;
}

- (void)initChild {
    CGFloat lineW = screenWidth * 0.112;
    CGFloat headerH = screenHeigth * 0.045;
    _headerH = headerH;
    _linePointW = lineW;
    _isLayoutChart = false;
    
    _yearLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _yearLabel.frame = CGRectMake(screenWidth * 0.780, screenHeigth * 0.0075, screenWidth * 0.172, screenHeigth * 0.0315);
    [_yearLabel setTitleColor:XLABELCOLOR forState:UIControlStateNormal];
    _yearLabel.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
    [_yearLabel setImage:[UIImage imageNamed:@"矩形"] forState:UIControlStateNormal];
    _yearLabel.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_yearLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, screenWidth * 0.0373)];
    [_yearLabel setImageEdgeInsets:UIEdgeInsetsMake(screenHeigth * 0.012, screenWidth * 0.136, screenHeigth * 0.009, 0)];
    _yearLabel.backgroundColor = [UIColor clearColor];
    
    [_yearLabel addTarget:self action:@selector(yearClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _headerView = [[UIScrollView alloc] init];
    _headerView.frame = CGRectMake(0, 0, screenWidth * 0.4196, screenHeigth * 0.045);
    _headerView.backgroundColor = [UIColor clearColor];
    _headerView.showsHorizontalScrollIndicator = NO;
    _headerView.showsVerticalScrollIndicator = NO;
    _headerView.pagingEnabled = NO;
    
    _chartView = [[UIView alloc] init];
    _chartView.frame = CGRectMake(0, _headerH, screenWidth, chartViewH);
    _chartView.backgroundColor = [UIColor clearColor];
    
    
    _ChartScrollView = [[UIScrollView alloc] init];
    _ChartScrollView.frame = CGRectMake(leftMargin + 1, 0, XLen, chartViewH);
    _ChartScrollView.backgroundColor = [UIColor clearColor];
    _ChartScrollView.contentSize = CGSizeMake(461, chartViewH);
    _ChartScrollView.bounces = NO;
    _ChartScrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_headerView];
    [self addSubview:_yearLabel];
    [self addSubview:_chartView];
    [self.chartView addSubview:_ChartScrollView];
}

- (void)yearClick:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(changeYearClick:sender:)]) {
        [_delegate changeYearClick:self sender:sender];
    }
}

- (void)setDelegate:(id<MGDColumnChartViewDelegate>)delegate {
    _delegate = delegate;
    
    [self layoutHeaderItem];
    [self layoutChartView];
    [self clickItemIndex:_firstIndex];
}

- (void)setYearName:(NSString *)yearName
{
    _yearName = yearName;
    [_yearLabel setTitle:yearName forState:UIControlStateNormal];
}

//------- 布局header
- (void)layoutHeaderItem
{
    if ([_delegate respondsToSelector:@selector(columnChartTitleArrayYear:)]) {
        NSArray *items = [_delegate columnChartTitleArrayYear:_yearName];
        UIButton *lastBtn = nil;
        NSInteger currentItem = 0;
        if (items.count > 0) {
            for (NSInteger i = 0; i < items.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitle:items[i] forState:UIControlStateNormal];
                CGFloat btnx = lastBtn == nil ? 3 : CGRectGetMaxX(lastBtn.frame);
                btn.frame = CGRectMake(btnx, 0, btn.frame.size.width + 69, 30);
                [self.headerView addSubview:btn];
                
                lastBtn = btn;
                [btn addTarget:self action:@selector(headerItemClick:) forControlEvents:UIControlEventTouchUpInside];
                if ([@"本月" isEqualToString:items[i]]) {
                    currentItem = i;
                }
                btn.tag = i;
                [self.headerBtns addObject:btn];
            }
        }
        
        self.headerView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame), _headerH);
        [self setSelectItem:self.headerBtns[currentItem] isAnima:NO];
        
        _firstIndex = currentItem;
        _currentHeaderItem = items;
    }
}

//------- header 控制
- (void)headerItemClick:(UIButton *)sender
{
    [self setSelectItem:sender isAnima:true];
}

- (void)clickItemIndex:(NSInteger)index
{
    UIButton *sender = self.headerBtns[index];
    [sender sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelectItem:(UIButton *)sender isAnima:(BOOL)isAnima
{
    for (UIButton *senderTemp in self.headerBtns) {
        [senderTemp setTitleColor:YLABELCOLOR forState:UIControlStateNormal];
        senderTemp.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    }
    
    CGFloat senderX = CGRectGetMinX(sender.frame);
    CGFloat itemX = senderX + (sender.frame.size.width - _linePointW) * 0.5;
    
    CGRect lineFrame = self.linePointView.frame;
    lineFrame.origin.x = itemX;
    
    if (isAnima) {
        [UIView animateWithDuration:0.3 animations:^{
            self.linePointView.frame = lineFrame;
            [sender setTitleColor:XLABELCOLOR forState:UIControlStateNormal];
            sender.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
        }];
    }else {
        self.linePointView.frame = lineFrame;
        [sender setTitleColor:XLABELCOLOR forState:UIControlStateNormal];
    }
    
    //停留的位置
    CGFloat senderCenterX = CGRectGetMidX(sender.frame);
    
    if (senderCenterX < self.headerView.frame.size.width * 0.5) {
        [self.headerView setContentOffset:CGPointMake(0, 0) animated:isAnima];

    }else if (senderCenterX > (self.headerView.contentSize.width - self.headerView.frame.size.width * 0.5)) {
        [self.headerView setContentOffset:CGPointMake(self.headerView.contentSize.width - self.headerView.frame.size.width, 0) animated:isAnima];

    }else {
        CGFloat offsetX = senderCenterX - (self.headerView.frame.size.width * 0.5);
        [self.headerView setContentOffset:CGPointMake(offsetX, 0) animated:isAnima];
    }
    
    [self changeChartShowName:sender.currentTitle index:sender.tag];
}

//------- 布局chart
- (void)layoutChartView
{
    CGFloat chartSizeH = self.chartView.frame.size.height;
    CGFloat dataX = screenWidth * 0.9173;
    CGFloat itemXMargin = screenWidth * 0.016;
    CGFloat itemCountX = 31;
    CGFloat itemCountY = 5;
    CGFloat itemYH = (YLen - screenHeigth * 0.009) / itemCountY;
    CGFloat itemXW = screenWidth * 0.0213;
    CGFloat YlabMargin = screenWidth * 0.04;
    
    //X轴
    CALayer *axisX = [self getLayer:UIColor.blackColor frame:CGRectMake(leftMargin, topMargin + YLen, XLen , 1)];
    [self.chartView.layer addSublayer:axisX];
    
    //Y轴
    CALayer *axisY = [self getLayer:UIColor.blackColor frame:CGRectMake(leftMargin, topMargin, 1, YLen)];
    [self.chartView.layer addSublayer:axisY];
    
    for (NSInteger i = 0; i < itemCountY; i++) {
        //Y轴的灰色准线
        CALayer *itemY = [self getLayer:[UIColor colorWithWhite:0 alpha:0.2] frame:CGRectMake(leftMargin, CGRectGetMinY(axisX.frame) - itemYH * (i + 1), CGRectGetWidth(axisX.frame), 0.5)];
        [self.chartView.layer addSublayer:itemY];
        
        //Y轴文字
        CATextLayer *labelY = [self getYLabel:[NSString stringWithFormat:@"%ld",i+1] font:8 frame:CGRectMake(YlabMargin, itemY.frame.origin.y - 11, 5, 11)];
        [self.chartView.layer addSublayer:labelY];
    }
    
    NSArray *showXArr = @[@"1", @"5", @"10",@"20",@"15",@"25",@"30"];
    for (NSInteger i = 0; i < itemCountX; i++) {
        //X轴的柱形
        CALayer *itemX = [self getLayer:COLUMNCHARTCOLOR frame:CGRectMake( 9 + (itemXMargin + itemXW) * i,0, itemXW, CGRectGetMinY(axisX.frame))];
        itemX.cornerRadius = 2.0;
        [self.ChartScrollView.layer addSublayer:itemX];
    
        //X轴的文字
        NSString *currentIndex = [NSString stringWithFormat:@"%ld", i+1];
        if ([showXArr containsObject: currentIndex]) {
            CATextLayer *labelX = [self getXLabel:currentIndex font:8 frame:CGRectMake(itemX.frame.origin.x - 2, axisX.frame.origin.y + 1, 10, 11)];
            [self.ChartScrollView.layer addSublayer:labelX];
        }
        
        [self.chartItems addObject:itemX];
    }
    
    _itemBottomY = chartSizeH - leftMargin;
    _oneItemH = itemYH;
    
    CATextLayer *pointZero = [self getYLabel:@"0" font:8 frame:CGRectMake(15, chartSizeH - topMargin + 11, 5, 11)];
    [self.chartView.layer addSublayer:pointZero];
    
    CATextLayer *messageX = [self getXLabel:@"日期" font:8 frame:CGRectMake(dataX, CGRectGetMaxY(axisX.frame) + 2, 16, 11)];
    messageX.backgroundColor = [UIColor whiteColor].CGColor;
    [self.chartView.layer addSublayer:messageX];
    
    CATextLayer *messageY = [self getYLabel:@"千米" font:11 frame:CGRectMake( screenWidth * 0.04,screenHeigth * 0.021 , 22, 16)];
    [self.chartView.layer addSublayer:messageY];
}

- (CATextLayer *)getYLabel:(NSString *)str font:(NSInteger)font frame:(CGRect)frame {
    CATextLayer *label = [[CATextLayer alloc] init];
    label.string = str;
    label.font = (__bridge CFTypeRef _Nullable)@"PingFangSC-Regular";
    label.fontSize = font;
    label.frame = frame;
    label.alignmentMode = @"center";
    label.contentsScale = 3;
    label.foregroundColor = YLABELCOLOR.CGColor;
    return label;
}

- (CATextLayer *)getXLabel:(NSString *)str font:(NSInteger)font frame:(CGRect)frame {
    CATextLayer *label = [[CATextLayer alloc] init];
    label.string = str;
    label.font = (__bridge CFTypeRef _Nullable)@"PingFangSC-Medium";
    label.fontSize = font;
    label.frame = frame;
    label.alignmentMode = @"center";
    label.contentsScale = 3;
    label.foregroundColor = XLABELCOLOR.CGColor;
    return label;
}
- (CALayer *)getLayer:(UIColor *)color frame:(CGRect)frame {
    CALayer *layer = [[CALayer alloc] init];
    layer.backgroundColor = color.CGColor;
    layer.frame = frame;
    return layer;
}



- (CGFloat)getChartH:(CGFloat)chartH
{
    CGFloat itemH = _oneItemH * chartH;
    if (chartH > 5.6) {
        itemH = _oneItemH * 5.6;
    }
    
    return itemH;
}

- (void)changeChartShowName:(NSString *)name index:(NSInteger) index
{
    if (!_isLayoutChart && [_delegate respondsToSelector:@selector(columnChartNumberArrayFor:index:year:)]) {
        NSArray *arr = [_delegate columnChartNumberArrayFor:name index:index year:_yearName];
        if (arr.count >= _currentHeaderItem.count && self.chartItems.count > 0) {
            _isLayoutChart = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self->_isLayoutChart = NO;
            });
            [UIView animateWithDuration:0.1 animations:^{
                NSInteger indexTemp = 0;
                for (CALayer *item in self.chartItems) {
                    CGFloat itemH = [self getChartH:[arr[indexTemp] floatValue]];
                    item.frame = CGRectMake(item.frame.origin.x, self->_itemBottomY - itemH, item.frame.size.width, itemH);
                    indexTemp++;
                }
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

//换页面时重新显示
- (void)reloadData
{
    [[self.headerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.headerView addSubview:self.linePointView];
    [self.headerBtns removeAllObjects];
    [self layoutHeaderItem];
    [self clickItemIndex:_firstIndex];
}




@end
