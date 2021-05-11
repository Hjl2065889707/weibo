//
//  access_token.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/9.
//

#import "AccessToken.h"

@implementation AccessToken


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static id instance = nil;
    if(instance == nil){
        instance = [super allocWithZone:zone];
    }
    return instance;
}
@end
