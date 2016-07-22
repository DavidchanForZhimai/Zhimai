//
//  WBHomePageVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/11.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "WBHomePageVC.h"
#import "XSCell.h"
#import "JJRCell.h"
#import "MJRefresh.h"
#import "JJRDetailVC.h"
#import "XianSuoDetailVC.h"
#import "JingJiRenVC.h"
#import "AppDelegate.h"
#import "MyXSDetailVC.h"
#import "MyLQDetailVC.h" 
#import "ToolManager.h"
#import "CoreArchive.h"
#import "CALayer+Transition.h"
#import "ViewController.h"//选择地址
#import "LoCationManager.h"
#define xsTabTag  110
#define jjrTabTag 120
@interface WBHomePageVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIScrollView * buttomScr;
    UIButton * xsBtn;
    UIButton * jjrBtn;
    UIView * xhxV;
    int xspageNumb;
    int jjrpageNumb;
}
@property (strong,nonatomic)NSMutableArray * xsJsonArr;
@property (strong,nonatomic)NSMutableArray * jjrJsonArr;
@property (strong,nonatomic)UITableView *xsTab;
@property (strong,nonatomic)UITableView *jjrTab;

@property (strong,nonatomic)BaseButton  *selectedIndustryBg;
@property (strong,nonatomic)NSString  *hyStr;
@property (strong,nonatomic) BaseButton *selectedBtn;
@end

@implementation WBHomePageVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([CoreArchive strForKey:@"isread"]) {
       [self.homePageBtn setImage:[UIImage imageNamed:@"icon_dicover_me_selected"] forState:UIControlStateNormal];
    }
    else
    {
        [self.homePageBtn setImage:[UIImage imageNamed:@"icon_dicover_me"] forState:UIControlStateNormal];
    }
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabbarIndex:0];
    [self navViewTitle:@""];
    [self navLeftAddressBtn];
    
    self.homePageBtn.hidden = NO;
    [self.view addSubview:self.homePageBtn];
    
    xspageNumb = 1;
    jjrpageNumb = 1;
    _xsJsonArr = [[NSMutableArray alloc]init];
    _jjrJsonArr = [[NSMutableArray alloc]init];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0.941 alpha:1.000];
    [self addTheBtnView];
    [self setButtomScr];
    [self getxsJson];
    [self getjjrJson];
    
    //新版本提示
    [[ToolManager shareInstance]update];
    //选择行业
    [self selectIndustry];
    UIImage *upImage =[UIImage imageNamed:@"exhibition_up"];
    _selectedBtn =[[BaseButton alloc]initWithFrame:frame((APPWIDTH - (64*SpacedFonts + 5 + upImage.size.width))/2.0, StatusBarHeight, 64*SpacedFonts + 5 + upImage.size.width, NavigationBarHeight)  setTitle:@"全部" titleSize:34*SpacedFonts titleColor:BlackTitleColor backgroundImage:nil iconImage:upImage highlightImage:nil setTitleOrgin:CGPointMake((NavigationBarHeight - 34*SpacedFonts)/2.0,-upImage.size.width ) setImageOrgin:CGPointMake((NavigationBarHeight - upImage.size.height)/2.0,64*SpacedFonts + 5) inView:self.view];
     __weak WBHomePageVC *weakSelf =self;
    _selectedBtn.shouldAnmial = NO;
    _selectedBtn.didClickBtnBlock = ^
    {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.selectedIndustryBg.hidden = !weakSelf.selectedIndustryBg.hidden;
        }];

        
    };
    
    
    
//    [[LoCationManager shareInstance]getLatitudeAndLongitude];
    
    
}


