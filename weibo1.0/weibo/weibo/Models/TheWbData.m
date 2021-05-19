//
//  TheWbData.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/9.
//

#import "TheWbData.h"

@implementation TheWbData

- (void)initWithWebDictionary:(NSDictionary *)dic
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
    self.middlePictureURL = [dic valueForKey:@"bmiddle_pic"];
    self.wbId = [dic valueForKey:@"id"];
}

- (void)initWithFilePathDictionary:(NSDictionary *)dic
{
    self.name = [dic valueForKey:@"name"];
    self.profileImageURL = [dic valueForKey:@"profile_image_url"];
    self.creatTime = [dic valueForKey:@"created_at"];
    self.location = [dic valueForKey:@"location"];
    self.text = [dic valueForKey:@"text"];
    self.pictureNumber = [dic valueForKey:@"pic_num"];
    self.pictureURLs = [dic valueForKey:@"pic_urls"];
    self.attitudesCount = [dic valueForKey:@"attitudes_count"];
    self.commentsCount = [dic valueForKey:@"comments_count"];
    self.repostsCount = [dic valueForKey:@"reposts_count"];
    self.userId = [dic valueForKey:@"userId"];
    self.originalPictureURL = [dic valueForKey:@"original_pic"];
    self.middlePictureURL = [dic valueForKey:@"bmiddle_pic"];
    self.wbId = [dic valueForKey:@"id"];

    //防止dic中key的值为nil
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (obj == nil) {
                obj = [NSString stringWithFormat:@"nil"];
            }
    }];
}

+ (NSDictionary *)initDicitonaryWithTheWbData:(TheWbData *)theWbData
{
    if (theWbData.originalPictureURL == nil) {
        theWbData.originalPictureURL = [NSString stringWithFormat:@"nil"];
    }
    if (theWbData.middlePictureURL == nil) {
        theWbData.middlePictureURL = [NSString stringWithFormat:@"nil"];
    }
    if (theWbData.location == nil) {
        theWbData.location = [NSString stringWithFormat:@"nil"];
    }
    
    NSDictionary *dic = @{@"name":theWbData.name,
                    @"created_at":theWbData.creatTime,
                      @"location":theWbData.location,
             @"profile_image_url":theWbData.profileImageURL,
                          @"text":theWbData.text,
                       @"pic_num":theWbData.pictureNumber,
                      @"pic_urls":theWbData.pictureURLs,
               @"attitudes_count":theWbData.attitudesCount,
                @"comments_count":theWbData.commentsCount,
                  @"reposts_count":theWbData.repostsCount,
                        @"userId":theWbData.userId,
                  @"original_pic":theWbData.originalPictureURL,
                   @"bmiddle_pic":theWbData.middlePictureURL,
                            @"id":theWbData.wbId
    };
    return dic;
}


@end
