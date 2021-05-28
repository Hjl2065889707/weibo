//
//  SearchHistoryTableView.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/24.
//

#import "SearchHistoryTableView.h"

@implementation SearchHistoryTableView



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
    sectionView.backgroundColor = [UIColor lightGrayColor];
    UILabel *sectionText = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 30)];
    sectionText.text = @"搜索记录";
    [sectionView addSubview:sectionText];
    UIButton *deleteButton = [UIButton systemButtonWithImage:[UIImage imageNamed:@"delete"] target:self action:@selector(removeAllSearchHistory)];
    deleteButton.frame = CGRectMake(self.bounds.size.width-50, 0, 30, 30);
    [sectionView addSubview:deleteButton];
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _searchHistoryArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];//从复用回收池中取cell
    if(!cell){//如果取不到就让cell=新建cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    cell.textLabel.text = [_searchHistoryArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;//设置cell的高度
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchHistoryTableViewDelegate replaceSearchBarTextWithString:[_searchHistoryArray objectAtIndex:indexPath.row]];
}

//左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //左滑删除cell
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [_searchHistoryArray removeObjectAtIndex:indexPath.row];
        NSArray *tempArray = [NSArray arrayWithArray:_searchHistoryArray];
        [tempArray writeToFile:_userInformation.searchHistoryFilePath atomically:NO];
        [self reloadData];
    }
}




- (void)loadSearchHistory
{
    self.delegate = self;
    self.dataSource = self;
    _userInformation = [[UserInformation alloc] init];
    _searchHistoryArray = [NSMutableArray arrayWithContentsOfFile:_userInformation.searchHistoryFilePath];
    if (!_searchHistoryArray) {
        _searchHistoryArray = [NSMutableArray array];
    }
}

- (void)addWithHistoryString:(NSString *)str
{
    //如果数组中存在该搜索记录，则删除
    for (int i = 0;i<self.searchHistoryArray.count;i++) {
        if ([str isEqualToString:_searchHistoryArray[i]]) {
            [_searchHistoryArray removeObject:str];
        }
    }
    if (_searchHistoryArray.count > 10) {
        [_searchHistoryArray removeLastObject];
    }
    [_searchHistoryArray insertObject:str atIndex:0];
    NSArray *tempArray = [NSArray arrayWithArray:_searchHistoryArray];
    [tempArray writeToFile:_userInformation.searchHistoryFilePath atomically:NO];
    [self reloadData];
    NSLog(@"%@",str);
    
}

- (void)removeAllSearchHistory
{
    [_searchHistoryArray removeAllObjects];
    [self reloadData];
}

@end
