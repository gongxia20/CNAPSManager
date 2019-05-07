//
//  AppDelegate.m
//  CNAPSManager
//
//  Created by James on 2019/2/18.
//  Copyright © 2019年 James. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate ()
@property (nonatomic, strong) BMKMapManager *mapManager; //主引擎类
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 要使用百度地图，请先启动BaiduMapManager
    self.mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数  wTYs0IczUD0AG0WoYCrPnOAg0sxN3P6a
    BOOL ret = [_mapManager start:@"wTYs0IczUD0AG0WoYCrPnOAg0sxN3P6a"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"启动引擎失败!");
    }
    
    /**
     百度地图SDK所有API均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
