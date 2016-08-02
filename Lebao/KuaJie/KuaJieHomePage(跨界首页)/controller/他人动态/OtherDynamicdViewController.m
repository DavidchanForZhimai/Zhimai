//
//  OtherDynamicdViewController.m
//  Lebao
//
//  Created by David on 16/8/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "OtherDynamicdViewController.h"

@interface OtherDynamicdViewController ()

@end

@implementation OtherDynamicdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"详情"];
    // Do any additional setup after loading the view.
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==0) {
        PopView(self);
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
