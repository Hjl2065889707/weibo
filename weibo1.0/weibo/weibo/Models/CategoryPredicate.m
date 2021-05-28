//
//  CategoryPredicate.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/26.
//

#import "CategoryPredicate.h"

@implementation CategoryPredicate

- (instancetype)init{
    self = [super init];
    _digitPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ || name CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@", @"测评",@"钟文泽", @"系统",@"数码",@"手机",@"硬件",@"评测",@"耳机",@"Apple"];
    _petPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@", @"七仔",@"猫", @"狗",@"金毛",@"兔",@"柯基"];
    _plmmPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ || name CONTAINS %@ || name CONTAINS %@ || name CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@", @"少女",@"梨涡", @"钰汐",@"张妖怪",@"美女",@"少女",@"黑丝",@"仙女",@"校花"];
    _sameCityPredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", @"location",@"广州"];
    _sportPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ || name CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@", @"篮圈",@"体育",@"体育",@"足球",@"比赛",@"篮球",@"乒乓球",@"羽毛球",@"排球",@"NBA",@"CBA",@"运动",@"健身",@"男篮",@"女排",@"马拉松",@"长跑",@"跑步",@"扣篮",@"冠军"];
    return self;
}


@end