//选择地址
- (void)navLeftAddressBtn
{
    if (![CoreArchive strForKey:AddressID]) {
        [CoreArchive setStr:@"全国" key:LocationAddress];
        [CoreArchive setStr:@"0" key:AddressID];
     
    }
    UIImage *upImage =[UIImage imageNamed:@"exhibition_up"];
    UILabel *lbUp = allocAndInit(UILabel);
    CGSize sizeUp = [lbUp sizeWithContent:[CoreArchive strForKey:LocationAddress] font:[UIFont systemFontOfSize:28*SpacedFonts]];
    float sizeW = sizeUp.width;
    if (sizeUp.width>=140*SpacedFonts) {
        sizeW = 160*SpacedFonts;
    }
    _selectedAddress  =[[BaseButton alloc]initWithFrame:frame(0, StatusBarHeight, sizeW + 15 + upImage.size.width, NavigationBarHeight) setTitle:[CoreArchive strForKey:LocationAddress] titleSize:28*SpacedFonts titleColor:BlackTitleColor backgroundImage:nil iconImage:upImage highlightImage:nil setTitleOrgin:CGPointMake( (NavigationBarHeight -28*SpacedFonts)/2.0 ,10-(upImage.size.width)) setImageOrgin:CGPointMake((NavigationBarHeight - upImage.size.height)/2.0,sizeW + 15) inView:self.view];
    __weak WBHomePageVC *weakSelf =self;
    _selectedAddress.didClickBtnBlock =^
    {
        ViewController *vc=[[ViewController alloc]init];
        
        [vc returnText:^(NSString *cityname,NSString *cityID) {
        
            [weakSelf.selectedAddress setTitle:cityname forState:UIControlStateNormal];
            [weakSelf resetSeletedAddressFrame];
            
            xspageNumb = 1;
            jjrpageNumb = 1;
            if (weakSelf.xsJsonArr.count >0) {
                [weakSelf.xsJsonArr removeAllObjects];
            }
            if (weakSelf.jjrJsonArr.count >0) {
                [weakSelf.jjrJsonArr removeAllObjects];
            }
            [weakSelf.xsTab reloadData];
            [weakSelf.jjrTab reloadData];
            [weakSelf getxsJson];
            [weakSelf getjjrJson];
            
        }];
        
        [weakSelf.navigationController pushViewController:vc animated:NO];
    };
    
    
    
}
//选择行业
- (void)selectIndustry
{
   
    _selectedIndustryBg = [[BaseButton alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT -(StatusBarHeight + NavigationBarHeight + TabBarHeight) ) setTitle:nil titleSize:0 titleColor:WhiteColor textAlignment:0 backgroundColor: rgba(0, 0, 0, 0.3) inView:self.view];
    _selectedIndustryBg.hidden = YES;
    __weak typeof(self) weakSelf =self;
    _selectedIndustryBg.didClickBtnBlock = ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.selectedIndustryBg.hidden = !weakSelf.selectedIndustryBg.hidden;
        }];
        
        
        
    };
    //四个行业
    UIView *hangye = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_selectedIndustryBg), 60));
    hangye.backgroundColor = WhiteColor;
    [_selectedIndustryBg addSubview:hangye];
    NSMutableArray *arrayHY =[NSMutableArray arrayWithObjects:@"保险",@"金融",@"房产",@"车行", nil];
    float hangyeBtnW = (APPWIDTH - 75)/4.0;
    float hangyeBtnH = 30;
    float hangyeBtnX = 15;
    float hangyeBtnY = 15;
    NSMutableArray *hangyeBtns = allocAndInit(NSMutableArray);
    for (int i =0; i<arrayHY.count; i++) {
        
        BaseButton *hangyeBtn = [[BaseButton alloc]initWithFrame:frame(hangyeBtnX +( hangyeBtnW + hangyeBtnX)*i , hangyeBtnY, hangyeBtnW, hangyeBtnH) setTitle:arrayHY[i] titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:hangye];
        [hangyeBtn setRoundWithfloat:2];
        [hangyeBtn setBorder:LineBg width:0.5];
        
       hangyeBtn.didClickBtnBlock = ^
        {
            [UIView animateWithDuration:0.5 animations:^{
            weakSelf.selectedIndustryBg.hidden = YES;
            }];
            
            
            if (![weakSelf.hyStr isEqualToString:@"全部"]) {
                weakSelf.hyStr = arrayHY[i];
            }
            else
            {
                weakSelf.hyStr = @"";
            }
            
            
            [arrayHY addObject:[weakSelf.selectedBtn titleForState:UIControlStateNormal]];
            
            [weakSelf.selectedBtn setTitle:arrayHY[i] forState:UIControlStateNormal];
            
            [arrayHY removeObject:[weakSelf.selectedBtn titleForState:UIControlStateNormal]];
            
            if ([arrayHY containsObject:@"全部"]) {
                [arrayHY removeObject:@"全部"];
                [arrayHY insertObject:@"全部" atIndex:0];
            }
            
            for (int i = 0;i<arrayHY.count;i++) {
                BaseButton *btn = hangyeBtns[i];
                [btn setTitle:arrayHY[i] forState:UIControlStateNormal];
            }
           
            xspageNumb = 1;
            if (_xsJsonArr.count >0) {
            [_xsJsonArr removeAllObjects];
            }
            [_xsTab reloadData];
            
            [self getxsJson];
            
            jjrpageNumb = 1;
               if (_jjrJsonArr.count >0) {
                    [_jjrJsonArr removeAllObjects];
            }
            [_jjrTab reloadData];

            [self getjjrJson];
            
            
        };
        
        [hangyeBtns addObject:hangyeBtn];
    }
    
}
//选择地址重新设置frame
- (void)resetSeletedAddressFrame
{
    UILabel *lbUp =allocAndInit(UILabel);
    UIImage *upImage =[UIImage imageNamed:@"exhibition_up"];
    CGSize sizeUp = [lbUp sizeWithContent:[CoreArchive strForKey:LocationAddress] font:Size(28)];
    float sizeW = sizeUp.width;
    if (sizeUp.width>=140*SpacedFonts) {
        sizeW = 160*SpacedFonts;
    }
    self.selectedAddress.frame = frame(frameX(self.selectedAddress), frameY(self.selectedAddress), sizeW + 15 + upImage.size.width, frameHeight(self.selectedAddress));
    self.selectedAddress.imagePoint = CGPointMake((NavigationBarHeight - upImage.size.height)/2.0,sizeW + 15);
}

