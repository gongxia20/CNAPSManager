//
//  WatchHomeDataManager.h
//  CMWATCH
//
//  Created by 朱晓东 on 2018/12/29.
//  Copyright © 2018年 trthi. All rights reserved.
//  首页的数据缓存管理类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatchHomeDataManager : NSObject

+ (WatchHomeDataManager *)shareManager;

/**
 将首页的某个表的数据缓存起来
 */
-(void)saveHomeWatchWithCid:(NSString *)cid media:(NSString *)mediaString personal:(NSString *)personal mapstring:(NSString *)map;

/**
 获取首页某个手表的数据
 */
-(NSDictionary *)getHomeWatchWithCid:(NSString *)cid;

/**
 根据cid 和 deviceUserId来判断是否需要重新在指定时间范围内刷新接口数据 yes 需要刷新 no 不需要刷新

 @param cid 设备cid
 @param deviceUserId 设备deviceUid
 */
-(BOOL)checkHomeWatchIsNeedLoadingWithCid:(NSString *)cid deviceUserId:(NSString *)deviceUserId;

-(void)updateHomeWatchLoadingWithCid:(NSString *)cid deviceUserId:(NSString *)deviceUserId;

@end

NS_ASSUME_NONNULL_END
