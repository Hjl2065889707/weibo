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
    _wbData = wbData;
    //通过重写setWbData的方法来完成在设置wbData的时候根据传入的wbData设置对应的Frame属性
    _headImageViewFrame = CGRectMake(20, 20, 60, 60);
    _nameTextViewFrame = CGRectMake(100, 20, 300, 30);
    _timeTextViewFrame = CGRectMake(100, 55, 300, 30);
    //动态设置textView的高
    NSLog(@"%@",wbData.text);
    CGRect mainTextRect = [wbData.text boundingRectWithSize:CGSizeMake(350, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];//text:用来计算的字符串;size:计算的宽高限制（固定的写确定的值，需要计算的写CGFLOAT_MAX）;options:文本绘制的附加选项;attributes:字典格式，限定字符串显示的样式，一般限制字体较多;context:包括一些信息，（如：如何调整字间距以及缩放），最终该对象包含的信息将会用于文本绘制，一般写nil
    CGFloat mainTextHeight = mainTextRect.size.height+10;
    _mainTextViewFrame = CGRectMake(20, 100, 350,mainTextHeight);
    //设置图片frame
    CGFloat mainImageHeight;
    if (wbData.pictureNumber.intValue != 0) {
        mainImageHeight = 230.0f;
    }else{
        mainImageHeight = 10;
    }
    _mainImageViewFrame = CGRectMake(20,_mainTextViewFrame.origin.y+mainTextHeight+20, 210,mainImageHeight);
    //设置转发，评论，点赞frame
    _repostTextViewFrame = CGRectMake(10,_mainImageViewFrame.origin.y+mainImageHeight,110,30);
    _commentTextViewFrame =
        CGRectMake(130,_mainImageViewFrame.origin.y+mainImageHeight, 110, 30);
    _attitudeTextViewFrame = CGRectMake(250,_mainImageViewFrame.origin.y+mainImageHeight,110,30);

}

@end
