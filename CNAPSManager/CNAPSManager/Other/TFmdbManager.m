#import "TFmdbManager.h"
#import "AppDelegate.h"
#import "NSDictionary+SafetyGet.h"


@implementation TFmdbManager

+ (TFmdbManager *)sharedManager
{
    static TFmdbManager *fmdbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmdbManager = [[TFmdbManager alloc] init];
    });
    
    return fmdbManager;
}

//// 懒加载初始化数据库
//- (FMDatabaseQueue *)databaseQueue
//{
//    if (!_databaseQueue) {
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        _databaseQueue = delegate.databaseQueue;
//    }
//    return _databaseQueue;
//}

- (void)loadDatabaseQueue
{
    if (!_databaseQueue) {
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:appDBPath];
    }
}

// 创建表
- (BOOL)createFmdbTableWithSql:(NSString *)sql andTableName:(NSString *)tableName atFmdb:(FMDatabaseQueue *)fmdbQueue
{
    __block BOOL isSuccess = NO;
    
    // 通过block，拿到FMDatabase *db
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        // 判断表是否存在
        if (![db tableExists:tableName]) {
            // 创建表
            BOOL userIsOk = [db executeUpdate:sql];
            if (userIsOk) {
                isSuccess = YES;
                NSLog(@"创建表成功。。。");
            }else {
                isSuccess = NO;
                NSLog(@"创建表失败==%@",sql);
            }
        }else {
            NSLog(@"要创建的表%@已经存在，无需重复创建",tableName);
        }
    }];
    
    return isSuccess;
}

// 检查表是否存在
- (BOOL)checkoutFmdbIncludeTableWithTableName:(NSString *)tableName
{
    NSString *querySQL = [NSString stringWithFormat:@"select count(*) as table_count from sqlite_master t where t.type = 'table' and t.name = '%@'", tableName];
    
    __block BOOL isExist = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:appFmdbPath]) {//数据库文件已经存在
        [_databaseQueue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *rs = [db executeQuery:querySQL];
            if([rs next]){
                isExist = [rs intForColumn:@"table_count"];
            }
            [rs close];
        }];
    } else {//数据库文件都不存在,第一次进入这个页面
        isExist = NO;
    }
    
    return isExist;
}

// 检查表中是否存在数据
- (BOOL)checkoutTableIncludeDataWithTableName:(NSString *)tableName
{
    __block BOOL includeData = NO;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql_one = [NSString stringWithFormat:@"select * from sqlite_master where name  = '%@';",tableName];
        
        FMResultSet *set = [db executeQuery:sql_one];
        
        BOOL setFlag = [set next];
        if (setFlag){
            NSString *sql_two = [NSString stringWithFormat:@"select * from %@;",tableName];
            FMResultSet *rs = [db executeQuery:sql_two];
            
            BOOL rsFlag = [rs next];
            if (rsFlag) {
                NSLog(@"表格中数据是存在的");
                includeData = YES;
            } else {
                NSLog(@"表格中数据不存在");
                includeData =  NO;
            }
            [rs close];
            
        } else {
            includeData =  NO;
        }
        [set close];
    }];
    
    return includeData;
}

// 删除表
- (BOOL)deleteTableWithTableName:(NSString *)tableName
{
    __block BOOL dropTable = NO;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"select * from sqlite_master where name  = '%@';",tableName]];
        BOOL flag = [set next];
        [set close];
        if (flag) {//表是存在的
            BOOL dropFlag = [db executeUpdate:[NSString stringWithFormat:@"drop table %@;",tableName]];
            if (dropFlag) {
                NSLog(@"表格存在,并且已经删除");
                dropTable = YES;
            } else {
                NSLog(@"表格存在,但未删除");
                dropTable = NO;
            }
        } else {
            NSLog(@"表格不存在,不用执行删除语句");
            dropTable = NO;
        }
    }];
    
    return dropTable;
}

// 将数据保存到表
- (BOOL)saveDataToTableWithData:(NSData*)data tableName:(NSString *)tableName
{
    __block BOOL saveDataToTable = NO;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString *setStr = [NSString stringWithFormat:@"insert into %@ (Data) values (?);",tableName];
        BOOL flag = [db executeUpdate: setStr,data];
        if (flag) {
            NSLog(@"已经将数据添加到了 %@ 表中",tableName);
            saveDataToTable = YES;
        } else {
            NSLog(@"没有将数据添加到 %@ 表中",tableName);
            saveDataToTable = NO;
        }
    }];
    
    return saveDataToTable;
}

