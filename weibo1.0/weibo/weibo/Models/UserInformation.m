//
//  UserInformation.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/13.
//

#import "UserInformation.h"

@implementation UserInformation
//设置为单例模式
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static id instance = nil;
    if(instance == nil){
        instance = [super allocWithZone:zone];
    }
    return instance;
}

- (void)setUserId:(NSString *)userId
{
    _userId = userId;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _browseHistoryFilePath = [NSString stringWithFormat:@"%@/%@browseHistory.plist",docPath,userId];
    
}
@end
