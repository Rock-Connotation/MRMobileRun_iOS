//
//  RunningModel.m
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/20.
//

#import "RunningModel.h"
#import "RunningModel.h"
@interface RunningModel ()
{
    NSTimer *_time;
}
@end

@implementation RunningModel
    //开始采集
- (void)startSelectData{
    if (!_time) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self->_time = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(timeToAdd)
                                                   userInfo:nil
                                                    repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self->_time forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
    }else{
         [_time setFireDate:[NSDate distantPast]];
    }
}

- (void)timeToAdd{
    //配置时间 时：分：秒
    self.selectTime +=1;
    NSInteger hour,minute,second;
    hour = _selectTime/3600;  //小时
    minute = _selectTime/60 - 60*hour; //分钟
    second = _selectTime - 60*minute-3600*hour; //秒
    NSString *string = [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)hour, (long)minute, (long)second];
    
    //通过协议方法去传递时间的值
    if ([self.delegate respondsToSelector:@selector(showSportsPresentTime:intTime:)]) {
        [self.delegate showSportsPresentTime:string intTime:(int)_selectTime];
    }
}

#pragma mark -- 暂停跑步
- (void)pauseSports{
    
    [_time setFireDate:[NSDate distantFuture]];
}

#pragma mark -- 继续跑步
- (void)continueToSports{
    
    [_time setFireDate:[NSDate distantPast]];
}

#pragma mark -- 结束跑步
-(void)endSports
{
    [_time setFireDate:[NSDate distantFuture]];
}

@end
