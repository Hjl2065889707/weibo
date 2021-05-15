//
//  WBCell.h
//  weibo
//
//  Created by 黄俊龙 on 2021/5/10.
//

#import <UIKit/UIKit.h>
#import "TheWbData.h"
#import "WBCellFrame.h"

@class WBCell;

@protocol TheWBCellDelegate <NSObject>

- (void)poenLinkText:(NSURL *)url;

@end

@interface WBCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic, weak)id <TheWBCellDelegate> delegate;
@property(strong,nonatomic)TheWbData *theWBData;
@property(strong,nonatomic)UIImageView *pictureImageView;
@property(strong,nonatomic)WBCellFrame *wbCellFrame;
@property(strong,nonatomic)NSMutableArray *collectArray;
@property(strong,nonatomic)UIButton *collectButton;


- (void)initSubviews;

@end

