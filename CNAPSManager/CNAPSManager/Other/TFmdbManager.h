#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface TFmdbManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;// 线程安全的数据库


+ (TFmdbManager *)sharedManager;

// 创建表
- (BOOL)createFmdbTableWithSql:(NSString *)sql andTableName:(NSString *)tableName atFmdb:(FMDatabaseQueue *)fmdbQueue;

// 检查表是否存在
- (BOOL)checkoutFmdbIncludeTableWithTableName:(NSString *)tableName;

// 检查表中是否存在数据
- (BOOL)checkoutTableIncludeDataWithTableName:(NSString *)tableName;

// 删除表
- (BOOL)deleteTableWithTableName:(NSString *)tableName;

// 将数据保存到表
- (BOOL)saveDataToTableWithData:(NSData*)data tableName:(NSString *)tableName;

// 从表中读取数据
- (NSData *)dataFromTableWithTableName:(NSString *)tableName;


// 关闭数据库
- (void)closeDataBase;

//执行 sql 的 executeUpdate 语句
- (BOOL)performExecuteUpdateWithSql:(NSString *)sql;
- (BOOL)performExecuteUpdateWithSql:(NSString *)sql withArguments:(NSArray *)arguments;
//执行 sql 的 executeQuery 语句
- (FMResultSet *)performExecuteQueryWithSql:(NSString *)sql;
- (FMResultSet *)performExecuteQueryWithSql:(NSString *)sql withArguments:(NSArray *)arguments;


@end



@interface TResultSet : NSObject

@property (nonatomic, assign, readonly) NSUInteger rowCount; // 行数
@property (nonatomic, assign, readonly) NSUInteger columnCount; // 列数
@property (nonatomic, strong, readonly) NSArray *allColumnName;
@property (nonatomic, assign, readonly) BOOL hasNext;

- (instancetype)initWithDataArray:(NSArray *)dataArray columnNameToIndexMap:(NSDictionary *)columnNameToIndexMap;

- (NSInteger)columnIndexForName:(NSString *)columnName;
- (NSString *)columnNameForIndex:(NSInteger)columnIndex;

- (NSInteger)intForColumn:(NSString *)columnName;
- (NSInteger)intForColumnIndex:(NSInteger)columnIndex;

- (long)longForColumn:(NSString *)columnName;
- (long)longForColumnIndex:(NSInteger)columnIndex;

- (long long)longLongIntForColumn:(NSString *)columnName;
- (long long)longLongIntForColumnIndex:(NSInteger)columnIndex;

- (BOOL)boolForColumn:(NSString *)columnName;
- (BOOL)boolForColumnIndex:(NSInteger)columnIndex;

- (double)doubleForColumn:(NSString *)columnName;
- (double)doubleForColumnIndex:(NSInteger)columnIndex;

- (NSString *)stringForColumn:(NSString *)columnName;
- (NSString *)stringForColumnIndex:(NSInteger)columnIndex;

- (NSDate *)dateForColumn:(NSString *)columnName;
- (NSDate *)dateForColumnIndex:(NSInteger)columnIndex;

- (NSData *)dataForColumn:(NSString *)columnName;
- (NSData *)dataForColumnIndex:(NSInteger)columnIndex;

- (id)objectForColumnName:(NSString *)columnName;
- (id)objectForColumnIndex:(NSInteger)columnIndex;

- (BOOL)columnIsNullColumnName:(NSString *)columnName;
- (BOOL)columnIsNullForIndex:(NSInteger)columnIndex;


@end
