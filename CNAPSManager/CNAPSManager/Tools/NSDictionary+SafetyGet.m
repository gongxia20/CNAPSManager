//
//  NSDictionary+SafetyGet.m
//  Expert
//
//  Created by 刘华舟 on 15/4/2.
//  Copyright (c) 2015年 BLUEBLACK. All rights reserved.
//

#import "NSDictionary+SafetyGet.h"
//#import "NSMassKit.h"

@implementation NSDictionary (SafetyGet)

- (NSInteger)integerForKey:(NSString *)key{
    return [[self objectValueForKey:key] integerValue];
}
- (long)longForKey:(NSString *)key{
    return [[self objectValueForKey:key] longValue];
}
- (long long)longLongForKey:(NSString *)key{
    return [[self objectValueForKey:key] longLongValue];
}

- (CGFloat)floatForKey:(NSString *)key{
    return [[self objectValueForKey:key] floatValue];
}

- (double)doubleForKey:(NSString *)key{
    return [[self objectValueForKey:key] doubleValue];
}

//- (NSNumber *)numberForKey:(NSString *)key{
//    if([[self objectValueForKey:key] isKindOfClass:[NSNumber class]]){
//        return [self objectValueForKey:key];
//    }
//    return [NSNumber numberWithInt:0];
//}

- (NSString *)stringForKey:(NSString *)key{
    if([self objectValueForKey:key] != nil){
        if([[self objectValueForKey:key] isKindOfClass:[NSString class]]){
            return [self objectValueForKey:key];
        }else if([[self objectValueForKey:key] isKindOfClass:[NSNumber class]]){
            return [[self objectValueForKey:key] stringValue];
        }else{
            return [NSString stringWithFormat:@"%@", [self objectValueForKey:key]];
        }
    }
    return @"";
}

- (BOOL)boolForKey:(NSString *)key{
    return [[self objectValueForKey:key] boolValue];
}

- (NSArray *)arrayForKey:(NSString *)key{
    if([[self objectValueForKey:key] isKindOfClass:[NSArray class]]){
        return [self objectValueForKey:key];
    }
    return @[];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key{
    if([[self objectValueForKey:key] isKindOfClass:[NSDictionary class]]){
        return [self objectValueForKey:key];
    }
    return @{};
}

- (id)objectValueForKey:(NSString *)key{
    if(![self isNullForKey:key]){
        return [self objectForKey:key];
    }
    return nil;
}

- (NSData *)dataForKey:(NSString *)key{
    if([[self objectForKey:key] isKindOfClass:[NSData class]]){
        return [self objectForKey:key];
    }
    
    return [NSData data];
}

- (NSDate *)dateForKey:(NSString *)key{
    if([[self objectForKey:key] isKindOfClass:[NSDate class]]){
        return [self objectForKey:key];
    }
    
    return [NSDate date];
}

- (BOOL)isNullForKey:(NSString *)key{
    return [[self objectForKey:key] isKindOfClass:[NSNull class]];
}

@end
