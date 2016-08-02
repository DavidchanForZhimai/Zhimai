




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/




#import "CellLayout.h"
#import "LWTextParser.h"
#import "Gallop.h"
#import "NSString+Extend.h"
#import "Parameter.h"
@implementation CellLayout

- (id)initWithStatusModel:(StatusDatas *)statusModel
                    index:(NSInteger)index isDetail:(BOOL)isDetail{
    self = [super init];
    if (self) {
        self.statusModel = statusModel;
        //头像模型 avatarImageStorage
        LWImageStorage* avatarStorage = [[LWImageStorage alloc] initWithIdentifier:@"avatar"];
        avatarStorage.contents = statusModel.imgurl;
        avatarStorage.placeholder = [UIImage imageNamed:@"defaulthead"];
            if ([statusModel.imgurl isEqualToString:ImageURLS]) {
          
            if (statusModel.sex==1) {
               avatarStorage.contents = [UIImage imageNamed:@"defaulthead"];
            }
            else
            {
                avatarStorage.contents = [UIImage imageNamed:@"defaulthead_nv"];
                
            }
        }
       
        avatarStorage.cornerRadius = 20.0f;
        avatarStorage.cornerBackgroundColor = [UIColor whiteColor];
        avatarStorage.backgroundColor = [UIColor whiteColor];
        avatarStorage.frame = CGRectMake(10, 10, 40, 40);
        avatarStorage.tag = 9;
        avatarStorage.cornerBorderWidth = 1.0f;
        avatarStorage.cornerBorderColor = LineBg;
       
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = statusModel.realname;
        nameTextStorage.font = Size(28.0);
        nameTextStorage.frame = CGRectMake(avatarStorage.right + 6, 15.0f, SCREEN_WIDTH - (avatarStorage.right + 6 + 30), CGFLOAT_MAX);
        [nameTextStorage lw_addLinkWithData:[NSString stringWithFormat:@"%@",statusModel.realname]
                                      range:NSMakeRange(0,statusModel.realname.length)
                                  linkColor:BlackTitleColor
                             highLightColor:BlackTitleColor];
       
        [LWTextParser parseEmojiWithTextStorage:nameTextStorage];
        
        //更多操作
        LWImageStorage* moreStorage = [[LWImageStorage alloc] initWithIdentifier:@"more"];
        moreStorage.tag = 30;
        moreStorage.contents = [UIImage imageNamed:@"dongtai_gengduo"];
        moreStorage.frame = CGRectMake(APPWIDTH - 30, 10, 16, 16);
        
    
        //行业
        LWTextStorage* industryTextStorage = [[LWTextStorage alloc] init];
        
        industryTextStorage.text = [Parameter industryForChinese: statusModel.industry];
        industryTextStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        industryTextStorage.font = Size(24.0);
        industryTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom + 8, nameTextStorage.width, CGFLOAT_MAX);
        
        //正文内容模型 contentTextStorage
        LWTextStorage* contentTextStorage = [[LWTextStorage alloc] init];
        contentTextStorage.text = statusModel.content;
        contentTextStorage.font = Size(26.0);
        contentTextStorage.textColor = [UIColor colorWithRed:0.1294 green:0.1333 blue:0.1333 alpha:1.0];
        contentTextStorage.frame = CGRectMake(industryTextStorage.left, industryTextStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
        [LWTextParser parseEmojiWithTextStorage:contentTextStorage];
        [LWTextParser parseTopicWithLWTextStorage:contentTextStorage
                                        linkColor:RGB(113, 129, 161, 1)
                                   highlightColor:RGB(0, 0, 0, 0.15)];
        //发布的图片模型 imgsStorage
        CGFloat imageWidth = (SCREEN_WIDTH - 100.0f)/3.0f;
        NSInteger imageCount = [statusModel.pic count];
        NSMutableArray* imageStorageArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
        NSMutableArray* imagePositionArray = [[NSMutableArray alloc] initWithCapacity:imageCount];
       
        if ([self.statusModel.type isEqualToString:@"image"]) {
            NSInteger row = 0;
            NSInteger column = 0;
            if (imageCount == 1) {
                CGRect imageRect = CGRectMake(nameTextStorage.left,
                                              contentTextStorage.bottom + 10.0 + (row * (imageWidth + 7.5f)),
                                              imageWidth*1.7,
                                              imageWidth*1.7);
                NSString* imagePositionString = NSStringFromCGRect(imageRect);
                [imagePositionArray addObject:imagePositionString];
                LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
                imageStorage.tag = 0;
                imageStorage.clipsToBounds = YES;
                imageStorage.frame = imageRect;
                imageStorage.backgroundColor = RGB(240, 240, 240, 1);
                StatusPic *pic = [statusModel.pic objectAtIndex:0];
                NSString* URLString = pic.imgurl;
                imageStorage.contents = [NSURL URLWithString:URLString];
                [imageStorageArray addObject:imageStorage];
            } else {
                for (NSInteger i = 0; i < imageCount; i ++) {
                    CGRect imageRect = CGRectMake(nameTextStorage.left + (column * (imageWidth + 7.5f)),
                                                  contentTextStorage.bottom + 7.5f + (row * (imageWidth + 7.5f)),
                                                  imageWidth,
                                                  imageWidth);
                    NSString* imagePositionString = NSStringFromCGRect(imageRect);
                    [imagePositionArray addObject:imagePositionString];
                    LWImageStorage* imageStorage = [[LWImageStorage alloc] initWithIdentifier:@"image"];
                    imageStorage.clipsToBounds = YES;
                    imageStorage.tag = i;
                    imageStorage.frame = imageRect;
                    imageStorage.backgroundColor = RGB(240, 240, 240, 1);
                    StatusPic *pic = [statusModel.pic objectAtIndex:i];
                    NSString* URLString = pic.imgurl;
                    imageStorage.contents = [NSURL URLWithString:URLString];
                    [imageStorageArray addObject:imageStorage];
                    column = column + 1;
                    if (column > 2) {
                        column = 0;
                        row = row + 1;
                    }
                }
            }
            
        }
        else if ([self.statusModel.type isEqualToString:@"website"]) {
            self.websiteRect = CGRectMake(nameTextStorage.left,contentTextStorage.bottom + 5.0f,SCREEN_WIDTH - 80.0f,60.0f);
            LWImageStorage* imageStorage = [[LWImageStorage alloc] init];
            StatusPic *pic = [statusModel.pic objectAtIndex:0];
            NSString* URLString = pic.imgurl;
            imageStorage.contents = [NSURL URLWithString:URLString];
            imageStorage.clipsToBounds = YES;
            imageStorage.frame = CGRectMake(nameTextStorage.left + 5.0f, contentTextStorage.bottom + 10.0f , 50.0f, 50.0f);
            [imageStorageArray addObject:imageStorage];
            
            LWTextStorage* detailTextStorage = [[LWTextStorage alloc] init];
            detailTextStorage.text = statusModel.content;
            detailTextStorage.font = [UIFont fontWithName:@"Heiti SC" size:12.0f];
            detailTextStorage.textColor = RGB(40, 40, 40, 1);
            detailTextStorage.frame = CGRectMake(imageStorage.right + 10.0f, contentTextStorage.bottom + 10.0f, SCREEN_WIDTH - 150.0f, 60.0f);
            detailTextStorage.linespacing = 0.5f;
            [detailTextStorage lw_addLinkForWholeTextStorageWithData:@"https://github.com/waynezxcv/LWAlchemy" linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
            [self addStorage:detailTextStorage];
        }
        else if ([self.statusModel.type isEqualToString:@"video"]) {

        }
        
       
        
        //获取最后一张图片的模型
        LWImageStorage* lastImageStorage = (LWImageStorage *)[imageStorageArray lastObject];
        //生成时间的模型 dateTextStorage
        LWTextStorage* dateTextStorage = [[LWTextStorage alloc] init];
        dateTextStorage.text = [statusModel.createtime updateTime];
    
        dateTextStorage.font = Size(22);
        dateTextStorage.textColor = [UIColor colorWithRed:0.7216 green:0.7294 blue:0.7333 alpha:1.0];
        
        
        //菜单按钮
        CGRect menuPosition;
        if (![self.statusModel.type isEqualToString:@"video"]) {
            menuPosition = CGRectMake(SCREEN_WIDTH - 54.0f,10.0f + contentTextStorage.bottom  - 14.5f ,44,44);
            dateTextStorage.frame = CGRectMake(nameTextStorage.left, contentTextStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);
            
            if (lastImageStorage) {
                menuPosition = CGRectMake(SCREEN_WIDTH - 54.0f,10.0f + lastImageStorage.bottom - 14.5f,44,44);
                dateTextStorage.frame = CGRectMake(nameTextStorage.left, lastImageStorage.bottom + 10.0f, SCREEN_WIDTH - 80.0f, CGFLOAT_MAX);

            }
             self.lineRect = CGRectMake(0, dateTextStorage.bottom + 10.0f,  SCREEN_WIDTH, 1.0f);
        }
        else {
            //TODO：
        }
        //评论位置
        UIImage *commentImage = [UIImage imageNamed:@"dongtai_pinglun"];
        NSString *commentStr = [NSString stringWithFormat:@"%ld评论",statusModel.comment.count];
        CGSize commentsize = [commentStr sizeWithFont:Size(22) maxSize:CGSizeMake(100, 22*SpacedFonts)];
    
        self.commentPosition = frame(APPWIDTH - 15 - commentImage.size.width - commentsize.width,dateTextStorage.top, commentImage.size.width + commentsize.width + 5, 16);
        //点赞位置
        UIImage *priseImage = [UIImage imageNamed:@"dongtai_dianzan_normal"];
        NSString *priseStr = [NSString stringWithFormat:@"%ld赞",statusModel.like.count];
        CGSize prisesize = [priseStr sizeWithFont:Size(22) maxSize:CGSizeMake(100, 22*SpacedFonts)];
         self.prisePosition = frame(self.commentPosition.origin.x - 25 - priseImage.size.width - prisesize.width,dateTextStorage.top, priseImage.size.width + prisesize.width + 5, 16);
        
        //生成评论背景Storage
        LWImageStorage* commentBgStorage = [[LWImageStorage alloc] init];
        NSArray* commentTextStorages = @[];
        CGRect commentBgPosition = CGRectZero;
        CGRect rect = CGRectMake(nameTextStorage.left - 23,dateTextStorage.bottom + 5.0f, SCREEN_WIDTH - 80, 20);
        CGFloat offsetY = 0.0f;
        //点赞
        LWImageStorage* likeImageSotrage = [[LWImageStorage alloc] init];
        LWImageStorage* moreImageSotrage = [[LWImageStorage alloc] init];
        NSInteger priseCount = [statusModel.like count];
        NSMutableArray* priseStorageArray = [[NSMutableArray alloc] initWithCapacity:priseCount];
        NSMutableArray* prisePositionArray = [[NSMutableArray alloc] initWithCapacity:priseCount];
        if (self.statusModel.like.count != 0) {
            likeImageSotrage.contents = [UIImage imageNamed:@"dongtai_dianzan_pressed"];
            likeImageSotrage.frame = CGRectMake(rect.origin.x,rect.origin.y + 20.0 + offsetY,16.0, 16.0);
            CGFloat priseWidth = 27.0;
            NSInteger count = 0;
            if (priseCount<3) {
                count =priseCount;
            }
            else
            {
                 count =3;
                 moreImageSotrage.tag = 20;//更多
                 moreImageSotrage.contents = [UIImage imageNamed:@"dongtai_gengduozan"];
                 moreImageSotrage.frame = CGRectMake(nameTextStorage.left + (3 * (priseWidth + 8.0)),likeImageSotrage.top,16.0, 16.0);

        
            }
            for (int i =0; i<count; i++) {
              
                CGRect priseRect = CGRectMake(nameTextStorage.left + (i * (priseWidth + 7.5f)),
                                              likeImageSotrage.top - 6.0,
                                              priseWidth,
                                              priseWidth);
                NSString* prisePositionString = NSStringFromCGRect(priseRect);
                [prisePositionArray addObject:prisePositionString];
                LWImageStorage* priseStorage = [[LWImageStorage alloc] initWithIdentifier:@"prise"];
                priseStorage.cornerBackgroundColor = [UIColor whiteColor];
                priseStorage.backgroundColor = [UIColor whiteColor];
                priseStorage.tag = 10+i;
                priseStorage.cornerBorderWidth = 1.0f;
                priseStorage.cornerBorderColor = [UIColor whiteColor];
                priseStorage.cornerRadius =27.0/2.0;
                priseStorage.frame = priseRect;
                StatusLike *like = [statusModel.like objectAtIndex:i];
              
                priseStorage.placeholder = [UIImage imageNamed:@"defaulthead"];
                if ([like.imgurl isEqualToString:ImageURLS]) {
                    
                    if (statusModel.sex==1) {
                        priseStorage.contents = [UIImage imageNamed:@"defaulthead"];
                    }
                    else
                    {
                        priseStorage.contents = [UIImage imageNamed:@"defaulthead_nv"];
                        
                    }
                }
    
                priseStorage.contents = like.imgurl;
                [priseStorageArray addObject:priseStorage];
                
                
            }
            offsetY += priseWidth;
            
        }
        if (statusModel.comment.count != 0 && statusModel.comment != nil) {
          
        
            NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:statusModel.comment.count];
            for (StatusComment* commentDict in statusModel.comment) {
                NSString* to = commentDict.info.rep_realname;
                if (to.length != 0) {
                    NSString* commentString = [NSString stringWithFormat:@"%@回复%@:%@",commentDict.info.realname,to,commentDict.info.content];
                    LWTextStorage* commentTextStorage = [[LWTextStorage alloc] init];
                    commentTextStorage.text = commentString;
                    commentTextStorage.font = Size(26.0f);
                    commentTextStorage.textColor = [UIColor colorWithRed:0.3059 green:0.3098 blue:0.3137 alpha:1.0];
                    commentTextStorage.frame = CGRectMake(rect.origin.x, rect.origin.y + 20.0f + offsetY,nameTextStorage.width + 24, CGFLOAT_MAX);
                    
                    StatusComment* commentModel1 = [[StatusComment alloc] init];
                    commentModel1.info.rep_realname = commentDict.info.realname;
                    commentModel1.info.index = index;
                    [commentTextStorage lw_addLinkForWholeTextStorageWithData:commentModel1 linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
                    
                    [commentTextStorage lw_addLinkWithData:commentModel1
                                                     range:NSMakeRange(0,[(NSString *)commentDict.info.realname length])
                                                 linkColor:AppMainColor
                                            highLightColor:AppMainColor];
                    
                    StatusComment* commentModel2 = [[StatusComment alloc] init];
                    commentModel2.info.rep_realname = commentDict.info.rep_realname;
                    commentModel2.info.index = index;
                    [commentTextStorage lw_addLinkWithData:commentModel2
                                                     range:NSMakeRange([(NSString *)commentDict.info.realname length] + 2,[(NSString *)commentDict.info.rep_realname length])
                                                 linkColor:AppMainColor
                                            highLightColor:AppMainColor];
                    
                    [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                    linkColor:AppMainColor
                                               highlightColor:AppMainColor];
                    [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                    [tmp addObject:commentTextStorage];
                    offsetY += commentTextStorage.height + 5;
                } else {
                    NSString* commentString = [NSString stringWithFormat:@"%@:%@",commentDict.info.realname,commentDict.info.content];
                    LWTextStorage* commentTextStorage = [[LWTextStorage alloc] init];
                    commentTextStorage.text = commentString;
                    commentTextStorage.font = Size(26.0f);
                    commentTextStorage.textColor = [UIColor colorWithRed:0.3059 green:0.3098 blue:0.3137 alpha:1.0];
                    commentTextStorage.textAlignment = NSTextAlignmentLeft;
                    commentTextStorage.linespacing = 2.0f;
                    commentTextStorage.frame = CGRectMake(rect.origin.x, rect.origin.y + 20.0f + offsetY,nameTextStorage.width + 24, CGFLOAT_MAX);
                    
                    StatusComment* commentModel = [[StatusComment alloc] init];
                    commentModel.info.rep_realname = commentDict.info.realname;
                    commentModel.info.index = index;
                    [commentTextStorage lw_addLinkForWholeTextStorageWithData:commentModel linkColor:nil highLightColor:RGB(0, 0, 0, 0.15)];
                    [commentTextStorage lw_addLinkWithData:commentModel
                                                     range:NSMakeRange(0,[(NSString *)commentDict.info.realname length])
                                                 linkColor:AppMainColor
                                            highLightColor:AppMainColor];
                    
                    [LWTextParser parseTopicWithLWTextStorage:commentTextStorage
                                                    linkColor:AppMainColor
                                               highlightColor:AppMainColor];
                    [LWTextParser parseEmojiWithTextStorage:commentTextStorage];
                    [tmp addObject:commentTextStorage];
                    offsetY += commentTextStorage.height + 5;
                }
            }
            //如果有评论，设置评论背景Storage
            commentTextStorages = tmp;
            commentBgPosition = CGRectMake(60.0f,dateTextStorage.bottom + 5.0f, SCREEN_WIDTH - 80, offsetY + 15.0f);
            commentBgStorage.frame = commentBgPosition;
            commentBgStorage.contents = [UIImage imageNamed:@"comment"];
            [commentBgStorage stretchableImageWithLeftCapWidth:40 topCapHeight:15];
        }
        [self addStorage:nameTextStorage];
        [self addStorage:industryTextStorage];
        [self addStorage:moreStorage];
        [self addStorage:contentTextStorage];
        [self addStorage:dateTextStorage];
        [self addStorages:commentTextStorages];
        [self addStorage:avatarStorage];
        [self addStorage:commentBgStorage];
        
        [self addStorages:imageStorageArray];
        if (priseStorageArray) {
            [self addStorages:priseStorageArray];
            [self addStorage:likeImageSotrage];
            [self addStorage:moreImageSotrage];
        }
        //一些其他属性
//        self.menuPosition = menuPosition;
        self.commentBgPosition = commentBgPosition;
        self.imagePostionArray = imagePositionArray;
        self.prisePostionArray = prisePositionArray;
        self.statusModel = statusModel;
        //如果是使用在UITableViewCell上面，可以通过以下方法快速的得到Cell的高度
        
        self.cellHeight = [self suggestHeightWithBottomMargin:20.0f];
        self.cellMarginsRect = frame(0, self.cellHeight - 10, APPWIDTH, 10);
    }
    return self;
}

@end
