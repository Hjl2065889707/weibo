//
//  SearchHistoryTableView.h
//  weibo
//
//  Created by 黄俊龙 on 2021/5/24.
//

#import <UIKit/UIKit.h>
#import "UserInformation.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SearchHistoryTableViewDelegate <NSObject>

- (void)replaceSearchBarTextWithString:(NSString *)str;

@end


@interface SearchHistoryTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)id <SearchHistoryTableViewDelegate> searchHistoryTableViewDelegate;
@property(strong,nonatomic)UserInformation *userInformation;
@property(strong,nonatomic)NSMutableArray *searchHistoryArray;

- (void)loadSearchHistory;
- (void)addWithHistoryString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
