//
//  JJRCell.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/12.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "JJRCell.h"

@implementation JJRCell
{
    UIView * customV;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self customV:frame];
    }
    return self;
}
-(void)customV:(CGRect)frame
{
    customV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, frame.size.width-20, frame.size.height-10)];
    customV.backgroundColor = [UIColor colorWithRed:0.976 green:0.973 blue:0.973 alpha:1.000];
    [self addSubview:customV];
    [self addTheNextV];
}
-(void)addTheNextV
{
    _nextV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, customV.frame.size.width, 71)];
    _nextV.backgroundColor = [UIColor whiteColor];
    _nextV.userInteractionEnabled = YES;
    [customV addSubview:_nextV];
    
    _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 41, 41)];
    [_nextV addSubview:_headImg];
    
    _userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(_headImg.frame.origin.x+_headImg.frame.size.width+10, 12, 55, 25)];
    _userNameLab.font = [UIFont systemFontOfSize:15];
    _userNameLab.textColor = [UIColor blackColor];
    _userNameLab.textAlignment = NSTextAlignmentLeft;
    [_nextV addSubview:_userNameLab];
    
    UIImageView * posImg = [[UIImageView alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x, 42, 11, 11)];
    posImg.image = [UIImage imageNamed:@"dizhi"];
    [_nextV addSubview:posImg];
    
    _positionLab = [[UILabel alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x+16, 42, 80, 11)];
    _positionLab.font = [UIFont systemFontOfSize:12];
    _positionLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _positionLab.textAlignment = NSTextAlignmentLeft;
    [_nextV addSubview:_positionLab];
    
    _renzhImg = [[UIImageView alloc]initWithFrame:CGRectMake(_userNameLab.frame.origin.x+_userNameLab.frame.size.width, 18, 14, 14)];
    _renzhImg.image = [UIImage imageNamed:@"renzhen"];
    [_nextV addSubview:_renzhImg];
    
    _hanyeLab = [[UILabel alloc]initWithFrame:CGRectMake(customV.frame.size.width-70, 12, 60, 20)];
    _hanyeLab.backgroundColor = [UIColor clearColor];
    _hanyeLab.font = [UIFont systemFontOfSize:12];
    _hanyeLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    _hanyeLab.textAlignment = NSTextAlignmentRight;
    [_nextV addSubview:_hanyeLab];
    
    _fuwuLab = [[UILabel alloc]initWithFrame:CGRectMake(customV.frame.size.width-140, 36.5, 60, 20)];
    _fuwuLab.backgroundColor = [UIColor clearColor];
    _fuwuLab.font = [UIFont systemFontOfSize:12];
    _fuwuLab.textAlignment = NSTextAlignmentCenter;
    _fuwuLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    [_nextV addSubview:_fuwuLab];
    
    _fansLab = [[UILabel alloc]initWithFrame:CGRectMake(customV.frame.size.width-70, 36.5, 60, 20)];
    _fansLab.backgroundColor = [UIColor clearColor];
    _fansLab.textAlignment = NSTextAlignmentRight;
    _fansLab.font = [UIFont systemFontOfSize:12];
    _fansLab.textColor = [UIColor colorWithWhite:0.514 alpha:1.000];
    [_nextV addSubview:_fansLab];
    [self addTheGuanZhuV];
}
-(void)addTheGuanZhuV
{
    _guanzhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _guanzhuBtn.backgroundColor = [UIColor clearColor];
    [_guanzhuBtn setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
    [_guanzhuBtn setTitle:@"  关注Ta" forState:UIControlStateNormal];
    [_guanzhuBtn setTitle:@"  已关注" forState:UIControlStateSelected];
    [_guanzhuBtn setImage:[UIImage imageNamed:@"hxgz"] forState:UIControlStateSelected];
    [_guanzhuBtn setTitleColor:[UIColor colorWithRed:0.239 green:0.553 blue:0.996 alpha:1.000] forState:UIControlStateNormal];
    [_guanzhuBtn setTitleColor:[UIColor colorWithWhite:0.651 alpha:1.000] forState:UIControlStateSelected];
    _guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _guanzhuBtn.frame = CGRectMake(0, 76, customV.frame.size.width, 28);
    [customV addSubview:_guanzhuBtn];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
