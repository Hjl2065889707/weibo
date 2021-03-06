//
//  WBCell.m
//  weibo
//
//  Created by 黄俊龙 on 2021/5/10.
//

#import "WBCell.h"
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
    //昵称
    UITextView *nameTextView = [[UITextView alloc] init];
    nameTextView.text = self.theWBData.name;
    nameTextView.frame = self.wbCellFrame.nameTextViewFrame;
    nameTextView.textContainer.maximumNumberOfLines = 1;//最大行数设置为1
    nameTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;//文本超过显示范围就显示省略号
    nameTextView.editable = NO;
    nameTextView.scrollEnabled = NO;
    nameTextView.font = [UIFont fontWithName:@"Arial" size:18];
    [self.contentView addSubview:nameTextView];
    //时间
    UITextView *timeTextView = [[UITextView alloc] init];
    timeTextView.text = self.theWBData.creatTime;
    timeTextView.frame = self.wbCellFrame.timeTextViewFrame;
    timeTextView.editable = NO;
    timeTextView.scrollEnabled = NO;
    timeTextView.font = [UIFont fontWithName:@"Arial" size:16];
    [self.contentView addSubview:timeTextView];
    //评论数
    UITextView *commentNumber = [[UITextView alloc] init];
    commentNumber.text = [NSString stringWithFormat:@"评论：%@",self.theWBData.commentsCount];
    commentNumber.frame = self.wbCellFrame.commentTextViewFrame;
    commentNumber.editable = NO;
    commentNumber.scrollEnabled = NO;
    commentNumber.font = [UIFont fontWithName:@"Arial" size:15];
    [self.contentView addSubview:commentNumber];
    //转发数
    UITextView *repostsNumber = [[UITextView alloc] init];
    repostsNumber.text = [NSString stringWithFormat:@"转发：%@",self.theWBData.repostsCount];
    repostsNumber.frame = self.wbCellFrame.repostTextViewFrame;
    repostsNumber.editable = NO;
    repostsNumber.scrollEnabled = NO;
    repostsNumber.font = [UIFont fontWithName:@"Arial" size:15];
    [self.contentView addSubview:repostsNumber];
    //点赞数
    UITextView *attitudeNumber = [[UITextView alloc] init];
    attitudeNumber.text = [NSString stringWithFormat:@"点赞：%@",self.theWBData.attitudesCount];
    attitudeNumber.frame = self.wbCellFrame.attitudeTextViewFrame;
    attitudeNumber.editable = NO;
    attitudeNumber.scrollEnabled = NO;
    attitudeNumber.font = [UIFont fontWithName:@"Arial" size:15];
    [self.contentView addSubview:attitudeNumber];
    
    //文字内容
    UITextView *mainTextView = [[UITextView alloc] init];
    mainTextView.frame = self.wbCellFrame.mainTextViewFrame;
    mainTextView.editable = NO;
    mainTextView.scrollEnabled = NO;
    mainTextView.delegate = self;
    NSMutableAttributedString *mainText = [[NSMutableAttributedString alloc] initWithString:self.theWBData.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} ];
    //linkTextArray用来存放text中找到的链接和链接的range
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
            NSDictionary *dic = @{@"linkText":linkText,@"range":range};
            [linkTextArray addObject:dic];
        }
    }];
    //从后往前将指定range中的文本替换为linktext
    while (linkTextArray.count > 0) {
        [mainText replaceCharactersInRange:[[[linkTextArray lastObject] valueForKey:@"range"] rangeValue] withAttributedString:[[linkTextArray lastObject] valueForKey:@"linkText"] ];
        [linkTextArray removeLastObject];
    }
    mainTextView.attributedText = mainText;
    [self.contentView addSubview:mainTextView];
    
    //收藏按钮
    CollectButton *collectButton = [[CollectButton alloc] init];
    [collectButton setImage:[UIImage imageNamed:@"collect-no.png"] forState:UIControlStateNormal];
       [collectButton setImage:[UIImage imageNamed:@"collect-yes.png"] forState:UIControlStateSelected];
    [collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    collectButton.frame = self.wbCellFrame.collectButtonFrame;
    self.collectButton = collectButton;
    //获取当前用户信息，用于获取文件目录
    UserInformation *userInformation = [[UserInformation alloc] init];
    //从文件中获取数据
    self.collectArray = [[NSMutableArray alloc] initWithContentsOfFile:userInformation.collectFilePath];
    //文件为空则创建数组
    if (!self.collectArray) {
            self.collectArray = [[NSMutableArray alloc] init];
    }
    TheWbData *wbData = self.theWBData;
    //如果数组中存在该微博，则收藏按钮状态为yes
    for (int i = 0;i<self.collectArray.count;i++) {
        NSDictionary *dic = self.collectArray[i];
        if ([wbData.creatTime isEqualToString:[dic valueForKey:@"created_at"]] && [wbData.name isEqualToString:[dic valueForKey:@"name"]]) {
            self.collectButton.selected = YES;
            }
    }
    [self.contentView addSubview:collectButton];

    //异步加载耗时的图片view
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //头像图片
        NSData *headImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.theWBData.profileImageURL]];
        UIImage *headImage = [UIImage imageWithData:headImageData];
        //回到主线程添加view
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIImageView *headImageView = [ [UIImageView alloc] initWithImage:headImage];
            headImageView.frame = self.wbCellFrame.headImageViewFrame;
            [self.contentView addSubview:headImageView];
                });

        //图片内容
        if (self.theWBData.pictureNumber.intValue == 1) {
            NSData *pictureImageData = [[NSData alloc] init];
            //根据userId切换pictureImageData的初始化形式（id=123456则说明该微博是自己发的）
            if (self.theWBData.userId.intValue == 123456) {
                pictureImageData = self.theWBData.pictureData;
            }else{
                pictureImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.theWBData.middlePictureURL] ];
            }
                UIImage *mainImage = [[UIImage alloc] initWithData:pictureImageData];
                //回到主线程对view进行操作
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.pictureImageView = [[UIImageView alloc] initWithImage:mainImage];
                    //设置imageView的contentMode属性为UIViewContentModeScaleAspectFill，能保证图片比例不变，填充整个ImageView，但可能只有部分图片显示出来
                    self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
                    self.pictureImageView.frame = self.wbCellFrame.mainImageViewFrame;
                    [self.contentView addSubview:self.pictureImageView];
                        });
        }else if (self.theWBData.pictureNumber.intValue > 1){
            //加载多图
            //存放image的数组
            NSMutableArray *imageArray = [NSMutableArray array];
            //最多加载九张图片
            if (self.theWBData.pictureNumber.intValue > 9) {
                self.theWBData.pictureNumber = @9;
            }
            //加载image并存入数组
            for (int i = 0; i < self.theWBData.pictureNumber.intValue; i++) {
                NSData *pictureImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.theWBData.pictureURLs objectAtIndex:i] valueForKey:@"thumbnail_pic"] ] ];
                UIImage *image = [[UIImage alloc] initWithData:pictureImageData];
                //image加载失败的时候显示加载失败的图标
                if (!image) {
                    image = [UIImage imageNamed:@"loadFail"];
                }
                [imageArray addObject:image];
            }
            //加载完image切回主线程更新UI
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (self.wbCellFrame.picturesFrameArray.count > 1) {
                    for (int j = 0; j < self.theWBData.pictureNumber.intValue; j++) {
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:[imageArray objectAtIndex:j] ];
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        imageView.clipsToBounds = YES;
                        imageView.frame =
                        [[self.wbCellFrame.picturesFrameArray objectAtIndex:j] CGRectValue];
                        [self.contentView addSubview:imageView];
                    }
                }
            });
        }
    });
}



#pragma mark - ButtonMethod
- (void)collectButtonClick:(UIButton *)button
{
    //获取当前用户信息，用于获取文件目录
    UserInformation *userInformation = [[UserInformation alloc] init];
    //从文件中获取数据
    self.collectArray = [[NSMutableArray alloc] initWithContentsOfFile:userInformation.collectFilePath];
    //文件为空则创建数组
    if (!self.collectArray) {
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
        //因为进入这个方法的时候就已经把这条微博删除了，所以这里啥都不用做
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
    [_delegate performSelector:@selector(openLinkText:) withObject:URL];
    return NO;
}

@end
