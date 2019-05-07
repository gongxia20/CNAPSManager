//
//  WatchHomeDataManager.m
//  CMWATCH
//
//  Created by 朱晓东 on 2018/12/29.
//  Copyright © 2018年 trthi. All rights reserved.
//

#import "WatchHomeDataManager.h"

#define kWatchHomeInfoTable @"CREATE TABLE IF NOT EXISTS t_watchHomeInfo (id integer PRIMARY KEY AUTOINCREMENT,cid text NOT NULL,cid_map text NOT NULL,cid_media text NOT NULL,cid_status text NOT NULL)"

@interface WatchHomeDataManager ()

@property (strong, nonatomic) TFmdbManager *handler;

@property(nonatomic,strong) NSMutableDictionary *cidDictM;

@end

@implementation WatchHomeDataManager

static WatchHomeDataManager *manager = nil;

+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(NSMutableDictionary *)cidDictM{
    if (!_cidDictM) {
        _cidDictM = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    return _cidDictM;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.handler = [TFmdbManager sharedManager];
        // 1.创建上传日志记录失败缓存表
        [self createTable:@"t_watchHomeInfo" withSQL:kWatchHomeInfoTable];
    }
    return self;
}

- (void)createTable:(NSString *)tableName withSQL:(NSString *)sql{
    if (![self.handler checkoutFmdbIncludeTableWithTableName:tableName]) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [self.handler createFmdbTableWithSql:sql andTableName:tableName atFmdb:appDelegate.databaseQueue];
    }
}

/**
 将首页的某个表的数据缓存起来
 */
-(void)saveHomeWatchWithCid:(NSString *)cid media:(NSString *)mediaString personal:(NSString *)personal mapstring:(NSString *)map{
    NSDictionary *dict = [self getHomeWatchWithCid:cid];
    NSString *sql;
    if (dict && dict.allValues.count != 0) {
        if (mediaString.length != 0) {
            sql = [NSString stringWithFormat:@"update t_watchHomeInfo set cid_media = '%@' where cid = '%@'",mediaString,cid];
            [self.handler performExecuteQueryWithSql:sql];
        }
        if (personal.length != 0) {
            sql = [NSString stringWithFormat:@"update t_watchHomeInfo set cid_status = '%@' where cid = '%@'",personal,cid];
            [self.handler performExecuteQueryWithSql:sql];
        }
        if (map.length != 0) {
            sql = [NSString stringWithFormat:@"update t_watchHomeInfo set cid_map = '%@' where cid = '%@'",map,cid];
            [self.handler performExecuteQueryWithSql:sql];
        }
    }else{
        sql = [NSString stringWithFormat:@"insert into t_watchHomeInfo ('cid','cid_map','cid_media','cid_status') values ('%@','%@','%@','%@')",cid,map,mediaString,personal];
    }
    [self.handler performExecuteQueryWithSql:sql];
}


/**
 获取首页某个手表的数据
 */
-(NSDictionary *)getHomeWatchWithCid:(NSString *)cid{
    NSString *sql = [NSString stringWithFormat:@"select * from t_watchHomeInfo where cid = '%@'",cid];
    TResultSet *rs = [self.handler performExecuteQueryWithSql:sql];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    while([rs hasNext])
    {
        NSString *cid = [rs stringForColumn:@"cid"];
        NSString *cid_map = [rs stringForColumn:@"cid_map"];
        NSString *cid_media = [rs stringForColumn:@"cid_media"];
        NSString *cid_status = [rs stringForColumn:@"cid_status"];
        [mDict setObject:cid forKey:@"cid"];
        [mDict setObject:cid_map forKey:@"cid_map"];
        [mDict setObject:cid_media forKey:@"cid_media"];
        [mDict setObject:cid_status forKey:@"cid_status"];
    }
    return mDict;
}

/**
 根据cid 和 deviceUserId来判断是否需要重新在指定时间范围内刷新接口数据 yes 需要刷新 no 不需要刷新
 
 @param cid 设备cid
 @param deviceUserId 设备deviceUid
 */
-(BOOL)checkHomeWatchIsNeedLoadingWithCid:(NSString *)cid deviceUserId:(NSString *)deviceUserId{
    //字典中根据cid缓存cid 发送网络请求的时间值 和 deviceUserId。每次进来检查时间值是否超过约定时长，如果在约定时长内，直接返回 no 否则返回yes
    NSString *timeString = [self currentTimeString];
    if ([self.cidDictM.allKeys containsObject:cid]) {
        NSDictionary *dict = [self.cidDictM objectForKey:cid];
        NSString *currentTimeString = [dict objectForKey:@"time"];
        if (currentTimeString.intValue - timeString.intValue < REFRESH_DATE) {
            return NO;
        }else{
            return YES;
        }
    }else{
        NSMutableDictionary *timeDict = [NSMutableDictionary dictionaryWithCapacity:3];
        [timeDict setObject:timeString forKey:@"time"];
        [timeDict setObject:deviceUserId forKey:@"deviceUserId"];
        [self.cidDictM setObject:timeDict forKey:cid];
        return YES;
    }
    return NO;
}

-(void)updateHomeWatchLoadingWithCid:(NSString *)cid deviceUserId:(NSString *)deviceUserId{
    NSString *timeString = [self currentTimeString];
    if ([self.cidDictM.allKeys containsObject:cid]) {
        NSDictionary *dict = [self.cidDictM objectForKey:cid];
        [dict setValue:timeString forKey:@"time"];
        [self.cidDictM setValue:dict forKey:cid];
    }else{
        NSMutableDictionary *timeDict = [NSMutableDictionary dictionaryWithCapacity:3];
        [timeDict setObject:timeString forKey:@"time"];
        [timeDict setObject:deviceUserId forKey:@"deviceUserId"];
        [self.cidDictM setObject:timeDict forKey:cid];
    }
}


-(NSString *)currentTimeString{
    int startTime = (int)[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d",startTime];
}



@end
