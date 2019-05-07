//
//  BankModel.m
//  CNAPSManager
//
//  Created by James on 2019/2/26.
//  Copyright © 2019 James. All rights reserved.
//

#import "BankModel.h"

@implementation BankModel

+ (instancetype)objectWithDict:(NSDictionary *)dict {
    BankModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
