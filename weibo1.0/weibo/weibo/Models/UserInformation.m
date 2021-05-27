//
//  UserInformation.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/13.
//

#import "UserInformation.h"
#import "AccessToken.h"
@implementation UserInformation
//设置为单例模式
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static id instance = nil;
    if(instance == nil){
        instance = [super allocWithZone:zone];
    }
    return instance;
}

- (void)setUserId:(NSString *)userId
{
    _userId = userId;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _browseHistoryFilePath = [NSString stringWithFormat:@"%@/%@browseHistory.plist",docPath,userId];
    _collectFilePath = [NSString stringWithFormat:@"%@/%@collect.plist",docPath,userId];
    _postedWBFilePath = [NSString stringWithFormat:@"%@/%@postedWB.plist",docPath,userId];
    _searchHistoryFilePath = [NSString stringWithFormat:@"%@/%@searchHistory.plist",docPath,userId];
    //获取头像和名称
    NSURLSession *session = [NSURLSession sharedSession];//创建会话对象
    AccessToken *accessToken = [[AccessToken alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",accessToken.access_token,userId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) {
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        self.headImageURL = [NSURL URLWithString:[dic valueForKey:@"profile_image_url"]];
        self.name = [dic valueForKey:@"name"];
    }];
    [dataTask resume];
    
}
@end
