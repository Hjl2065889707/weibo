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
#import "CollectButton.h"
#import "UserInformation.h"

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
-(void)loadSubviews
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
    nameTextView.textContainer.maximumNumberOfLines = 1;//最大行数设置为1
    nameTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;//文本超过显示范围就显示省略号
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
    //收藏按钮
    CollectButton *collectButton = [[CollectButton alloc] init];
    [collectButton setImage:[UIImage imageNamed:@"collect-no.png"] forState:UIControlStateNormal];
       [collectButton setImage:[UIImage imageNamed:@"collect-yes.png"] forState:UIControlStateSelected];
    [collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    collectButton.frame = _wbCellFrame.collectButtonFrame;
    _collectButton = collectButton;
    [self.contentView addSubview:collectButton];
    //获取当前用户信息，用于获取文件目录
    UserInformation *userInformation = [[UserInformation alloc] init];
    //从文件中获取数据
    self.collectArray = [[NSMutableArray alloc] initWithContentsOfFile:userInformation.collectFilePath];
    //文件为空则创建数组
    if (self.collectArray == nil) {
            self.collectArray = [[NSMutableArray alloc] init];
    }
    TheWbData *wbData = self.theWBData;
    //如果数组中存在该微博，则收藏按钮状态为yes
    for (int i = 0;i<self.collectArray.count;i++) {
        NSDictionary *dic = self.collectArray[i];
        if ([wbData.creatTime isEqualToString:[dic valueForKey:@"created_at"]] && [wbData.name isEqualToString:[dic valueForKey:@"name"]]) {
            _collectButton.selected = YES;
            }
    }

    //文字内容
    UITextView *mainTextView = [[UITextView alloc] init];
    mainTextView.frame = _wbCellFrame.mainTextViewFrame;
    mainTextView.editable = NO;
    mainTextView.scrollEnabled = NO;
    mainTextView.delegate = self;
    [self.contentView addSubview:mainTextView];
    
    NSMutableAttributedString *mainText = [[NSMutableAttributedString alloc] initWithString:self.theWBData.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} ];
    NSMutableArray *linkTextArray = [NSMutableArray array];
    //利用NSDataDetector来找到文字中的链接,并对链接进行处理
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    [detector enumerateMatchesInString:self.theWBData.text
                               options:0
                                 range:NSMakeRange(0, [self.theWBData.text length])
                            usingBlock:
    ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        //如果存在链接,将该链接的range和NSMutableAttributedString存入linkTextArray
        if (result.range.length > 0) {
            //linkText:字符为🔗网页链接，蓝色，font为18，已设置LinkAttribute
            NSMutableAttributedString *linkText = [[NSMutableAttributedString alloc] initWithString:@"🔗网页链接" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blueColor],NSLinkAttributeName:result.URL} ];
            NSValue *range = [NSValue valueWithRange:result.range];
            NSLog(@"%@",result.URL);
            NSDictionary *dic = @{@"linkText":linkText,@"range":range};
            [linkTextArray addObject:dic];
        }
    }];
    //将指定range中的文本替换为linktext
    while (linkTextArray.count > 0) {
        [mainText replaceCharactersInRange:[[[linkTextArray lastObject] valueForKey:@"range"] rangeValue] withAttributedString:[[linkTextArray lastObject] valueForKey:@"linkText"] ];
        [linkTextArray removeLastObject];
    }
    mainTextView.attributedText = mainText;
    
