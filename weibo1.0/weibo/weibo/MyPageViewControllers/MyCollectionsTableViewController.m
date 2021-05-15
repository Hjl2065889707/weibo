//
//  MyCollectionsTableViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/10.
//

#import "MyCollectionsTableViewController.h"
#import "UserInformation.h"
#import "TheWbData.h"
#import "WBCellFrame.h"
#import "WBCell.h"

@interface MyCollectionsTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSMutableArray *collectArray;
@property(strong,nonatomic)WBCellFrame *wbCellFrame;

@end

@implementation MyCollectionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserInformation *userInformation = [[UserInformation alloc] init];
    _collectArray = [[NSMutableArray alloc] initWithContentsOfFile:userInformation.collectFilePath];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collectArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];//从复用回收池中取cell
    if(!cell){//如果取不到就让cell=新建cell
        cell = [[WBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    //移除cell里面的imageView
    for(UIView *uv in cell.contentView.subviews){
            [uv removeFromSuperview];
    }
    //设置cell被选中时不变灰
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置theWBData
    TheWbData *wbdata = [[TheWbData alloc] init];
    [wbdata initWithFilePathDictionary:self.collectArray[indexPath.row]];
    cell.theWBData = wbdata;
    //设置wbCellFrame
    _wbCellFrame = [[WBCellFrame alloc] init];
    _wbCellFrame.wbData = cell.theWBData;//该行可以初始化wbCellFrame的所有属性
    cell.wbCellFrame = _wbCellFrame;
    //创建cell的子view的
    [cell initSubviews];
    cell.collectButton.selected = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _wbCellFrame.attitudeTextViewFrame.origin.y+40;//设置cell的高度
}


@end
