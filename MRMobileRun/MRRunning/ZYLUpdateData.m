//
//  ZYLUpdateData.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/3.
//

#import "ZYLUpdateData.h"
#import "AESCipher.h"

@implementation ZYLUpdateData
+ (NSString *)ZYLGetUpdateDataDictionaryWithBegintime:(NSNumber *)begin Endtime:(NSNumber *)end distance:(NSNumber *)distance lat_lng:(NSArray *)lat_lng andSteps:(NSNumber *)steps{
    NSUserDefaults *user = [[NSUserDefaults alloc] init];
    NSString *student = [user objectForKey:@"studentID"];
    NSDictionary *dic = @{@"begin_time": begin,
                          @"distance": distance,
                          @"end_time": end,
                          @"lat_lng": lat_lng,
                          @"steps": steps,
                          @"student_id": student
                          };
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *encryptedText = aesEncryptString(str, kDECRYPTKEY);
    
    return encryptedText;
}

@end
