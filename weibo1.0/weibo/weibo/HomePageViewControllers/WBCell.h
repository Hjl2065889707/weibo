//
//  WBCell.h
//  weibo
//
//  Created by 黄俊龙 on 2021/5/10.
//

#import <UIKit/UIKit.h>
#import "TheWbData.h"
#import "WBCellFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBCell : UITableViewCell<UITextViewDelegate>

@property(strong,nonatomic)TheWbData *theWBData;
@property(strong,nonatomic)UIImageView *pictureImageView;
@property(strong,nonatomic)WBCellFrame *wbCellFrame;
@property(strong,nonatomic)NSMutableArray *collectArray;

- (void)initSubviews;

@end

NS_ASSUME_NONNULL_END
