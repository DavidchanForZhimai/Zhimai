//
//  DynamicDetailsViewController.h
//  Lebao
//
//  Created by David on 16/8/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^DeleteDynamicDetailSucceed) (BOOL succeed);
@interface DynamicDetailsViewController : BaseViewController
@property(nonatomic,strong)NSString *dynamicdID;
@property (strong,nonatomic)NSMutableArray * jjrJsonArr;
@property(nonatomic,copy)DeleteDynamicDetailSucceed deleteDynamicDetailSucceed;
@end
