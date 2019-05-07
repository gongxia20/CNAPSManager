//
//  NSDictionary+SafetyGet.h
//  Expert
//
//  Created by 刘华舟 on 15/4/2.
//  Copyright (c) 2015年 BLUEBLACK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSDictionary (SafetyGet)

- (NSInteger)integerForKey:(NSString *)key;
- (long)longForKey:(NSString *)key;

- (long long)longLongForKey:(NSString *)key;

- (CGFloat)floatForKey:(NSString *)key;

- (double)doubleForKey:(NSString *)key;

//- (NSNumber *)numberForKey:(NSString *)key;

- (NSString *)stringForKey:(NSString *)key; // 值为nil时返回""

- (BOOL)boolForKey:(NSString *)key;

- (NSArray *)arrayForKey:(NSString *)key; // 值不是数组时返回nil

- (NSDictionary *)dictionaryForKey:(NSString *)key; // 值不是字典时返回nil

- (id)objectValueForKey:(NSString *)key;

- (NSData *)dataForKey:(NSString *)key;

- (NSDate *)dateForKey:(NSString *)key;

- (BOOL)isNullForKey:(NSString *)key;


@end
