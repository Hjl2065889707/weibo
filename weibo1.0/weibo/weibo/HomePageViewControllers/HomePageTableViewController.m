//
//  HomePageTableViewController.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/2.
//

#import "HomePageTableViewController.h"

@interface HomePageTableViewController ()

@end

@implementation HomePageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"post.png"] style:UIBarButtonItemStyleDone target:self action:@selector(postWB)];
    

    self.navigationItem.rightBarButtonItem = postButton;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)postWB
{
    
    NSLog(@"post");
    AccessToken *token = [[AccessToken alloc] init];
    NSLog(@"%@",token.access_token);
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=%@",token.access_token];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        
        NSArray *statuesArray = [dic valueForKey:@"statuses"];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in statuesArray)
        {
            TheWbData *theWBData = [[TheWbData alloc] init];
            theWBData.name = [[dic valueForKey:@"user"] valueForKey:@"name"];
            theWBData.profileImageURL = [[dic valueForKey:@"user"] valueForKey:@"profile_image_url"];
            theWBData.creatTime = [dic valueForKey:@"creat_at"];
            theWBData.location = [[dic valueForKey:@"user"] valueForKey:@"location"];
            theWBData.text = [dic valueForKey:@"text"];
            theWBData.pictureNumber = [dic valueForKey:@"pic_num"];
            theWBData.pictureURLs = [dic valueForKey:@"pic_urls"];
            theWBData.attitudesCount = [dic valueForKey:@"attitudes_count"];
            theWBData.commentsCount = [dic valueForKey:@"comments_count"];
            theWBData.repostsCount = [dic valueForKey:@"reposts_count"];

            [dataArray addObject:theWBData];
            
        }//将传回的数据转换为theWBData对象并存入数组

        NSLog(@"%lu",dataArray.count);
        
    }];

    [dataTask resume];
}

@end
