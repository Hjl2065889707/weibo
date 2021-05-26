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
    self.digitPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ || name CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@", @"测评",@"钟文泽", @"系统",@"数码",@"手机",@"硬件",@"评测",@"耳机"];
    self.petPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@", @"七仔",@"猫", @"狗",@"金毛",@"兔",@"羊"];
    self.plmmPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ || name CONTAINS %@ || name CONTAINS %@ || name CONTAINS %@ || text CONTAINS %@", @"少女",@"梨涡", @"钰汐",@"张妖怪",@"美女"];
    self.sameCityPredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", @"location",@"广州"];
    self.sportPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ || name CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@ || text CONTAINS %@", @"篮圈",@"体育",@"体育",@"球",@"比赛"];
    return self;
}


@end