//    //图片内容
//    if (self.theWBData.pictureNumber.intValue == 1) {
//        NSData *pictureImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.theWBData.middlePictureURL] ];
//        UIImage *mainImage = [[UIImage alloc] initWithData:pictureImageData];
//        _pictureImageView = [[UIImageView alloc] initWithImage:mainImage];
//        //设置imageView的contentMode属性为UIViewContentModeScaleAspectFill，能保证图片比例不变，填充整个ImageView，但可能只有部分图片显示出来
//        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _pictureImageView.frame = _wbCellFrame.mainImageViewFrame;
//        [self.contentView addSubview:_pictureImageView];
//    }else if (self.theWBData.pictureNumber.intValue != 0){
//        for (int i = 0; i < self.theWBData.pictureNumber.intValue; i++) {
//            if (self.theWBData.pictureNumber.intValue > 9) {
//                self.theWBData.pictureNumber = @9;
//            }
//            NSData *pictureImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.theWBData.pictureURLs objectAtIndex:i] valueForKey:@"thumbnail_pic"] ] ];
//            UIImage *image = [[UIImage alloc] initWithData:pictureImageData];
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//            //设置imageView的contentMode属性为UIViewContentModeScaleAspectFill，能保证图片比例不变，填充整个ImageView，但可能只有部分图片显示出来
//            imageView.contentMode = UIViewContentModeScaleAspectFill;
//            imageView.clipsToBounds = YES;
//            imageView.frame =
//            [[_wbCellFrame.picturesFrameArray objectAtIndex:i] CGRectValue];
//            [self.contentView addSubview:imageView];
//        }
//    }
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
    [self loadImageView];
}

#pragma mark - loadImageView
- (void)loadImageView
{
    //异步加载imageVIew
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //图片内容
        if (self.theWBData.pictureNumber.intValue == 1) {
            NSData *pictureImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.theWBData.middlePictureURL] ];
            UIImage *mainImage = [[UIImage alloc] initWithData:pictureImageData];
            self.pictureImageView = [[UIImageView alloc] initWithImage:mainImage];
            //设置imageView的contentMode属性为UIViewContentModeScaleAspectFill，能保证图片比例不变，填充整个ImageView，但可能只有部分图片显示出来
            self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.pictureImageView.frame = self.wbCellFrame.mainImageViewFrame;
            [self.contentView addSubview:self.pictureImageView];
        }else if (self.theWBData.pictureNumber.intValue != 0){
            for (int i = 0; i < self.theWBData.pictureNumber.intValue; i++) {
                if (self.theWBData.pictureNumber.intValue > 9) {
                    self.theWBData.pictureNumber = @9;
                }
                NSData *pictureImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.theWBData.pictureURLs objectAtIndex:i] valueForKey:@"thumbnail_pic"] ] ];
                UIImage *image = [[UIImage alloc] initWithData:pictureImageData];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    //设置imageView的contentMode属性为UIViewContentModeScaleAspectFill，能保证图片比例不变，填充整个ImageView，但可能只有部分图片显示出来
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.clipsToBounds = YES;
                    imageView.frame =
                    [[self.wbCellFrame.picturesFrameArray objectAtIndex:i] CGRectValue];
                    [self.contentView addSubview:imageView];
                        });
            }
        }
    });
    
    
    
}


#pragma mark -ButtonMethod

- (void)nameClick
{
    [WeiboSDK linkToUser:[NSString stringWithFormat:@"%@",self.theWBData.userId]];
}

- (void)collectButtonClick:(UIButton *)button
{
    //获取当前用户信息，用于获取文件目录
    UserInformation *userInformation = [[UserInformation alloc] init];
    //从文件中获取数据
    self.collectArray = [[NSMutableArray alloc] initWithContentsOfFile:userInformation.collectFilePath];
    //文件为空则创建数组
    if (self.collectArray == nil) {
            self.collectArray = [[NSMutableArray alloc] init];
    }
    TheWbData *wbData = self.theWBData;
    //如果数组中存在该微博，则删除(根据用户名和微博发布时间判断)
    for (int i = 0;i<self.collectArray.count;i++) {
        NSDictionary *dic = self.collectArray[i];
        if ([wbData.creatTime isEqualToString:[dic valueForKey:@"created_at"]] && [wbData.name isEqualToString:[dic valueForKey:@"name"]]) {
            [self.collectArray removeObjectAtIndex:i];
        }
    }
    if (button.selected == NO) {
        NSLog(@"收藏成功");
        //添加当前微博的数据到数组中
        [self.collectArray addObject:[TheWbData initDicitonaryWithTheWbData:wbData]];
        //写入数据
    }else{
        NSLog(@"取消收藏成功");
        }
    //写入数据
    NSArray *array = [[NSArray alloc] initWithArray:self.collectArray];
    [array writeToFile:userInformation.collectFilePath atomically:NO];
    //切换button选中状态
    button.selected = !button.selected;
}




#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    [_delegate performSelector:@selector(poenLinkText:) withObject:URL];
    return NO;
}


@end
