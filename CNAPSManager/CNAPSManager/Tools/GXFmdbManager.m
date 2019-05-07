//
//  GXFmdbManager.m
//  CNAPSManager
//
//  Created by James on 2019/2/25.
//  Copyright © 2019 James. All rights reserved.
//

#import "GXFmdbManager.h"

@interface GXFmdbManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@end

@implementation GXFmdbManager

+ (GXFmdbManager *)sharedInstance
{
    static id fmdbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmdbManager = [[self alloc] init];
    });
    return fmdbManager;
}

// 在bank中取数据
- (NSMutableArray *)openBankData {
    // 0.获取数据库文件地址
    NSString *dbPath=[[NSBundle mainBundle] pathForResource:@"DB_bankInfo.sqlite" ofType:nil];
    NSLog(@"%@",dbPath);
    
    // 1.创建数据库
    // 如果数据库文件不存在, 就会自动创建文件, 如果存在则不会创建
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    self.dbQueue = dbQueue;
    NSMutableDictionary *bankDict = [NSMutableDictionary dictionary];
    NSMutableArray *bankArray = [NSMutableArray array];
    
    // 2.打开数据库
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *setStr = [NSString stringWithFormat:@"select * from bank"];
        FMResultSet *set = [db executeQuery:setStr];
        
        while([set next]) {
                // 取出当前行对应的记录
                NSString *id = [set stringForColumn:@"id"];
                NSString *name = [set stringForColumn:@"name"];

                [bankDict setObject:id forKey:@"id"];
                [bankDict setObject:name forKey:@"name"];
            
                [bankArray addObject:[bankDict copy]];
               }
        [set close];
    }];
    return bankArray;
}

// 在area中取数据
- (NSMutableArray *)openAreaData:(NSString *)bankProvince {
    // 0.获取数据库文件地址
    NSString *dbPath=[[NSBundle mainBundle] pathForResource:@"DB_bankInfo.sqlite" ofType:nil];
    
    // 1.创建数据库
    // 如果数据库文件不存在, 就会自动创建文件, 如果存在则不会创建
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    self.dbQueue = dbQueue;
    NSMutableDictionary *bankDict = [NSMutableDictionary dictionary];
    NSMutableArray *bankArray = [NSMutableArray array];
    
    // 2.打开数据库
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *setStr = [NSString stringWithFormat:@"select * from area where province LIKE '%%%@%%'",bankProvince];
        FMResultSet *set = [db executeQuery:setStr];
        
        while([set next]) {
                // 取出当前行对应的记录
                NSString *id = [set stringForColumn:@"id"];
                NSString *province = [set stringForColumn:@"province"];
                NSString *city = [set stringForColumn:@"city"];
            
                [bankDict setObject:id forKey:@"id"];
                [bankDict setObject:province forKey:@"province"];
                [bankDict setObject:city forKey:@"city"];
            
                [bankArray addObject:[bankDict copy]];
        }
        [set close];
    }];
    
    return bankArray;
}

- (NSMutableArray *)openCnapsData:(NSString *)bankModelName cityName:(NSString *)cityName {
    NSString *str = [NSString stringWithFormat:@"select * from cnaps where province LIKE '%%%@%%' and city LIKE '%%%@%%'",bankModelName,cityName];
    NSMutableArray *array = [self openCnapsDataCommon:str];
    
    return array;
}

- (NSMutableArray *)openCnapsData:(NSString *)branchBankName {
    NSString *str = [NSString stringWithFormat:@"select * from cnaps where BranchBankName LIKE '%%%@%%'",branchBankName];
    NSMutableArray *array = [self openCnapsDataCommon:str];
    
    return array;
}

- (NSMutableArray *)openCnapsDataCommon:(NSString *)str {
    // 0.获取数据库文件地址
    NSString *dbPath=[[NSBundle mainBundle] pathForResource:@"DB_bankInfo.sqlite" ofType:nil];
    //    NSLog(@"%@",dbPath);
    
    // 1.创建数据库
    // 如果数据库文件不存在, 就会自动创建文件, 如果存在则不会创建
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    self.dbQueue = dbQueue;
    NSMutableDictionary *bankDict = [NSMutableDictionary dictionary];
    NSMutableArray *bankArray = [NSMutableArray array];
    
    // 2.打开数据库
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *setStr = str;
        //        SELECT * FROM cnaps WHERE province LIKE '%直辖市工商银行%' AND city LIKE '%重%'
        FMResultSet *set = [db executeQuery:setStr];
        
        while([set next]) {
            // 取出当前行对应的记录
            NSString *id = [set stringForColumn:@"id"];
            NSString *bankName = [set stringForColumn:@"bankName"];
            NSString *province = [set stringForColumn:@"province"];
            NSString *city = [set stringForColumn:@"city"];
            NSString *BranchBankName = [set stringForColumn:@"BranchBankName"];
            NSString *BranchBankCnaps = [set stringForColumn:@"BranchBankCnaps"];
            NSString *BranchBankAddress = [set stringForColumn:@"BranchBankAddress"];
            //                NSLog(@"id=%@, bankName= %@ province=%@, city=%@,BranchBankName=%@,BranchBankCnaps=%@,BranchBankAddress=%@", id,bankName, province,city,BranchBankName,BranchBankCnaps,BranchBankAddress);
            
            [bankDict setObject:id forKey:@"id"];
            [bankDict setObject:bankName forKey:@"bankName"];
            [bankDict setObject:province forKey:@"province"];
            [bankDict setObject:city forKey:@"city"];
            [bankDict setObject:BranchBankName forKey:@"BranchBankName"];
            [bankDict setObject:BranchBankCnaps forKey:@"BranchBankCnaps"];
            [bankDict setObject:BranchBankAddress forKey:@"BranchBankAddress"];
            
            [bankArray addObject:[bankDict copy]];
        }
        [set close];
    }];
    
    return bankArray;
}


@end

