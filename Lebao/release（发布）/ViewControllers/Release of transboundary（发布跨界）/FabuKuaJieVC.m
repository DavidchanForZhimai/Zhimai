//
//  FabuKuaJieVC.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/23.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "FabuKuaJieVC.h"
#import "XianSuoDetailInfo.h"
#import "PayDingJinVC.h"
@interface FabuKuaJieVC ()<UITextViewDelegate,UITextFieldDelegate>
{
    UIButton * tempBtn;
}
@property (strong,nonatomic)UITextField * titTex;
@property (strong,nonatomic)UITextView * contTex;
@property (strong,nonatomic)UITextField * bcTex;
@property (strong,nonatomic)UILabel * moneyLab;
@end

@implementation FabuKuaJieVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoAction)name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTheTiJiaoBtn];
    self.view.backgroundColor = BACKCOLOR;
    [self setNav];
    [self setBtmScr];
}
-(void)setBtmScr
{
    _bottomScr.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huishouAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_bottomScr addGestureRecognizer:tap];
    [self addTheBianJiV];
}
-(void)huishouAction
{
    [self.view endEditing:YES];
}
-(void)addTheBianJiV
{
    UIView * bjV = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 120)];
    bjV.backgroundColor = [UIColor whiteColor];
    [_bottomScr addSubview:bjV];
    
    UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 25)];
    titLab.textColor = [UIColor blackColor];
    titLab.font = [UIFont systemFontOfSize:13];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.text = @"标题";
    [bjV addSubview:titLab];
    
    _titTex = [[UITextField alloc]initWithFrame:CGRectMake(55, 5, SCREEN_WIDTH-60, 25)];
    _titTex.placeholder = @"请输入标题";
    _titTex.textAlignment = NSTextAlignmentLeft;
    _titTex.textColor = [UIColor blackColor];
    _titTex.font = [UIFont systemFontOfSize:14];
    [bjV addSubview:_titTex];
    
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, 1)];
    hxV.backgroundColor = BACKCOLOR;
    [bjV addSubview:hxV];
    
    _contTex = [[UITextView alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20, 75)];
    _contTex.delegate = self;
    _contTex.layer.cornerRadius = 6.0f;
    _contTex.layer.borderWidth = 1;
    _contTex.layer.borderColor = [BACKCOLOR CGColor];
    _contTex.textColor = [UIColor colorWithRed:0.741 green:0.741 blue:0.745 alpha:1.000];
    _contTex.text = @"请输入线索内容";
    _contTex.font = [UIFont systemFontOfSize:13];
    [bjV addSubview:_contTex];
    
    [self addTheHYV:bjV.frame.size.height+bjV.frame.origin.y + 10];
}
-(void)addTheHYV:(CGFloat)orgY
{
    UIView * hanyeV = [[UIView alloc]initWithFrame:CGRectMake(0, orgY, SCREEN_WIDTH, 86)];
    hanyeV.backgroundColor = [UIColor clearColor];
    [_bottomScr addSubview:hanyeV];
    UILabel * hyLab  = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 25)];
    hyLab.backgroundColor = [UIColor whiteColor];
    hyLab.textColor = [UIColor blackColor];
    hyLab.textAlignment = NSTextAlignmentLeft;
    hyLab.text = @"   线索所属行业";
    hyLab.font = [UIFont systemFontOfSize:13];
    [hanyeV addSubview:hyLab];
    NSArray * arr = @[@"保险",@"金融",@"房产",@"车行"];
    UIView * btnV = [[UIView alloc]initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH, 50)];
    btnV.backgroundColor = [UIColor whiteColor];
    [hanyeV addSubview:btnV];
    for (int i = 0; i < 4; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10+ i * 65+ (SCREEN_WIDTH-65*4-20)/3*i, 10, 65, 30);
        btn.backgroundColor = [UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag = i+100;
        [btn setTitleColor:[UIColor colorWithWhite:0.655 alpha:1.000] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hyAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnV addSubview:btn];
        btn.layer.cornerRadius = 6.0f;
    }
    tempBtn = [hanyeV viewWithTag:100];
    tempBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
    [tempBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self addTheBCV:hanyeV.frame.size.height+hanyeV.frame.origin.y+10];
}
-(void)addTheBCV:(CGFloat)orgY
{
    UIView *bcV = [[UIView alloc]initWithFrame:CGRectMake(0, orgY, SCREEN_WIDTH, 195)];
    bcV.backgroundColor = [UIColor whiteColor];
    [_bottomScr addSubview:bcV];
    
    UILabel * qwbcLab  = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 25)];
    qwbcLab.backgroundColor = [UIColor whiteColor];
    qwbcLab.textColor = [UIColor blackColor];
    qwbcLab.textAlignment = NSTextAlignmentLeft;
    qwbcLab.text = @"   成交报酬";
    qwbcLab.font = [UIFont systemFontOfSize:13];
    [bcV addSubview:qwbcLab];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    hxV.backgroundColor = BACKCOLOR;
    [bcV addSubview:hxV];
    _bcTex = [[UITextField alloc]initWithFrame:CGRectMake(20, 55, SCREEN_WIDTH-40, 40)];
    _bcTex.borderStyle = UITextBorderStyleRoundedRect;
    _bcTex.placeholder = @"请输入您的成交报酬(请不小于200元)";
    _bcTex.keyboardType = UIKeyboardTypeDecimalPad;
    _bcTex.textColor = [UIColor blackColor];
    _bcTex.textAlignment = NSTextAlignmentCenter;
    _bcTex.delegate = self;
    _bcTex.font = [UIFont systemFontOfSize:15];
    [bcV addSubview:_bcTex];

    UILabel * djLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 110, 100, 20)];
    djLab.textAlignment = NSTextAlignmentCenter;
    djLab.textColor = [UIColor blackColor];
    djLab.text = @"需支付诚信金";
    djLab.font = [UIFont systemFontOfSize:12];
    [bcV addSubview:djLab];
    
   
    
    
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, 130, 150, 25)];
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    _moneyLab.textColor = [UIColor blackColor];
    _moneyLab.font = [UIFont boldSystemFontOfSize:14];
    _moneyLab.text = @"0.00";
    [bcV addSubview:_moneyLab];
    
    
    UILabel * msLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, SCREEN_WIDTH -20, 30)];
    msLab.backgroundColor = WhiteColor;
    msLab.font = [UIFont systemFontOfSize:12];
    msLab.lineBreakMode = NSLineBreakByTruncatingTail;
    msLab.numberOfLines = 2;
    msLab.textAlignment = NSTextAlignmentLeft;
    msLab.textColor = [UIColor colorWithWhite:0.522 alpha:1.000];
    msLab.text = @"按照成交报酬的2%收取线索诚信金,没有选择合作或者合作成功,诚信金都将退回";
    [bcV addSubview:msLab];
    _bottomScr.contentSize = CGSizeMake(SCREEN_WIDTH, bcV.frame.size.height+bcV.frame.origin.y);
    
}
-(void)infoAction
{
    if ([_bcTex.text isEqualToString:@"0"]||[_bcTex.text isEqualToString:@""]) {
        _moneyLab.text = @"0.00";
    }else{
        float bfb = [_bcTex.text floatValue];
        _moneyLab.text = [NSString stringWithFormat:@"%.2f",bfb * 0.02];
    }
}
-(void)addTheTiJiaoBtn
{
    UIButton * tijiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tijiaoBtn.frame = CGRectMake(0, SCREEN_HEIGHT-42, SCREEN_WIDTH, 42);
    tijiaoBtn.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
    [tijiaoBtn setTitle:@"提交" forState:UIControlStateNormal];
    [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tijiaoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    tijiaoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [tijiaoBtn addTarget:self action:@selector(tijiaoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tijiaoBtn];
}
-(void)tijiaoAction
{
    if ([_titTex.text length]<= 0) {
        HUDText(@"请输入标题");
        return;
    }
    NSLog(@"_contTex.text=%@",_contTex.text);
    if ([_contTex.text isEqualToString:@"请输入线索内容"]) {
        HUDText(@"请输入线索内容");
        return;
    }
    if ([_bcTex.text length]<= 0) {
        HUDText(@"请输入成交报酬");
        return;
    }
    NSString * induStr;
    if ([tempBtn.titleLabel.text isEqualToString:@"保险"]) {
        
        if ([_bcTex.text intValue]<200) {
           
            HUDText(@"保险类成交报酬最低为200元");
            return;
        }
        induStr = @"insurance";
    }
    if ([tempBtn.titleLabel.text isEqualToString:@"金融"]) {
        if ([_bcTex.text intValue]<500) {
            HUDText(@"金融类成交报酬最低为500元");
            return;
        }
        induStr = @"finance";
    }
    if ([tempBtn.titleLabel.text isEqualToString:@"房产"]) {
        if ([_bcTex.text intValue]<2000) {
            HUDText(@"房产类成交报酬最低为2000元");
            return;
        }
        induStr = @"property";
    }
    if ([tempBtn.titleLabel.text isEqualToString:@"车行"]) {
        if ([_bcTex.text intValue]<500) {
            HUDText(@"车行类成交报酬最低为500元");
            return;
        }
        induStr = @"car";
    }

    NSLog(@"%@",induStr);
    PayDingJinVC * payVC = [[PayDingJinVC alloc]init];
    payVC.zfymType = FaBuZhiFu;
    payVC.qwjeStr = _bcTex.text;
    payVC.titStr = _titTex.text;
    payVC.content = _contTex.text;
    payVC.industry = induStr;
    payVC.jineStr = _moneyLab.text;
    [self.navigationController pushViewController:payVC animated:YES];
}
-(void)hyAction:(UIButton *)sender
{
    [tempBtn setTitleColor:[UIColor colorWithWhite:0.655 alpha:1.000] forState:UIControlStateNormal];
    tempBtn.backgroundColor = [UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
    sender.backgroundColor = [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
     [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tempBtn = sender;
     if ([tempBtn.titleLabel.text isEqualToString:@"保险"]) {
        _bcTex.placeholder = @"请输入您的成交报酬(请不小于200元)";
    }
    if ([tempBtn.titleLabel.text isEqualToString:@"金融"]) {
        _bcTex.placeholder = @"请输入您的成交报酬(请不小于500元)";
          }
    if ([tempBtn.titleLabel.text isEqualToString:@"房产"]) {
        _bcTex.placeholder = @"请输入您的成交报酬(请不小于2000元)";
          }
    if ([tempBtn.titleLabel.text isEqualToString:@"车行"]) {
        _bcTex.placeholder = @"请输入您的成交报酬(请不小于500元)";
         }

    NSLog(@"%ld",sender.tag);
}
-(void)setNav
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
   
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    backBtn.imageView.contentMode = UIViewContentModeLeft;
    [backBtn setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UILabel * titLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, 20, 120, 44)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.textColor = [UIColor blackColor];
    titLab.text = @"线索编辑";
    titLab.font = [UIFont systemFontOfSize:16];
    [navView addSubview:titLab];
    UIView * hxV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
    hxV.backgroundColor = [UIColor colorWithRed:0.816 green:0.820 blue:0.827 alpha:1.000];
    [self.view addSubview:hxV];
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self addNoti];
    textField.text = @"";
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        _moneyLab.text = @"";
    }
}

-(void)addNoti{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyBoardShow:(NSNotification *)sender{
    //     NSLog(@"sender=%@",sender);
    CGRect keyboard_bounds = [sender.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    float keyboard_h = keyboard_bounds.size.height;
    float keyboard_y = SCREEN_HEIGHT-keyboard_h;
    //     NSLog(@"keyboard_y=%.2f",keyboard_y);
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    CGRect rect = [firstResponder convertRect:firstResponder.bounds toView:self.view];
    float field_maxy = CGRectGetMaxY(rect);
    //     NSLog(@"field_maxy=%.2f",field_maxy);
    
    float keyboard_hide = (field_maxy - keyboard_y)>0?field_maxy - keyboard_y:0;
    //     NSLog(@"keyboard_hide=%.2f",keyboard_hide);
    
    self.view.transform=CGAffineTransformMakeTranslation(0, -keyboard_hide-55);
    
}
-(void)keyBoardHide:(NSNotificationCenter *)sender{
    
    self.view.transform = CGAffineTransformIdentity;
}

-(void)removeNoti{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction
{
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <1) {
        textView.text = @"请输入线索内容";
        textView.textColor = [UIColor colorWithRed:0.741 green:0.741 blue:0.745 alpha:1.000];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: @"请输入线索内容"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self removeNoti];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
