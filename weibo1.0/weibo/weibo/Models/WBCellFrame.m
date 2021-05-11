//
//  WBCellFrame.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/11.
//

#import "WBCellFrame.h"

@implementation WBCellFrame


- (void)setWbData:(TheWbData *)wbData
{
    self.wbData = wbData;
    //通过重写setWbData的方法来完成在设置wbData的时候根据传入的wbData设置对应的Frame属性
    _headImageViewFrame = CGRectMake(20, 20, 50, 50);
    _nameTextViewFrame = CGRectMake(100, 20, 200, 30);
    _mainTextViewFrame = CGRectMake(20, 100, 300,100);
    _timeTextViewFrame = CGRectMake(100, 55, 200, 30);;
    _mainImageViewFrame = CGRectMake(20, 210, 210,210);;
    _commentTextViewFrame = CGRectMake(130,450, 110, 30);
    _attitudeTextViewFrame = CGRectMake(250,450,110,30);
    _repostTextViewFrame = CGRectMake(10,450,110,30);;
}

@end
