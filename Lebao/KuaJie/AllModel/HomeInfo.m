//
//  HomeInfo.m
//  KuaJie
//
//  Created by 严文斌 on 16/5/26.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import "HomeInfo.h"
#import "CoreArchive.h"

@interface HomeInfo ()

@property AFHTTPRequestOperationManager *manager;

@end
@implementation HomeInfo
+ (HomeInfo*) shareInstance
{
    static HomeInfo* shareInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}
- (HomeInfo*)init
{
    self = [super init];
    
    if (self != NULL) {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.requestSerializer.timeoutInterval = 15.0; // timeout for 5s;
    }
   
    return self;
}
-(void)getHomePageXianSuo:(int)pageNub andCityID:(int)cityID andhangye:(NSString *)hangye andCallBack:(HomePageCallbackType1 )callback
{
    NSString * url = [NSString stringWithFormat:@"%@demand/list",HOST_URL];
//    NSDictionary * dic;
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
   
    if (cityID || cityID == 0) {
//    dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageNub],@"page",userName,@"username",passWord,@"password",[NSString stringWithFormat:@"%d",cityID],@"cityid",nil];
         [parameters setValue:@(cityID) forKey:@"cityid"];
         [parameters setValue:@(pageNub) forKey:@"page"];
    }else{
//    dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageNub],@"page",userName,@"username",passWord,@"password",nil];
         [parameters setValue:@(pageNub) forKey:@"page"];
    }
    if (hangye&&![hangye isEqualToString:@""]) {
         [parameters setValue:[Parameter industryForCode:hangye]  forKey:@"industry"];
    }
    [[ToolManager shareInstance]showWithStatus];
        [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            
            callback(YES,nil,[responseObject objectForKey:@"datas"]);
            //行业
            [CoreArchive setStr:[Parameter industryChinese:responseObject[@"industry"]] key:Industry];
            //地址版本
            [CoreArchive setStr:responseObject[@"area_version"] key:AddressNewVersion];
            [CoreArchive setStr:responseObject[@"car_version"] key:KCarNewVersion];
            [CoreArchive setStr:responseObject[@"location_id"] key:KLocationId];
            [CoreArchive setStr:responseObject[@"location_name"] key:KLocationName];

        }else
        {
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"首页线索列表错误error==%@",error);
        callback(NO,@"请检查您的网络",nil);
    }];
}
-(void)getHomePageJJR:(int)pageNub andCityID:(int)cityID andhangye:(NSString *)hangye andcallBack:(HomePageCallbackType1)callback
{
    NSString * url = [NSString stringWithFormat:@"%@broker/agentlist",HOST_URL];
//    NSDictionary * dic;
     NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
    if (cityID || cityID == 0) {
//        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageNub],@"page",userName,@"username",passWord,@"password",[NSString stringWithFormat:@"%d",cityID],@"cityid",nil];

        [parameters setValue:@(cityID) forKey:@"cityid"];
        [parameters setValue:@(pageNub) forKey:@"page"];
    }else{
         [parameters setValue:@(pageNub) forKey:@"page"];
    }
    if (hangye&&![hangye isEqualToString:@""]) {
        [parameters setValue:[Parameter industryForCode:hangye]  forKey:@"industry"];
    }
   
    [[ToolManager shareInstance]showWithStatus];
    [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            
            callback(YES,nil,[responseObject objectForKey:@"datas"]);
        }else
        {
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"首页经纪人列表错误error==%@",error);
        callback(NO,@"请检查您的网络",nil);
    }];

}
-(void)guanzhuTargetID:(int)targetID andIsFollow:(int)isfl andcallBack:(HomePageCallbackType1)callback
{
    NSString * url = [NSString stringWithFormat:@"%@broker/follow",HOST_URL];
    
    NSMutableDictionary *parameters =  [Parameter parameterWithSessicon];
     [parameters setValue:@(targetID) forKey:@"id"];
     [parameters setValue:@(isfl) forKey:@"isfollow"];
//    NSDictionary *  dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",targetID],@"id",userName,@"username",passWord,@"password",[NSString stringWithFormat:@"%d",isfl],@"isfollow",nil];
    [[ToolManager shareInstance]showWithStatus];
    [self.manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"rtcode"] intValue]==1) {
            [[ToolManager shareInstance]dismiss];
            callback(YES,@"操作成功",nil);
        }else
        { 
            callback(NO,[responseObject objectForKey:@"rtmsg"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"首页线索列表错误error==%@",error);
        callback(NO,@"请检查您的网络",nil);
    }];

}
@end
