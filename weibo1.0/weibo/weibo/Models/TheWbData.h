//
//  TheWbData.h
//  weibo
//
//  Created by 黄俊龙 on 2021/5/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TheWbData : NSObject
@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *profileImageURL;
@property(strong,nonatomic)NSString *location;
@property(strong,nonatomic)NSString *text;
@property(strong,nonatomic)NSString *creatTime;
@property(strong,nonatomic)NSString *originalPictureURL;
@property(strong,nonatomic)NSNumber *pictureNumber;
@property(strong,nonatomic)NSNumber *attitudesCount;
@property(strong,nonatomic)NSNumber *repostsCount;
@property(strong,nonatomic)NSNumber *commentsCount;
@property(strong,nonatomic)NSNumber *userId;
@property(strong,nonatomic)NSArray *pictureURLs;

- (void)initWithWebDictionary:(NSDictionary *)dic;
- (void)initWithFilePathDictionary:(NSDictionary *)dic;
+ (NSDictionary *)initDicitonaryWithTheWbData:(TheWbData *)theWbData;
@end

NS_ASSUME_NONNULL_END
