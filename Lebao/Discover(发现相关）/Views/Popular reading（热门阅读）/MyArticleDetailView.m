//
//  MyArticleDetailView.m
//  Lebao
//
//  Created by David on 16/3/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyArticleDetailView.h"
#import "XLDataService.h"
//工具类
#import "ToolManager.h"
#import "BaseButton.h"
#import "UILabel+Extend.h"
#import "NSString+Extend.h"
@implementation MyArticleDetailView

- (instancetype)initWithFrame:(CGRect)frame postWithUrl:(NSString*)postWithUrl param:(NSMutableDictionary*)param
{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor  whiteColor];
        _postWithUrl = postWithUrl;
        _param = param;
        _ishasNextPage = YES;
        [self addMainView:_param];
    }
    return self;
}
- (void)addMainView:(NSDictionary *)parame
{
    for (UIView *suView in self.subviews) {
        
        [suView removeFromSuperview];
    }
    __weak MyArticleDetailView *weakSelf =self;
//    NSLog(@"parame =%@ _postWithUrl=%@",parame,_postWithUrl);
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService postWithUrl:_postWithUrl param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        NSLog(@"data =%@",dataObj);
        if (dataObj) {
             [[ToolManager shareInstance] dismiss];
            modal = [MyArticleDetailModal mj_objectWithKeyValues:dataObj];
            
            weakSelf.webView = allocAndInitWithFrame(IMYWebView, CGRectZero);
            weakSelf.webView.backgroundColor = WhiteColor;
            weakSelf.webView.delegate = self;
            weakSelf.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            weakSelf.webView.scrollView.scrollEnabled = NO;
            [weakSelf.webView setScalesPageToFit:YES];
            [self addSubview:weakSelf.webView];
            
            if (modal.rtcode ==1) {
            
                if (weakSelf.contributionBlock) {
                    weakSelf.contributionBlock(modal.datas.islibrary);
                }
                if (weakSelf.modalBlock) {
                    weakSelf.modalBlock(modal);
                }
                
                float _descripW;
                if (_isEdit) {
                    _descripW = APPWIDTH - 90;
                    BaseButton *edit = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 70, 10, 60, 30) setTitle:@"编辑" titleSize:28*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:self];
                    [edit setRadius:15];
                    edit.didClickBtnBlock = ^{
                        
                        if (_editBlock) {
                            _editBlock(modal);
                        }
                        
                    };
                }
                else
                {
                    _descripW = APPWIDTH - 20;
                }
                UILabel * _descrip= [UILabel createLabelWithFrame:frame( 10, 10, _descripW, 30) text:@"" fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
                _descrip.numberOfLines = 0;
                _descrip.text = modal.datas.title;
                
                
                CGSize size =[_descrip sizeWithMultiLineContent:_descrip.text rowWidth:frameWidth(_descrip) font:[UIFont systemFontOfSize:26*SpacedFonts]];
                _descrip.frame = frame(frameX(_descrip),frameY(_descrip), frameWidth(_descrip), size.height);
                UIImage *imagetime =[UIImage imageNamed:@"exhibition_time"];
                UILabel *time =allocAndInit(UILabel);
                CGSize sizeTime = [time sizeWithContent:@"2015 - 12 - 31" font:[UIFont systemFontOfSize:22*SpacedFonts]];
                
                NSString *times =modal.datas.createtime;
                
                BaseButton* _time = [[BaseButton alloc]initWithFrame:frame(frameX(_descrip), size.height + 15 , imagetime.size.width + 5 + sizeTime.width, imagetime.size.height-2)  setTitle:[times timeformatString:@"yyyy-MM-dd"]titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:imagetime highlightImage:nil setTitleOrgin:CGPointMake(0,5) setImageOrgin:CGPointMake(0,0)  inView:self];
                _time.shouldAnmial = NO;
                
                
                UIImage *image =[UIImage imageNamed:@"exhibition_brose"];
                CGSize sizebrowse = [time sizeWithContent:modal.datas.readnum font:[UIFont systemFontOfSize:22*SpacedFonts]];
                
                BaseButton* _browse = [[BaseButton alloc]initWithFrame:frame(CGRectGetMaxX(_time.frame) + 10, frameY(_time), image.size.width + 5 + sizebrowse.width, image.size.height)  setTitle:modal.datas.readnum titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:image highlightImage:nil setTitleOrgin:CGPointMake(1,5) setImageOrgin:CGPointMake(0,0)  inView:self];
                _browse.shouldAnmial = NO;
                
                [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_browse.frame) + 20, frameY(_browse) - 2, 100, frameHeight(_browse)) text:[NSString stringWithFormat:@"来源：%@",modal.datas.author] fontSize:22*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
                
                float height =CGRectGetMaxY(_browse.frame)  +10 ;
                if (modal.datas.isaddress) {
                    
                    
                    UIView *bg = allocAndInitWithFrame(UIView, frame(0, height, APPWIDTH, 70));
                    bg.backgroundColor = AppViewBGColor;
                    [self addSubview:bg];
                    
                    UIView *bg1 = allocAndInitWithFrame(UIView, frame(10, 10, APPWIDTH - 20, 50));
                    bg1.backgroundColor = WhiteColor;
                    [bg addSubview:bg1];
                    
                    UILabel *line1 = allocAndInitWithFrame(UILabel, frame(0, 0, 2, frameHeight(bg1)));
                    line1.backgroundColor = AppMainColor;
                    [bg1 addSubview:line1];
                    
                    UIImageView *icon = allocAndInitWithFrame(UIImageView, frame(10, 5, 40, 40));
                   
                    [[ToolManager shareInstance] imageView:icon setImageWithURL:modal.datas.isaddress_imgurl placeholderType:PlaceholderTypeUserHead];
                    
                    
                    [icon setRadius:frameHeight(icon)/2.0];
                    [bg1 addSubview:icon];
                    
                    UILabel *name = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(icon.frame) +7, 14, 0, 26*SpacedFonts) text:modal.datas.isaddress_name fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:bg1];
                    
                    CGSize sizeName = [name sizeWithContent:name.text font:[UIFont systemFontOfSize:26*SpacedFonts]];
                    name.frame = frame(frameX(name), frameY(name), sizeName.width, frameHeight(name));
                    
                    [UILabel createLabelWithFrame:frame(CGRectGetMaxX(name.frame) +5, frameY(name), 200, 26*SpacedFonts) text:modal.datas.isaddress_add fontSize:22*SpacedFonts textColor:lightGrayTitleColor textAlignment:NSTextAlignmentLeft inView:bg1];
                    
                    [UILabel createLabelWithFrame:frame(frameX(name), CGRectGetMaxY(name.frame) + 5, 100, 26*SpacedFonts) text:modal.datas.isaddress_tel fontSize:24*SpacedFonts textColor:lightGrayTitleColor textAlignment:NSTextAlignmentLeft inView:bg1];
                    
                    height += 70;
                }
                else
                {
                    UILabel *line1 = allocAndInitWithFrame(UILabel, frame(10, CGRectGetMaxY(_browse.frame)  + 6, APPWIDTH - 20, 1.0));
                    line1.backgroundColor = LineBg;
                    [self addSubview:line1];
                    
                }
                
                weakSelf.webView.frame= frame(5, height, APPWIDTH -10, 0);
                
                [weakSelf.webView loadHTMLString:modal.datas.content baseURL:nil];
                
            }
            else
            {
                [weakSelf.webView loadHTMLString:[NSString stringWithFormat:@"<p>%@</p>",modal.rtmsg] baseURL:nil];
                
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        

        
        
    }];
    
}
#pragma mark - UIWebview delegete