// 从表中读取数据
- (NSData *)dataFromTableWithTableName:(NSString *)tableName
{
    __block NSData * dataFromTable;
    
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString *setStr = [NSString stringWithFormat:@"select * from sqlite_master where name = '%@';",tableName];
        FMResultSet *set = [db executeQuery:setStr];
        BOOL setFlag = [set next];
        
        if (setFlag){
            NSString *rsStr = [NSString stringWithFormat:@"select * from %@;",tableName];
            FMResultSet *rs = [db executeQuery:rsStr];
            BOOL rsFlag = [rs next];
            if (rsFlag) {
                dataFromTable = [rs dataForColumn:@"Data"];
            }
            [rs close];
        }
        [set close];
    }];
    
    return dataFromTable;
}




// 关闭数据库
- (void)closeDataBase
{
    if (_databaseQueue) {
        [_databaseQueue close];
    }
}

#pragma mark - 执行 sql 的 executeUpdate 语句
- (BOOL)performExecuteUpdateWithSql:(NSString *)sql
{
    __block BOOL executeUpdate = NO;
    [self loadDatabaseQueue];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        
        BOOL flag = [db executeUpdate:sql];
        if (flag) {
            executeUpdate = YES;
        } else {
            executeUpdate = NO;
        }
    }];
    
    return executeUpdate;
    
}

- (BOOL)performExecuteUpdateWithSql:(NSString *)sql withArguments:(NSArray *)arguments{
    [self loadDatabaseQueue];
    __block BOOL isSuccess = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:sql withArgumentsInArray:arguments];
    }];
    
    return isSuccess;
}

- (TResultSet *)performExecuteQueryWithSql:(NSString *)sql
{
    [self loadDatabaseQueue];
    __block FMResultSet * resultSet = nil;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet * rs = [db executeQuery:sql];
        resultSet = [self convertResultSet:rs];
        
        [rs close];
        
    }];
    
    return resultSet;
}

- (TResultSet *)performExecuteQueryWithSql:(NSString *)sql withArguments:(NSArray *)arguments{
    [self loadDatabaseQueue];
    __block FMResultSet *resultSet = nil;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:arguments];
        resultSet = [self convertResultSet:rs];
        
        [rs close];
        
    }];
    return resultSet;
}

#pragma -mark 结果集转换

- (TResultSet *)convertResultSet:(FMResultSet *)resultSet{
    NSMutableArray *resultSetArray = [NSMutableArray array];
    NSInteger columnCount = [resultSet columnCount];
    
    while ([resultSet next]) {
        NSMutableDictionary *valuesMap = [NSMutableDictionary dictionary];
        for(int index = 0; index < columnCount; index ++){
            // 以小写key存储
            NSString *columnName = [[resultSet columnNameForIndex:index] lowercaseString];
            [valuesMap setValue:[resultSet objectForColumnIndex:index] forKey:columnName];
        }
        [resultSetArray addObject:[valuesMap copy]];
    }
    
    return [[TResultSet alloc] initWithDataArray:[resultSetArray copy] columnNameToIndexMap:resultSet.columnNameToIndexMap];
}


- (NSArray *)arrayWithVaList:(va_list)vaList{
    NSMutableArray *mutableArray = [NSMutableArray array];
    id va = nil;
    while((va = va_arg(vaList,id)))  {
        if(va != nil){
            [mutableArray addObject:va];
        }
    }
    
    return [mutableArray copy];
}

@end


@interface TResultSet(){
    NSUInteger _rowCount;
    NSUInteger _columnCount;
}

@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, strong) NSMutableDictionary *columnIndexToNameMap;
@property (nonatomic, strong) NSDictionary *columnNameToIndexMap;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TResultSet

static NSString *columnIndexToNameKey = @"ColumnIndexToNameKey";

- (instancetype)initWithDataArray:(NSArray *)dataArray columnNameToIndexMap:(NSDictionary *)columnNameToIndexMap{
    if(self = [super init]){
        _columnCount = 0;
        _rowCount = [dataArray count];
        _currentRow = -1;
        self.columnNameToIndexMap = columnNameToIndexMap;
        self.dataArray = dataArray;
    }
    return self;
}

- (NSMutableDictionary *)columnIndexToNameMap{
    if(_columnIndexToNameMap == nil){
        _columnIndexToNameMap = [NSMutableDictionary dictionary];
    }
    return _columnIndexToNameMap;
}

- (void)setColumnNameToIndexMap:(NSMutableDictionary *)columnNameToIndexMap{
    if(_columnNameToIndexMap == nil){
        _columnCount = [columnNameToIndexMap count];
        _columnNameToIndexMap = columnNameToIndexMap;
        NSArray *values = [columnNameToIndexMap allValues];
        NSArray *keys = [columnNameToIndexMap allKeys];
        for(NSInteger index = 0; index < keys.count; index ++){
            NSString *key = [NSString stringWithFormat:@"%@%@", columnIndexToNameKey, values[index]];
            [self.columnIndexToNameMap setValue:keys[index] forKey:key];
        }
    }
}

