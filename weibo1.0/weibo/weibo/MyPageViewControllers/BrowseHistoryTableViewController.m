//
//  BrowseHistoryTableViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/13.
//

#import "BrowseHistoryTableViewController.h"
#import "UserInformation.h"
#import "TheWbData.h"
#import "WBCellFrame.h"
#import "WBCell.h"
#import <WebKit/WebKit.h>
#import "WebViewController.h"


@interface BrowseHistoryTableViewController ()<UITableViewDelegate,UITableViewDataSource,TheWBCellDelegate>
@property(strong,nonatomic)NSMutableArray *browseHistoryArray;
@property(strong,nonatomic)WBCellFrame *wbCellFrame;

@end

@implementation BrowseHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserInformation *userInformation = [[UserInformation alloc] init];
    self.browseHistoryArray = [[NSMutableArray alloc] initWithContentsOfFile:userInformation.browseHistoryFilePath];

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _browseHistoryArray.count;
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
    cell.delegate = self;
    //设置theWBData
    TheWbData *wbdata = [[TheWbData alloc] init];
    [wbdata initWithFilePathDictionary:self.browseHistoryArray[indexPath.row]];
    cell.theWBData = wbdata;
  //  [cell.theWBData initWithWebDictionary:self.browseHistoryArray[indexPath.row]];
    //设置wbCellFrame
    _wbCellFrame = [[WBCellFrame alloc] init];
    _wbCellFrame.wbData = cell.theWBData;//该行可以初始化wbCellFrame的所有属性
    cell.wbCellFrame = _wbCellFrame;
    //创建cell的子view的
    [cell loadSubviews];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _wbCellFrame.attitudeTextViewFrame.origin.y+40;//设置cell的高度
}

- (void)poenLinkText:(NSURL *)url
{
    WebViewController *webViewController = [[WebViewController alloc] init];
    webViewController.url = url;
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
