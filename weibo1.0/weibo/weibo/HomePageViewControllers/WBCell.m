//
//  WBCell.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/10.
//

#import "WBCell.h"
#import "WeiboSDK.h"
#import "WBHttpRequest.h"
#import <WebKit/WebKit.h>
#import "WebViewController.h"

@implementation WBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code 该方法通过xib生成cell时会调用
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return  self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark - initSubviews
-(void)initSubviews
{
    //头像图片
    NSData *headImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.theWBData.profileImageURL]];
    UIImageView *headImageView = [ [UIImageView alloc] initWithImage:[UIImage imageWithData:headImageData] ];
    headImageView.frame = _wbCellFrame.headImageViewFrame;
    [self.contentView addSubview:headImageView];
    //昵称
    UITextView *nameTextView = [[UITextView alloc] init];
    nameTextView.text = self.theWBData.name;
    nameTextView.frame = _wbCellFrame.nameTextViewFrame;
    nameTextView.editable = NO;
    nameTextView.scrollEnabled = NO;
    nameTextView.font = [UIFont fontWithName:@"Arial" size:18];
    [self.contentView addSubview:nameTextView];
    //时间
    UITextView *timeTextView = [[UITextView alloc] init];
    timeTextView.text = self.theWBData.creatTime;
    timeTextView.frame = _wbCellFrame.timeTextViewFrame;
    timeTextView.editable = NO;
    timeTextView.scrollEnabled = NO;
    timeTextView.font = [UIFont fontWithName:@"Arial" size:16];
    [self.contentView addSubview:timeTextView];
    //文字内容
    UITextView *mainTextView = [[UITextView alloc] init];
    mainTextView.frame = _wbCellFrame.mainTextViewFrame;
    mainTextView.editable = NO;
    mainTextView.scrollEnabled = NO;
    mainTextView.delegate = self;
    [self.contentView addSubview:mainTextView];
    
    NSMutableAttributedString *mainText = [[NSMutableAttributedString alloc] initWithString:self.theWBData.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} ];
    //利用NSDataDetector来找到文字中的链接,并对链接进行处理
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    [detector enumerateMatchesInString:self.theWBData.text
                               options:kNilOptions
                                 range:NSMakeRange(0, [self.theWBData.text length])
                            usingBlock:
    ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        //如果存在链接
        if (result.range.length > 0) {
            //设置链接颜色
            [mainText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:result.range];
            //
            [mainText addAttribute:NSLinkAttributeName value:result.URL range:result.range];
        }

        
        
    }];
    mainTextView.attributedText = mainText;
    
    //图片内容
    if (self.theWBData.pictureNumber.intValue != 0) {
        NSData *pictureImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.theWBData.middlePictureURL] ];
        UIImage *mainImage = [[UIImage alloc] initWithData:pictureImageData];
        _pictureImageView = [[UIImageView alloc] initWithImage:mainImage];
        //设置imageView的contentMode属性为UIViewContentModeScaleAspectFill，能保证图片比例不变，填充整个ImageView，但可能只有部分图片显示出来
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.frame = _wbCellFrame.mainImageViewFrame;
        [self.contentView addSubview:_pictureImageView];
    }
    //评论数
    UITextView *commentNumber = [[UITextView alloc] init];
    commentNumber.text = [NSString stringWithFormat:@"评论：%@",self.theWBData.commentsCount];
    commentNumber.frame = _wbCellFrame.commentTextViewFrame;
    commentNumber.editable = NO;
    commentNumber.scrollEnabled = NO;
    commentNumber.font = [UIFont fontWithName:@"Arial" size:15];
    [self.contentView addSubview:commentNumber];
    //转发数
    UITextView *repostsNumber = [[UITextView alloc] init];
    repostsNumber.text = [NSString stringWithFormat:@"转发：%@",self.theWBData.repostsCount];
    repostsNumber.frame = _wbCellFrame.repostTextViewFrame;
    repostsNumber.editable = NO;
    repostsNumber.scrollEnabled = NO;
    repostsNumber.font = [UIFont fontWithName:@"Arial" size:15];
    [self.contentView addSubview:repostsNumber];
    //点赞数
    UITextView *attitudeNumber = [[UITextView alloc] init];
    attitudeNumber.text = [NSString stringWithFormat:@"点赞：%@",self.theWBData.attitudesCount];
    attitudeNumber.frame = _wbCellFrame.attitudeTextViewFrame;
    attitudeNumber.editable = NO;
    attitudeNumber.scrollEnabled = NO;
    attitudeNumber.font = [UIFont fontWithName:@"Arial" size:15];
    [self.contentView addSubview:attitudeNumber];
}



- (void)nameClick
{
    [WeiboSDK linkToUser:[NSString stringWithFormat:@"%@",self.theWBData.userId]];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    
    return YES;
}

@end
