//
//  BottomView.m
//  1233Shop
//
//  Created by 陈江彬 on 14/12/26.
//  Copyright (c) 2014年 CJB. All rights reserved.
//

#import "BottomView.h"
#import "AppDelegate.h"
#import "ToolManager.h"
#import "UIButton+Extend.h"

@interface BottomView()
{
    float tabItemWidth;
    float tabItemHeight;
}

@end

@implementation BottomView
#pragma mark-
#pragma mark 
- (id)initWithFrame:(CGRect)frame selectIndex:(int)selectIndex clickCenterButton:(ClickCenterButton)clickCenterButton
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _clickCenterButton = clickCenterButton;
        
        NSArray *iconNormal = [NSArray arrayWithObjects:@"transboundary_normal",@"find_normal", nil];
        NSArray *iconPressed = [NSArray arrayWithObjects:@"transboundary_pressed",@"find_pressed", nil];
        NSArray *name = [NSArray arrayWithObjects:@"跨界",@"发现", nil];
        float centerWidth = APPWIDTH/(iconNormal.count +1) + 10*ScreenMultiple;
        tabItemWidth  = (APPWIDTH -centerWidth)/iconNormal.count;
        tabItemHeight = self.frame.size.height;
        
        self.backgroundColor = WhiteColor;
        self.layer.borderWidth = 0.5*ScreenMultiple;
        self.layer.borderColor = LineBg.CGColor;
        
        for (int i=0; i<iconNormal.count; i++)
        {
        
                TabbarDataType *type = [[TabbarDataType alloc] init];
                type.itemIndex = i;
                type.itemIsSelected = NO;
                if (selectIndex==i)
                {
                    type.itemIsSelected = YES;
                }
                
               
                type.itemImage = iconNormal[i];
                type.itemSelectImage = iconPressed[i];
                type.itemTitle = name[i];
                
                CGRect itemRect;
                if(i<1)
                {
                    itemRect = CGRectMake(i*tabItemWidth, 0, tabItemWidth, tabItemHeight);
                }
                else
                {
                itemRect = CGRectMake( i*tabItemWidth +centerWidth, 0, tabItemWidth, tabItemHeight);
                }
                TabbarItem *item = [[TabbarItem alloc] initWithFrame:itemRect itemData:type];
                
                item.itemSelectBlock = ^(int index){
                    
                [getAppDelegate().mainTab setSelectedIndex:index];
                    
                };
                
                [self addSubview:item];
        
           
            
        }
        UIButton *centerBtn =[UIButton createButtonWithfFrame:frame(tabItemWidth, 0, centerWidth, tabItemHeight) title:nil backgroundImage:nil iconImage:[UIImage imageNamed:@"tabar_center_nomal"] highlightImage:[UIImage imageNamed:@"tabar_center_nomal"] tag:0 inView:self];
        
        [centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

     
    }
    
    return self;
}
#pragma mark
#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)sender
{
    if (_clickCenterButton) {
        _clickCenterButton();
    }
}
#pragma mark-
#pragma mark 内存
- (void)dealloc
{
}


@end


