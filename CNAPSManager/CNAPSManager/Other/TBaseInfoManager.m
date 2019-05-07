#import "TBaseInfoManager.h"
#import "TFmdbManager.h"

@interface TBaseInfoManager ()

@property (strong, nonatomic) TFmdbManager *handler;

@property (nonatomic, retain) NSMutableDictionary * baseInfoDic;

@end

static TBaseInfoManager *manager = nil;

@implementation TBaseInfoManager

+ (TBaseInfoManager *)shareManager
{
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (!manager) {
            manager = [[TBaseInfoManager alloc] initManager];
//        }
//    });
    return manager;
    
}

- (instancetype)initManager{
    if (self = [super init]) {
        self.handler = [TFmdbManager sharedManager];

        // 1.创建上传日志记录失败缓存表
        NSString *createTableSQL = @"create table if not exists t_baseconfig_info(key text primary key, value blob);";
        [self createTable:@"t_baseconfig_info" withSQL:createTableSQL];
        
        self.baseInfoDic = [self loadAllKeyAndValue];
    }
    return self;
}

- (void)createTable:(NSString *)tableName withSQL:(NSString *)sql{
    
    if (![self.handler checkoutFmdbIncludeTableWithTableName:tableName]) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [self.handler createFmdbTableWithSql:sql andTableName:tableName atFmdb:appDelegate.databaseQueue];
    }
}

- (id)baseInfoObjectForKey:(id)key
{
    id object = [self.baseInfoDic objectForKey:key];
    return object;
}

-(void)saveJsonDictionarytoFm:(NSMutableDictionary *)jsonDict
{
    NSMutableArray *dbArray = [NSMutableArray array];
    for (NSString *key in [jsonDict allKeys]) {

        id value = [jsonDict  objectForKey:key];

        NSMutableDictionary* data =  [NSMutableDictionary dictionary];
        if ([value isKindOfClass:[NSDate class]]) {
            [data setObject:@(1) forKey:@"NSDate"];
            [data setObject:@([(NSDate *)value timeIntervalSince1970]) forKey:@"value"];
        }else{
            [data setObject:@(0) forKey:@"NSDate"];
            [data setObject:value forKey:@"value"];
        }

        NSData* valueData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        
        NSArray *argument = @[key, valueData];

        [dbArray addObject:argument];

    }
    [self.handler.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        /** 更新数据 -write by khzliu */
        for (int i = 0; i < dbArray.count ; i++) {
            NSArray *argument = [dbArray objectAtIndex:i];
            NSString *sql = @"replace into t_baseconfig_info(key, value) values (?,?)";
            /** 插入新数据失败 则回滚并返回 -write by khzliu */
            if (![db executeUpdate:sql withArgumentsInArray:argument]) {
                *rollback = YES;
                return;
            }
        }
        AppDelegate *appDelegate = APP_DELEGATE;

        NSString *flag = @"0";

        [[NSUserDefaults standardUserDefaults] setObject:appFmdbVersion forKey:@"fmdbVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        if (!(appDelegate.origMutDict.allKeys.count > 0) &&  [[appDelegate.origMutDict objectForKey:@"url_sync"] length] > 0) {
            //bcMsg7: 首次对用户账户信息的创建
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BcMsg7" object:nil];
        }

//        if((!(appDelegate.origMutDict.allKeys.count > 0) && ([[jsonDict objectForKey:@"page_category_v"] length] > 0)) || ((appDelegate.origMutDict.allKeys.count > 0)  &&  ([[jsonDict objectForKey:@"page_category_v"] length] > 0) && ([jsonDict stringForKey:@"page_category_v"] !=  [appDelegate.origMutDict objectForKey:@"page_category_v"])))
//        {
//            flag = [NSString stringWithFormat:@"%@%@",flag,@"1"];
//        }else{
//            flag = [NSString stringWithFormat:@"%@%@",flag,@"0"];
//        }
//
//        appDelegate.origMutDict = jsonDict;
//
//        if ([flag isEqualToString:@"01"]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"BcMsg6" object:nil];
//            });
//        }else if ([flag isEqualToString:@"00"]){
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"BcMsg5" object:[NSString stringWithFormat:@"%@",@"2"]];
//        }
    }];
}

