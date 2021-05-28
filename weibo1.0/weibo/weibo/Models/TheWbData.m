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
    _name = [[dic valueForKey:@"user"] valueForKey:@"name"];
    _profileImageURL = [[dic valueForKey:@"user"] valueForKey:@"profile_image_url"];
    _creatTime = [dic valueForKey:@"created_at"];
    _location = [[dic valueForKey:@"user"] valueForKey:@"location"];
    _text = [dic valueForKey:@"text"];
    _pictureNumber = [dic valueForKey:@"pic_num"];
    _pictureURLs = [dic valueForKey:@"pic_urls"];
    _attitudesCount = [dic valueForKey:@"attitudes_count"];
    _commentsCount = [dic valueForKey:@"comments_count"];
    _repostsCount = [dic valueForKey:@"reposts_count"];
    _userId = [[dic valueForKey:@"user"] valueForKey:@"id"];
    _originalPictureURL = [dic valueForKey:@"original_pic"];
    _middlePictureURL = [dic valueForKey:@"bmiddle_pic"];
    _wbId = [dic valueForKey:@"id"];
}

- (void)initWithFilePathDictionary:(NSDictionary *)dic
{
    _name = [dic valueForKey:@"name"];
    _profileImageURL = [dic valueForKey:@"profile_image_url"];
    _creatTime = [dic valueForKey:@"created_at"];
    _location = [dic valueForKey:@"location"];
    _text = [dic valueForKey:@"text"];
    _pictureNumber = [dic valueForKey:@"pic_num"];
    _pictureURLs = [dic valueForKey:@"pic_urls"];
    _attitudesCount = [dic valueForKey:@"attitudes_count"];
    _commentsCount = [dic valueForKey:@"comments_count"];
    _repostsCount = [dic valueForKey:@"reposts_count"];
    _userId = [dic valueForKey:@"userId"];
    _originalPictureURL = [dic valueForKey:@"original_pic"];
    _middlePictureURL = [dic valueForKey:@"bmiddle_pic"];
    _wbId = [dic valueForKey:@"id"];
    _pictureData = [dic valueForKey:@"pictureData"];

    //防止dic中key的值为nil
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (!obj) {
                obj = [NSString stringWithFormat:@"nil"];
            }
    }];
}

+ (NSDictionary *)initDicitonaryWithTheWbData:(TheWbData *)theWbData
{
    if (!theWbData.originalPictureURL) {
        theWbData.originalPictureURL = [NSString stringWithFormat:@"nil"];
    }
    if (!theWbData.middlePictureURL) {
        theWbData.middlePictureURL = [NSString stringWithFormat:@"nil"];
    }
    if (!theWbData.location) {
        theWbData.location = [NSString stringWithFormat:@"nil"];
    }
    if (!theWbData.pictureData) {
        theWbData.pictureData = [[NSData alloc] init];
    }
    NSDictionary *dic = @{
                          @"name" : theWbData.name,
                    @"created_at" : theWbData.creatTime,
                      @"location" : theWbData.location,
             @"profile_image_url" : theWbData.profileImageURL,
                          @"text" : theWbData.text,
                       @"pic_num" : theWbData.pictureNumber,
                      @"pic_urls" : theWbData.pictureURLs,
               @"attitudes_count" : theWbData.attitudesCount,
                @"comments_count" : theWbData.commentsCount,
                 @"reposts_count" : theWbData.repostsCount,
                        @"userId" : theWbData.userId,
                  @"original_pic" : theWbData.originalPictureURL,
                   @"bmiddle_pic" : theWbData.middlePictureURL,
                            @"id" : theWbData.wbId,
                   @"pictureData" : theWbData.pictureData
    };
    return dic;
}


@end
