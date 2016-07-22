//
//  LoCationManager.m
//  Lebao
//
//  Created by adnim on 16/7/22.
//  Copyright © 2016年 David. All rights reserved.
//

#import "LoCationManager.h"


static LoCationManager *locationManager;
@implementation LoCationManager
{
     CLLocationCoordinate2D coordinate2D;
}

+(LoCationManager*)shareInstance
{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager =[[super alloc]init];
    });
 
    return locationManager;
}

-(CLLocationCoordinate2D )getLatitudeAndLongitude
{
   
    
    [self creatLocationManager];
    
    
    return coordinate2D;
}

-(void)creatLocationManager
{
    _locationMNG=[[CLLocationManager alloc]init];
    
    
    
    if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse) {
        //授权,在使用app的时候开启定位服务
        [_locationMNG requestWhenInUseAuthorization];
    }
    
    
    if (![CLLocationManager locationServicesEnabled]) {
        [[ToolManager shareInstance] showAlertViewTitle:@"温馨提示" contentText:@"请到设置-隐私-定位-开启知脉定位" showAlertViewBlcok:^{
            
        }];
        return;
    };
    
    
    _locationMNG.delegate=self;
    //设置定位的精度
    _locationMNG.desiredAccuracy=kCLLocationAccuracyBest;
     //设置定位更新的最小距离(米)
    _locationMNG.distanceFilter=100.0f;
    
    [_locationMNG startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate
#pragma mark - 定位跟新的回调函数
#pragma mark - 根据之前设置的最小更新距离，当移动距离超过的这个值就回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //locations,返回的一个位置,可能包含几个位置信息
    
    //获取其中第一个位置
    CLLocation *cllocation=[locations firstObject];
    
    coordinate2D=cllocation.coordinate;
    
    NSLog(@"纬度: %f, 经度: %f", coordinate2D.latitude, coordinate2D.longitude);
    
    
    [_locationMNG stopUpdatingLocation];
    
    _locationMNG=nil;
    
}




@end