- (NSMutableDictionary *)loadAllKeyAndValue
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    NSString *sql = @"select * from t_baseconfig_info";
    TResultSet *set = [self.handler performExecuteQueryWithSql:sql];
    while (set.hasNext) {
        NSString* key = [set stringForColumn:@"key"];
        
        NSDictionary* valueDict = [NSJSONSerialization JSONObjectWithData:(NSData *)[set objectForColumnName:@"value"]
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:nil];
        id value = [valueDict objectForKey:@"value"];

        if ([[valueDict numberForKey:@"NSDate"] boolValue]) {
            value = [[NSDate alloc] initWithTimeIntervalSince1970:[(NSNumber *)value doubleValue]];
        }
        if (value != nil && key != nil) {
            [result setObject:value forKey:key];
        }
    }
    
   return result;
}

-(void)loadOriginalDictionary:(NSMutableDictionary *)originDict
{
    NSString *sql = @"select * from t_baseconfig_info";
    TFmdbManager *handler = [TFmdbManager sharedManager];
    TResultSet *set = [handler performExecuteQueryWithSql:sql];

    while (set.hasNext) {
        NSString* key = [set stringForColumn:@"key"];
        NSDictionary* valueDict = [NSJSONSerialization JSONObjectWithData:(NSData *)[set objectForColumnName:@"value"]
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:nil];
        
        id value = [valueDict objectForKey:@"value"];

        if ([[valueDict numberForKey:@"NSDate"] boolValue]) {
            value = [[NSDate alloc] initWithTimeIntervalSince1970:[(NSNumber *)value doubleValue]];
        }
        if (value != nil && key != nil) {
            [originDict setObject:value forKey:key];
        }
    }
}

- (void)setBaseInfoObject:(id)object forKey:(id)key
{
    if (!object) {
        BKLogDebug(@" 您需要保存的 object %@ 为 nil",object);
        return;
    }
    
    [self.baseInfoDic setObject:object forKey:key];
        [self updateWithKey:key value:object];
}

- (void)setDictBaseInfoObject:(NSDictionary *)dict forKey:(id)key
{
    if (!dict) {
        BKLogDebug(@" 您需要保存的 object %@ 为 nil",dict);
        return;
    }
    [self.baseInfoDic setObject:dict forKey:key];
        [self updateWithKey:key value:dict];
}

- (void)setArrayBaseInfoObject:(NSArray *)array forKey:(id)key
{
    if (!array) {
        BKLogDebug(@" 您需要保存的 object %@ 为 nil",array);
        return;
    }
    
    [self.baseInfoDic setObject:array forKey:key];
    [self updateWithKey:key value:array];
}

- (NSDictionary *)dictBaseInfoObjectForKey:(id)key
{
    NSDictionary * dic = [self.baseInfoDic dictForKey:key];
    return dic;
}

- (NSArray *)arrayBaseInfoObjectForKey:(id)key
{
    NSArray * array = [self.baseInfoDic arrayForKey:key];
    return array;
}

- (void)updateWithKey:(NSString *)key value:(id)value
{
    if (key == nil || value == nil) {
        return;
    }
    
    NSMutableDictionary* data =  [NSMutableDictionary dictionary];
    if ([value isKindOfClass:[NSDate class]]) {
        [data setObject:@(1) forKey:@"NSDate"];
        [data setObject:@([(NSDate *)value timeIntervalSince1970]) forKey:@"value"];
    }else{
        [data setObject:@(0) forKey:@"NSDate"];
        [data setObject:value forKey:@"value"];
    }
    
    NSData *valueData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];

    
    [self.handler.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        /** 更新数据 -write by khzliu */
        NSString *sql = @"replace into t_baseconfig_info(key, value) values (?,?)";
        
        
        NSArray *arguments = @[key, valueData];
        
        /** 插入新数据失败 则回滚并返回 -write by khzliu */
        if (![db executeUpdate:sql withArgumentsInArray:arguments]) {
            *rollback = YES;
            return;
        }
        
    }];
}

-(NSDictionary *)loadBaseInfoDict
{
    id object = self.baseInfoDic;
    
    return object;
}


@end