//经纪人数据加载
-(void)getjjrJson
{
    NSString *cityID =[CoreArchive strForKey:AddressID];
    [[HomeInfo shareInstance]getHomePageJJR:jjrpageNumb andCityID:cityID.intValue andhangye:_hyStr andcallBack:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
        if (issucced == YES) {
            if (jsonArr.count > 0) {
                [[ToolManager shareInstance]dismiss];
                for (NSDictionary * dic in jsonArr) {
                    [_jjrJsonArr addObject:dic];
                }
                [_jjrTab reloadData];
            }else
            {
                [[ToolManager shareInstance] showAlertMessage:@"没有更多数据了"];
          
            }
            
        }else
        {
             [[ToolManager shareInstance] showAlertMessage:info];
      
        }

    }];
}
//线索数据加载
-(void)getxsJson
{
    NSString *cityID =[CoreArchive strForKey:AddressID];
    [[HomeInfo shareInstance]getHomePageXianSuo:xspageNumb andCityID:cityID.intValue  andhangye:_hyStr andCallBack:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
        if (issucced == YES) {
            if (jsonArr.count > 0) {
                [[ToolManager shareInstance]dismiss];
                for (NSDictionary * dic in jsonArr) {
                    [_xsJsonArr addObject:dic];
                }
                [_xsTab reloadData];
            }else
            {
                [[ToolManager shareInstance]showAlertMessage:@"没有更多数据了"];
            }
            
        }else
        {
             [[ToolManager shareInstance]showAlertMessage:info];
        }
    }];
}
/**
 *  最下层的scrollview
 */
