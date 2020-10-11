//
//  MGDDataTool.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/10/11.
//

#import "MGDDataTool.h"
#import "MGDTimeTool.h"
#import <AFNetworking.h>

@implementation MGDDataTool

+ (MGDCellDataViewController *) DataToMGDCellDataVC:(MGDSportData *)model {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    MGDCellDataViewController *detailDataVC = [[MGDCellDataViewController alloc] init];
    //距离
    detailDataVC.distanceStr = [NSString stringWithFormat:@"%.2f",[model.distance floatValue] / 1000];
    //日期
    detailDataVC.date = [MGDTimeTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%@", model.FinishDate]];
    //时间
    detailDataVC.time = [MGDTimeTool getTimeStringWithTimeStr:[NSString stringWithFormat:@"%@",model.FinishDate]];
    //速度
    detailDataVC.speedStr = [MGDTimeTool getAverageSpeed:[NSString stringWithFormat:@"%0.2f",[model.AverageSpeed floatValue]]];
    //步频
    detailDataVC.stepFrequencyStr = [NSString stringWithFormat:@"%d",[model.AverageStepFrequency intValue]];
    //跑步时长
    detailDataVC.timeStr = [MGDTimeTool getRunTimeFromSS:model.totalTime];
    //卡路里
    detailDataVC.energyStr = [NSString stringWithFormat:@"%d",[model.cal intValue]];
    //最大速度
    detailDataVC.MaxSpeed = [NSString stringWithFormat:@"%0.2f",[model.MaxSpeed floatValue]];
    //最大步频
    detailDataVC.MaxStepFrequency = [NSString stringWithFormat:@"%d",[model.MaxStepFrequency intValue]];
    //温度
    detailDataVC.degree = [NSString stringWithFormat:@"%d°C",[model.Temperature intValue]];
    //步频数组，用于画图
    detailDataVC.stepFrequencyArray = [self DataViewArray:model.StepFrequencyArray];
    //速度数组，用于画图
    detailDataVC.speedArray = [self DataViewArray:model.SpeedArray];
    //路径数组，用于绘制轨迹
    detailDataVC.locationAry = [self DataViewArray:model.pathArray];
    detailDataVC.userIconStr = [user objectForKey:@"avatar_url"];
    detailDataVC.userNmaeStr = [user objectForKey:@"nickname"];
    return detailDataVC;
}

+ (NSArray *)DataViewArray:(NSArray *)dataArr {
    NSString *CLASS = [NSString stringWithFormat:@"%@",[dataArr class]];
    if ([CLASS isEqualToString:@"__NSSingleObjectArrayI"]) {
        return @[];
    }else {
        NSMutableArray *test = [dataArr mutableCopy];
        NSString *s = test.lastObject;
        [test removeLastObject];
        s = [s substringToIndex:s.length - 2];
        [test addObject:s];
        return [test copy];
    }
}

//解决杨诚上传的空数组的BUG，如果时间戳为0的话，去除该数据
+ (NSMutableArray *)cleanZeroData:(NSMutableArray *)array {
   NSArray *TempArray = [NSArray arrayWithArray:array];
    for (MGDSportData *model in TempArray) {
        NSString *date = [NSString stringWithFormat:@"%@",model.FinishDate];
        if ([date isEqualToString:@"0"]) {
            [array removeObject:model];
        }
        
    }
    return array;
}


@end
