//
//  CategoryPredicate.h
//  weibo
//
//  Created by 黄俊龙 on 2021/5/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryPredicate : NSObject

@property(strong,nonatomic)NSPredicate *plmmPredicate;
@property(strong,nonatomic)NSPredicate *sportPredicate;
@property(strong,nonatomic)NSPredicate *digitPredicate;
@property(strong,nonatomic)NSPredicate *sameCityPredicate;
@property(strong,nonatomic)NSPredicate *petPredicate;

@end

NS_ASSUME_NONNULL_END