- (void)webViewDidFinishLoad:(IMYWebView *)webView
{
    [self webViewFitToScale:webView];
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id objc, NSError * error) {
        CGFloat height = [objc floatValue];
        if (!error) {
            BaseButton *next;
            if (_ishasNextPage) {
                 height +=50;
               next = [[BaseButton alloc]initWithFrame:frame(0, self.contentSize.height - 50, APPWIDTH, 50) setTitle:@"点击下一篇" titleSize:24*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:self];
                
                __weak MyArticleDetailView *weakSelf =self;
                next.didClickBtnBlock = ^
                {
                    if ([modal.datas.next_acid intValue]==0) {
                        [[ToolManager shareInstance] showInfoWithStatus:@"没有下一篇了"];
                        return ;
                    }
                    [weakSelf setContentOffset:CGPointMake(0, 0) animated:YES];
                    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
                    [parame setObject:@"next" forKey:Conduct];
                    [parame setObject:modal.datas.next_acid forKey:ConductID];
                    
                    [weakSelf addMainView:parame];
                    
                };
               
            }
           
            CGRect frame = webView.frame;
            webView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
            if (modal.datas.isaddress) {
                self.contentSize = CGSizeMake(frameWidth(self), 140 + height);
                
            }
            else
            {
                self.contentSize = CGSizeMake(frameWidth(self), 70 + height);
                
            }
           
            
            if (modal.datas.productpics&&![modal.datas.productpics isEqualToString:@""]) {
                
                NSArray *images = [modal.datas.productpics componentsSeparatedByString:@","];
              
                for (int i = 0; i<images.count; i++) {
                    UIImageView *imageView = allocAndInitWithFrame(UIImageView, frame(5,self.contentSize.height + APPWIDTH *i, (APPWIDTH - 10), (APPWIDTH - 10)));
                    [[ToolManager shareInstance] imageView:imageView setImageWithURL:images[i] placeholderType:PlaceholderTypeImageUnProcessing];
                    [self addSubview:imageView];
                    
                }
                self.contentSize = CGSizeMake(frameWidth(self), self.contentSize.height + APPWIDTH*images.count);
            }
            
            next.frame = frame(0, self.contentSize.height - 50, APPWIDTH, 50);
            
        }
    }];
    
}
//结合JS解决用webVIew加载图片时图片自动适配屏幕的问题
- (void)webViewFitToScale:(IMYWebView *)webView
{
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [webView evaluateJavaScript:js completionHandler:^(id objc, NSError *error) {
        
    }];
    [webView evaluateJavaScript:@"ResizeImages();" completionHandler:^(id objc, NSError *error) {
        
    }];
    
}
@end
