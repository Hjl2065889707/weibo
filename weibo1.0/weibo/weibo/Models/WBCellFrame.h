//
//  WBCellFrame.h
//  weibo
//
//  Created by 黄俊龙 on 2021/5/11.
//

#import <Foundation/Foundation.h>
#import "TheWbData.h"
NS_ASSUME_NONNULL_BEGIN

@interface WBCellFrame : NSObject

@property(strong,nonatomic)TheWbData *wbData;

@property(assign,nonatomic)CGRect headImageViewFrame;
@property(assign,nonatomic)CGRect nameTextViewFrame;
@property(assign,nonatomic)CGRect mainTextViewFrame;
@property(assign,nonatomic)CGRect timeTextViewFrame;
@property(assign,nonatomic)CGRect mainImageViewFrame;
@property(assign,nonatomic)CGRect commentTextViewFrame;
@property(assign,nonatomic)CGRect attitudeTextViewFrame;
@property(assign,nonatomic)CGRect repostTextViewFrame;

@end

NS_ASSUME_NONNULL_END
