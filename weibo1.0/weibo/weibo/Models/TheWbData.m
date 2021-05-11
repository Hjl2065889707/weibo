//
//  TheWbData.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/9.
//

#import "TheWbData.h"

@implementation TheWbData

- (void)initWithDictionary:(NSDictionary *)dic
{
    self.name = [[dic valueForKey:@"user"] valueForKey:@"name"];
    self.profileImageURL = [[dic valueForKey:@"user"] valueForKey:@"profile_image_url"];
    self.creatTime = [dic valueForKey:@"created_at"];
    self.location = [[dic valueForKey:@"user"] valueForKey:@"location"];
    self.text = [dic valueForKey:@"text"];
    self.pictureNumber = [dic valueForKey:@"pic_num"];
    self.pictureURLs = [dic valueForKey:@"pic_urls"];
    self.attitudesCount = [dic valueForKey:@"attitudes_count"];
    self.commentsCount = [dic valueForKey:@"comments_count"];
    self.repostsCount = [dic valueForKey:@"reposts_count"];
    self.userId = [[dic valueForKey:@"user"] valueForKey:@"id"];
    self.originalPictureURL = [dic valueForKey:@"original_pic"];
}




@end