-(void)setButtomScr
{
    buttomScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + NavigationBarHeight + 36, SCREEN_WIDTH, SCREEN_HEIGHT-(StatusBarHeight + NavigationBarHeight + 36 + TabBarHeight))];
    buttomScr.contentSize = CGSizeMake(SCREEN_WIDTH*2, frameHeight(buttomScr));
    buttomScr.backgroundColor = [UIColor clearColor];
    buttomScr.scrollEnabled = YES;
    buttomScr.delegate = self;
    buttomScr.alwaysBounceHorizontal = NO;
    buttomScr.alwaysBounceVertical = NO;
    buttomScr.showsHorizontalScrollIndicator = NO;
    buttomScr.showsVerticalScrollIndicator = NO;
    buttomScr.pagingEnabled = YES;
    buttomScr.bounces = NO;
    [self.view addSubview:buttomScr];
    [self addTheTab];
}
/**
 *  上面的两个按钮
 */
-(void)addTheBtnView
{
    xsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xsBtn.frame = CGRectMake(0, 65, SCREEN_WIDTH/2, 35);
    [xsBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [xsBtn setTitle:@"线索" forState:UIControlStateNormal];
    [xsBtn setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
    [xsBtn setTitleColor:[UIColor colorWithWhite:0.514 alpha:1.000] forState:UIControlStateNormal];
    xsBtn.backgroundColor = [UIColor whiteColor];
    xsBtn.selected = YES;
    [xsBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [xsBtn addTarget:self action:@selector(xsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xsBtn];
    
    jjrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jjrBtn.frame = CGRectMake(SCREEN_WIDTH/2, 65, SCREEN_WIDTH/2, 35);
    [jjrBtn setTitle:@"经纪人" forState:UIControlStateNormal];
    [jjrBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [jjrBtn setTitleColor:[UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000] forState:UIControlStateSelected];
    [jjrBtn setTitleColor:[UIColor colorWithWhite:0.514 alpha:1.000] forState:UIControlStateNormal];
    jjrBtn.backgroundColor = [UIColor whiteColor];
     [jjrBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [jjrBtn addTarget:self action:@selector(jjrBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jjrBtn];
    
    xhxV = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2-45)/2, 65+35-2, 45, 2)];
    xhxV.backgroundColor = [UIColor colorWithRed:0.298 green:0.627 blue:0.996 alpha:1.000];
    [self.view addSubview:xhxV];
}
/**
 *  点击线索btn的方法
 *
 *  @param sender <#sender description#>
 */
-(void)xsBtnAction:(UIButton *)sender
{
    sender.selected = YES;
    jjrBtn.selected = NO;
    [UIView animateWithDuration:0.3f animations:^{
        [xhxV setFrame:CGRectMake((SCREEN_WIDTH/2-45)/2, 65+35-2, 45, 2)];
        [buttomScr setContentOffset:CGPointMake(0, 0)];
    }];
}
/**
 *  点击经纪人的方法
 *
 *  @param sender <#sender description#>
 */
-(void)jjrBtnAction:(UIButton *)sender
{
    sender.selected = YES;
    xsBtn.selected = NO;
    [UIView animateWithDuration:0.3f animations:^{
        [xhxV setFrame:CGRectMake(SCREEN_WIDTH/2+(SCREEN_WIDTH/2-45)/2, 65+35-2, 45, 2)];
        [buttomScr setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    }];
}
#pragma mark----两个tableview写在这里
-(void)addTheTab
{
    _xsTab = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, buttomScr.frame.size.height)];
    _xsTab.dataSource = self;
    _xsTab.delegate = self;
    _xsTab.tableFooterView = [[UIView alloc]init];
    _xsTab.backgroundColor = [UIColor clearColor];
    _xsTab.tag = xsTabTag;
    _xsTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _xsTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        xspageNumb = 1;
        if (_xsJsonArr.count >0) {
            [_xsJsonArr removeAllObjects];
        }
        [_xsTab reloadData];
        [_xsTab.mj_header endRefreshing];
       
        [self getxsJson];
    }];
   
    _xsTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreXS)];
    _xsTab.footer.automaticallyHidden = NO;
    [buttomScr addSubview:_xsTab];
    
    _jjrTab = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH,46, SCREEN_WIDTH, buttomScr.frame.size.height-46)];
    _jjrTab.dataSource = self;
    _jjrTab.delegate = self;
    _jjrTab.tableFooterView = [[UIView alloc]init];
    _jjrTab.backgroundColor = [UIColor clearColor];
    _jjrTab.tag = jjrTabTag;
    _jjrTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _jjrTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        jjrpageNumb = 1;
        if (_jjrJsonArr.count >0) {
            [_jjrJsonArr removeAllObjects];
        }
        [_jjrTab reloadData];
        [_jjrTab.mj_header endRefreshing];
        
        [self getjjrJson];
    }];
    
    _jjrTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreJJR)];
    _jjrTab.footer.automaticallyHidden = NO;
    [buttomScr addSubview:_jjrTab];
    [self addJJRTopV];
}
/**
 *  经纪人那边的知脉推荐和按条件查找的view
 */
