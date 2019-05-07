#import <Foundation/Foundation.h>

@interface TBaseInfoManager : NSObject

+ (TBaseInfoManager *)shareManager;

- (void)setBaseInfoObject:(id)object forKey:(id)key;
- (void)setDictBaseInfoObject:(NSDictionary *)dict forKey:(id)key;
- (void)setArrayBaseInfoObject:(NSArray *)array forKey:(id)key;

- (NSDictionary *)dictBaseInfoObjectForKey:(id)key;
- (NSArray *)arrayBaseInfoObjectForKey:(id)key;

- (id)baseInfoObjectForKey:(id)key;

-(void)saveJsonDictionarytoFm:(NSMutableDictionary *)jsonDict;

-(void)loadOriginalDictionary:(NSMutableDictionary *)originDict;

@end
