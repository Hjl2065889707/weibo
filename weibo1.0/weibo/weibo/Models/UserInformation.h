//
//  UserInformation.h
//  weibo
//
//  Created by 黄俊龙 on 2021/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInformation : NSObject
@property(strong,nonatomic)NSString *userId;
@property(strong,nonatomic)NSString *browseHistoryFilePath;
@end

NS_ASSUME_NONNULL_END