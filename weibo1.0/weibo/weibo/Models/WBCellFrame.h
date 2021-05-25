//
//  WBCellFrame.h
//  weibo
//
//  Created by 黄俊龙 on 2021/5/11.
//

#import <Foundation/Foundation.h>
#import "TheWbData.h"
#import "UserInformation.h"
NS_ASSUME_NONNULL_BEGIN

@interface WBCellFrame : NSObject

@property(strong,nonatomic)TheWbData *wbData;

@property(nonatomic)CGRect headImageViewFrame;
@property(nonatomic)CGRect nameTextViewFrame;
@property(nonatomic)CGRect mainTextViewFrame;
@property(nonatomic)CGRect timeTextViewFrame;
@property(nonatomic)CGRect mainImageViewFrame;
@property(nonatomic)CGRect commentTextViewFrame;
@property(nonatomic)CGRect attitudeTextViewFrame;
@property(nonatomic)CGRect repostTextViewFrame;
@property(nonatomic)CGRect collectButtonFrame;
@property(nonatomic,strong)NSMutableArray *picturesFrameArray;


@end

NS_ASSUME_NONNULL_END
