//
//  WBCell.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/10.
//

#import "WBCell.h"
#import "WeiboSDK.h"
#import "WBHttpRequest.h"

@implementation WBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code 该方法通过xib生成cell时会调用
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubviews];
    }
    
    return  self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)initSubviews
{
    //头像图片
    NSData *headImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.theWBData.profileImageURL]];
    UIImageView *headImageView = [ [UIImageView alloc] initWithImage:[UIImage imageWithData:headImageData] ];
    headImageView.frame = CGRectMake(20, 20, 50, 50);
    [self.contentView addSubview:headImageView];
    //昵称
    UITextView *nameTextView = [[UITextView alloc] init];
    nameTextView.text = self.theWBData.name;
    nameTextView.frame = CGRectMake(100, 20, 200, 30);
    nameTextView.editable = NO;
    nameTextView.scrollEnabled = NO;
    nameTextView.font = [UIFont fontWithName:@"Arial" size:18];
    [self.contentView addSubview:nameTextView];
    //时间
    UITextView *timeTextView = [[UITextView alloc] init];
    timeTextView.text = self.theWBData.creatTime;
    
    timeTextView.frame = CGRectMake(100, 55, 200, 30);
    timeTextView.editable = NO;
    timeTextView.scrollEnabled = NO;
    timeTextView.font = [UIFont fontWithName:@"Arial" size:16];
    [self.contentView addSubview:timeTextView];
    //文字内容
    UITextView *mainTextView = [[UITextView alloc] init];
    mainTextView.text = self.theWBData.text;
    mainTextView.frame = CGRectMake(20, 100, 300,100);
    mainTextView.editable = NO;
    mainTextView.scrollEnabled = NO;
    mainTextView.font = [UIFont fontWithName:@"Arial" size:18];
    [self.contentView addSubview:mainTextView];
    //图片内容
    if(self.pictureImageView){
        [self.pictureImageView removeFromSuperview];
    }
    if (self.theWBData.pictureNumber != 0) {

        NSData *pictureImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.theWBData.originalPictureURL] ];
        UIImageView *pictureImageView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithData:pictureImageData]];
        pictureImageView.frame = CGRectMake(20, 210, 210,210);
        [self.contentView addSubview:pictureImageView];
    }
    //评论数
    UITextView *commentNumber = [[UITextView alloc] init];
    commentNumber.text = [NSString stringWithFormat:@"评论数：%@",self.theWBData.commentsCount];
    commentNumber.frame = CGRectMake(130,450, 110, 30);
    commentNumber.editable = NO;
    commentNumber.scrollEnabled = NO;
    commentNumber.font = [UIFont fontWithName:@"Arial" size:18];
    [self.contentView addSubview:commentNumber];
    //转发数
    UITextView *repostsNumber = [[UITextView alloc] init];
    repostsNumber.text = [NSString stringWithFormat:@"转发数：%@",self.theWBData.repostsCount];
    repostsNumber.frame = CGRectMake(10,450,110,30);
    repostsNumber.editable = NO;
    repostsNumber.scrollEnabled = NO;
    repostsNumber.font = [UIFont fontWithName:@"Arial" size:18];
    [self.contentView addSubview:repostsNumber];
    //点赞数
    UITextView *attitudeNumber = [[UITextView alloc] init];
    attitudeNumber.text = [NSString stringWithFormat:@"点赞数：%@",self.theWBData.attitudesCount];
    attitudeNumber.frame = CGRectMake(250,450,110,30);
    attitudeNumber.editable = NO;
    attitudeNumber.scrollEnabled = NO;
    attitudeNumber.font = [UIFont fontWithName:@"Arial" size:18];
    [self.contentView addSubview:attitudeNumber];
}



- (void)nameClick
{
    [WeiboSDK linkToUser:[NSString stringWithFormat:@"%@",self.theWBData.userId]];
}

@end