-(void)addJJRTopV
{
    UIView * topV = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH+10, 10, SCREEN_WIDTH-20, 35)];
    topV.backgroundColor  = [UIColor whiteColor];
    [buttomScr addSubview:topV];
    UILabel * tuijianLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 25)];
    tuijianLab.backgroundColor = [UIColor clearColor];
    tuijianLab.textAlignment = NSTextAlignmentLeft;
    tuijianLab.font = [UIFont systemFontOfSize:14];
    tuijianLab.text = @"知脉推荐";
    tuijianLab.textColor = [UIColor blackColor];
    [topV addSubview:tuijianLab];
    
    UIButton * chazhaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chazhaoBtn.backgroundColor = [UIColor clearColor];
    [chazhaoBtn setTitle:@"按条件查找" forState:UIControlStateNormal];
    [chazhaoBtn setTitleColor:[UIColor colorWithRed:1.000 green:0.518 blue:0.224 alpha:1.000] forState:UIControlStateNormal];
    chazhaoBtn.frame = CGRectMake(SCREEN_WIDTH-110, 0, 90, 35);
    chazhaoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [chazhaoBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [chazhaoBtn addTarget:self action:@selector(chazhaoAction) forControlEvents:UIControlEventTouchUpInside];
    [topV addSubview:chazhaoBtn];

}

/**
 *  此处查找页面跳转
 */
-(void)chazhaoAction
{
    JingJiRenVC * jjr = [JingJiRenVC new];
    [self.navigationController pushViewController:jjr animated:YES];
}
/**
 *  加载更多线索
 */
-(void)loadMoreXS
{
    xspageNumb ++;
    [self getxsJson];
    [_xsTab.mj_footer endRefreshing];
}
/**
 *  加载更多经纪人
 */