- (BOOL)hasNext{
    
    NSInteger currentRow = [[NSNumber numberWithInteger:self.currentRow] integerValue];
    NSInteger rowCount = [[NSNumber numberWithInteger:self.rowCount] integerValue];
    BOOL hasNextRow = (rowCount > 0 && currentRow < rowCount - 1);
    if(hasNextRow){
        self.currentRow ++;
    }
    return hasNextRow;
}

- (NSUInteger)rowCount{
    return _rowCount;
}

- (NSUInteger)columnCount{
    return _columnCount;
}

- (NSArray *)allColumnName{
    return [_columnNameToIndexMap allKeys];
}

- (NSInteger)columnIndexForName:(NSString*)columnName{
    return [_columnNameToIndexMap integerForKey:[columnName lowercaseString]];
}

- (NSString *)columnNameForIndex:(NSInteger)columnIndex{
    NSString *name = [NSString stringWithFormat:@"%@%ld", columnIndexToNameKey, (long)columnIndex];
    return [self.columnIndexToNameMap stringForKey:name];
}

- (NSInteger)intForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary integerForKey:[columnName lowercaseString]];
}

- (NSInteger)intForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self intForColumn:columnName];
}

- (long)longForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return (long)[valueDictionary longLongForKey:[columnName lowercaseString]];
}

- (long)longForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self longForColumn:columnName];
}

- (long long)longLongIntForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary longLongForKey:[columnName lowercaseString]];
}

- (long long)longLongIntForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self longLongIntForColumn:columnName];
}

- (BOOL)boolForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary boolForKey:[columnName lowercaseString]];
}

- (BOOL)boolForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self boolForColumn:columnName];
}

- (double)doubleForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary doubleForKey:[columnName lowercaseString]];
}

- (double)doubleForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self doubleForColumn:columnName];
}

- (NSString *)stringForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary stringForKey:[columnName lowercaseString]];
}

- (NSString *)stringForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self stringForColumn:columnName];
}

- (NSDate *)dateForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary dateForKey:[columnName lowercaseString]];
}

- (NSDate *)dateForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self dateForColumn:columnName];
}

- (NSData *)dataForColumn:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary dataForKey:[columnName lowercaseString]];
}

- (NSData *)dataForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self dataForColumn:columnName];
}

- (id)objectForColumnName:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary objectValueForKey:[columnName lowercaseString]];
}

- (id)objectForColumnIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self objectForColumnName:columnName];
}

- (BOOL)columnIsNullForIndex:(NSInteger)columnIndex{
    NSString *columnName = [self columnNameForIndex:columnIndex];
    return [self columnIsNullColumnName:columnName];
}

- (BOOL)columnIsNullColumnName:(NSString *)columnName{
    NSDictionary *valueDictionary = self.dataArray[self.currentRow];
    return [valueDictionary isNullForKey:[columnName lowercaseString]];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"\n{\n\t\"rowCount\" : \"%lu\", \n\t\"columnCount\" : \"%lu\", \n\t\"data\" : \"%@\"\n}", (unsigned long)[self rowCount], (unsigned long)[self columnCount], [self arrayToString:self.dataArray]];
}

- (NSString *)arrayToString:(NSArray *)array{
    NSMutableString *mutableString = [NSMutableString string];
    [mutableString appendString:@"["];
    for(NSInteger index = 0; index < array.count; index ++){
        NSDictionary *dictionary = array[index];
        if(index != 0){
            [mutableString appendFormat:@"\t%@", [self dictionaryToString:dictionary]];
        }else{
            [mutableString appendString:[self dictionaryToString:dictionary]];
        }
        
        if(index != array.count - 1){
            [mutableString appendString:@", \n"];
        }
    }
    
    [mutableString appendString:@"]"];
    return [mutableString copy];
}

- (NSString *)dictionaryToString:(NSDictionary *)dictionary{
    NSMutableString *mutableString = [NSMutableString string];
    NSArray *keys = [dictionary allKeys];
    [mutableString appendString:@"{\n"];
    for(NSInteger index = 0; index < keys.count; index ++){
        NSString *key = keys[index];
        if([dictionary[key] isKindOfClass:[NSData class]]){
            // 字典中的二进制数据显示为'<blob>'
            [mutableString appendFormat:@"\t\t\"%@\" : <blob>", key];
        }else{
            [mutableString appendFormat:@"\t\t\"%@\" : \"%@\"", key, [dictionary stringForKey:key]];
        }
        
        if(index != keys.count - 1){
            [mutableString appendString:@", \n"];
        }
    }
    
    [mutableString appendString:@"\n\t}"];
    return [mutableString copy];
}

@end
