//
//  NSArray+LogPrintString.m
//  CNAPSManager
//
//  Created by James on 2019/2/22.
//  Copyright © 2019 James. All rights reserved.
//

#import "NSArray+LogPrintString.h"


@implementation NSArray (LogPrintString)

// 重写descriptionWithLocale:方法
- (NSString *)description {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    // enumerate遍历数组，将内容拼接成一个新的字符串返回
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        // 在拼接字符串时，会调用obj的description方法
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    
    // 查出最后一个,的范围
    NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个,
        [strM deleteCharactersInRange:range];
    }
    
    return strM;
}

@end

@implementation NSDictionary (LogPrintString)
// 重写descriptionWithLocale:方法
- (NSString *)description

{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    // enumerate遍历数组，将内容拼接成一个新的字符串返回
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    // 在拼接字符串时，会调用obj的description方法
    [strM appendString:@"}\n"];
    
    // 查出最后一个,的范围
    NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个,
        [strM deleteCharactersInRange:range];
    }
    return strM;
}

@end