-(void)loadMoreJJR
{
    jjrpageNumb ++;
    [self getjjrJson];
    [_jjrTab.mj_footer endRefreshing];
}
#pragma mark----tableview代理和资源方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView.tag == xsTabTag) {
     
        return 280;
    }else
    { 
        return 119;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == xsTabTag) {
        return _xsJsonArr.count;
    }else
    {
        return _jjrJsonArr.count;
    }
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == xsTabTag) {
        static NSString * idenfStr = @"xsCell";
        XSCell * cell = [tableView dequeueReusableCellWithIdentifier:idenfStr];
        if (!cell) {
            cell = [[XSCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
            cell.backgroundColor = [UIColor clearColor];
            NSString * imgUrl;
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
                imgUrl = [_xsJsonArr[indexPath.row] objectForKey:@"imgurl"];
            }else{
            imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_xsJsonArr[indexPath.row]objectForKey:@"imgurl"]];
            }
            cell.renzhImg.image = [[_xsJsonArr[indexPath.row]objectForKey:@"authen"] intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
            [[ToolManager shareInstance] imageView:cell.headImg  setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];
           
            cell.userNameLab.text = [_xsJsonArr[indexPath.row] objectForKey:@"realname"];
            cell.positionLab.text = [_xsJsonArr[indexPath.row] objectForKey:@"area"];
            NSString * timStr = [_xsJsonArr[indexPath.row] objectForKey:@"createtime"];
            NSTimeInterval time=[timStr doubleValue];
            NSDate *data = [NSDate dateWithTimeIntervalSince1970:time];
            cell.timeLab.text = [self getDateStringWithDate:data DateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString * sjcStr = [self intervalSinceNow:cell.timeLab.text];
            if ([sjcStr integerValue] <=60) {
                cell.timeLab.text = @"刚刚";
            }else if ([sjcStr integerValue]<=3600)
            {
                cell.timeLab.text = [NSString stringWithFormat:@"%ld分钟前",[sjcStr integerValue]/60];
            }else if ([sjcStr integerValue]<=60*60*24)
            {
                cell.timeLab.text = [NSString stringWithFormat:@"%ld小时前",[sjcStr integerValue]/(60*60)];
            }else if ([sjcStr integerValue]<=60*60*24*3)
            {
                cell.timeLab.text = [NSString stringWithFormat:@"%ld天前",[sjcStr integerValue]/(60*60*24)];
            }else
            {
                cell.timeLab.text = [self getDateStringWithDate:data DateFormat:@"MM-dd HH:mm"];
            }
            cell.lookLab.text = [NSString stringWithFormat:@"查看:%@",[_xsJsonArr[indexPath.row] objectForKey:@"readcount"]];
            cell.commentLab.text = [NSString stringWithFormat:@"评论:%@",[_xsJsonArr[indexPath.row] objectForKey:@"commentnum"]];
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:BAOXIAN]) {
                [cell.hanyeBtn setTitle:@"保险" forState:UIControlStateNormal];
            }else if ([[_xsJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:JINRONG])
            {
                [cell.hanyeBtn setTitle:@"金融" forState:UIControlStateNormal];
            }else if ([[_xsJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:FANGCHANG])
            {
                [cell.hanyeBtn setTitle:@"房产" forState:UIControlStateNormal];
            }else if ([[_xsJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:CHEHANG])
            {
                [cell.hanyeBtn setTitle:@"车行" forState:UIControlStateNormal];
            }

            
            cell.titLab.text = [_xsJsonArr[indexPath.row] objectForKey:@"title"];
            cell.moneyLab.text = [_xsJsonArr[indexPath.row] objectForKey:@"cost"];
             cell.blueV.tag = 1000+indexPath.row;
            UITapGestureRecognizer * blueVTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blueVAction:)];
            blueVTap.numberOfTapsRequired =1;
            blueVTap.numberOfTouchesRequired = 1;
           
            [cell.blueV addGestureRecognizer:blueVTap];
            NSString * xqStr;
            NSString * qdStr = @"需求强度: ";
            NSString * qdStr2;
            if ([[_xsJsonArr[indexPath.row] objectForKey:@"confidence_n"] intValue] == 3) {
                qdStr2 = [NSString stringWithFormat:@"很强"];
            }else if ([[_xsJsonArr[indexPath.row] objectForKey:@"confidence_n"] intValue] == 2)
            {
                qdStr2 = [NSString stringWithFormat:@"强"];
            }else
            {
                qdStr2 = [NSString stringWithFormat:@"一般"];
            }
            xqStr = [qdStr stringByAppendingString:qdStr2];
            NSMutableAttributedString * xqqdAtr = [[NSMutableAttributedString alloc]initWithString:xqStr];
            [xqqdAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.000 green:0.518 blue:0.224 alpha:1.000] range:NSMakeRange([qdStr length], [qdStr2 length])];
            [xqqdAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange(0,[qdStr length])];
            cell.xqqdLab.attributedText = xqqdAtr;
            NSString * lq1 = [NSString stringWithFormat:@"%@人领取",[_xsJsonArr[indexPath.row]objectForKey:@"coopnum"] ];
            NSString * lq2 = [NSString stringWithFormat:@""];
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"iscoop"]intValue ]==1) {
                lq2 = [NSString stringWithFormat:@"(已领取)"];
            }
           
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"state"]intValue ]>20) {
                 lq2 = [NSString stringWithFormat:@"(已合作)"];
            }
            
            NSString * lqStr = [lq1 stringByAppendingString:lq2];
            NSMutableAttributedString * lqAtr = [[NSMutableAttributedString alloc]initWithString:lqStr];
            [lqAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange(0, [lq1 length])];
            if ([[_xsJsonArr[indexPath.row]objectForKey:@"iscoop"]intValue ]==1||[[_xsJsonArr[indexPath.row]objectForKey:@"state"]intValue ]>20) {
                [lqAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.000 green:0.518 blue:0.224 alpha:1.000] range:NSMakeRange([lq1 length], [lq2 length])];
            }else
            {
                [lqAtr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.514 alpha:1.000] range:NSMakeRange([lq1 length], [lq2 length])];
            }
            cell.lqLab.attributedText = lqAtr;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnVAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            cell.btnV.tag = 200+indexPath.row;
            [cell.btnV addGestureRecognizer:tap];
            
        }
        return cell;
    }else
    {
        static NSString * idenfStr = @"jjrCell";
        JJRCell * cell = [tableView dequeueReusableCellWithIdentifier:idenfStr];
        if (!cell) {
            cell = [[JJRCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 119)];
            cell.backgroundColor = [UIColor clearColor];
            NSString * imgUrl;
            if ([[_jjrJsonArr[indexPath.row]objectForKey:@"imgurl"] rangeOfString:@"http"].location != NSNotFound) {
                imgUrl = [_jjrJsonArr[indexPath.row] objectForKey:@"imgurl"];
            }else{
                imgUrl = [NSString stringWithFormat:@"%@%@",IMG_URL,[_jjrJsonArr[indexPath.row]objectForKey:@"imgurl"]];
            }
            cell.renzhImg.image = [[_jjrJsonArr[indexPath.row]objectForKey:@"authen"] intValue]==3?[UIImage imageNamed:@"renzhen"]:[UIImage imageNamed:@"weirenzhen"];
            

            [[ToolManager shareInstance] imageView:cell.headImg  setImageWithURL:imgUrl placeholderType:PlaceholderTypeUserHead];

            cell.userNameLab.text = [_jjrJsonArr[indexPath.row] objectForKey:@"realname"];
            cell.positionLab.text = [_jjrJsonArr[indexPath.row]objectForKey:@"area"];
            if ([[_jjrJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:BAOXIAN]) {
                cell.hanyeLab.text = @"保险";
            }else if ([[_jjrJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:JINRONG])
            {
                cell.hanyeLab.text = @"金融";
            }else if ([[_jjrJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:FANGCHANG])
            {
                cell.hanyeLab.text = @"房产";
            }else if ([[_jjrJsonArr[indexPath.row]objectForKey:@"industry"] isEqualToString:CHEHANG])
            {
                cell.hanyeLab.text = @"车行";
            }
           
            cell.fuwuLab.text = [NSString stringWithFormat:@"服务:%@",[_jjrJsonArr[indexPath.row]objectForKey:@"servernum"]];
            
            cell.fansLab.text = [NSString stringWithFormat:@"粉丝:%@",[_jjrJsonArr[indexPath.row]objectForKey:@"fansnum"]];
            if ([[_jjrJsonArr[indexPath.row]objectForKey:@"isfollow"] intValue] == 1) {
                cell.guanzhuBtn.selected = YES;
                if ([[_jjrJsonArr[indexPath.row]objectForKey:@"mutual"]intValue] == 1) {
                    [cell.guanzhuBtn setTitle:@"已互关注" forState:UIControlStateSelected];
                }
            }else
            {
                cell.guanzhuBtn.selected = NO;
            }
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jjrAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            cell.nextV.tag = 500+indexPath.row;
            [cell.nextV addGestureRecognizer:tap];
            cell.guanzhuBtn.tag = 300+indexPath.row;
            [cell.guanzhuBtn addTarget:self action:@selector(guanzhuAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;

    }
}
-(void)jjrAction:(UIGestureRecognizer *)sender
{
    JJRDetailVC * jjrV = [[JJRDetailVC alloc]init];
    jjrV.jjrID = [_jjrJsonArr[sender.view.tag-500] objectForKey:@"id"];
    [self.navigationController pushViewController:jjrV animated:YES];
}
-(void)guanzhuAction:(UIButton *)sender
{
    NSString * target_id = [_jjrJsonArr[sender.tag-300] objectForKey:@"id"];
    //isfollow:1代表取消关注,0代表关注
    int isfollow;
    if (sender.selected == YES) {
        isfollow = 1;
    }else
    {
        isfollow = 0;
    }
    [[HomeInfo shareInstance]guanzhuTargetID:[target_id intValue] andIsFollow:isfollow andcallBack:^(BOOL issucced, NSString *info, NSArray *jsonArr) {
        if (issucced == YES) {
            sender.selected = !sender.selected;
        }else
        {
            HUDText(info);
        }
        
    }];
}
#pragma mark----线索那边的头像那块view的点击事件
-(void)btnVAction:(UITapGestureRecognizer *)sender
{
    JJRDetailVC * jjrV = [[JJRDetailVC alloc]init];
    jjrV.jjrID = [_xsJsonArr[sender.view.tag-200] objectForKey:@"brokerid"];
    [self.navigationController pushViewController:jjrV animated:YES];
}
-(void)blueVAction:(UITapGestureRecognizer *)sender
{
    if ([[_xsJsonArr[sender.view.tag-1000] objectForKey:@"iscoop"] intValue] == 1) {
        //跳转我的领取线索详情
        MyLQDetailVC* myLqV =  [[MyLQDetailVC alloc]init];
        myLqV.xiansuoID = [_xsJsonArr[sender.view.tag - 1000] objectForKey:@"id"];
       [self.navigationController pushViewController:myLqV animated:YES];
        return;
    }
    if ([[_xsJsonArr[sender.view.tag-1000] objectForKey:@"isself"] intValue] == 1) {
        //跳转我的发布线索详情
        MyXSDetailVC* myxiansuoV =  [[MyXSDetailVC alloc]init];
        myxiansuoV.xiansuoID = [_xsJsonArr[sender.view.tag - 1000] objectForKey:@"id"];
        [self.navigationController pushViewController:myxiansuoV animated:YES];

        return;
    }
    XianSuoDetailVC * xiansuoV =  [[XianSuoDetailVC alloc]init];
    xiansuoV.xs_id = [_xsJsonArr[sender.view.tag - 1000] objectForKey:@"id"];
    [self.navigationController pushViewController:xiansuoV animated:YES];
}
/**
 *  scrollview代理方法
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = buttomScr.contentOffset;
    [UIView animateWithDuration:0.3f animations:^{
        if ((int)point.x % (int)SCREEN_WIDTH == 0) {
            if (point.x/SCREEN_WIDTH ==1) {
                  //               NSLog(@"第二页");
                jjrBtn.selected = YES;
                xsBtn.selected = NO;
                [xhxV setFrame:CGRectMake(SCREEN_WIDTH/2+(SCREEN_WIDTH/2-45)/2, 65+35-2, 45, 2)];
            }else if(point.x/SCREEN_WIDTH ==0)
            {
                //               NSLog(@"第一页");
                jjrBtn.selected = NO;
                xsBtn.selected = YES;
                 [xhxV setFrame:CGRectMake((SCREEN_WIDTH/2-45)/2, 65+35-2, 45, 2)];
            }
        }
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//转换时间戳
-(NSString *)getDateStringWithDate:(NSDate *)date
                        DateFormat:(NSString *)formatString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    NSString *dateString = [dateFormat stringFromDate:date];
    //     NSLog(@"date: %@", dateString);
    
    return dateString;
}
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    
    timeString = [NSString stringWithFormat:@"%f", cha];
    timeString = [timeString substringToIndex:timeString.length-7];
    timeString=[NSString stringWithFormat:@"%@", timeString];
    
    return timeString;
}
//- (void)viewWillDisappear:(BOOL)animated
//
//{
//    [super viewWillDisappear:animated];
//    [[ToolManager shareInstance].drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//    [[ToolManager shareInstance].drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
//    
//}
//
//- (void)viewWillAppear:(BOOL)animated
//
//{
//    [super viewWillAppear:animated];
//    [[ToolManager shareInstance].drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    [[ToolManager shareInstance].drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
