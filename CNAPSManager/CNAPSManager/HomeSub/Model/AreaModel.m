//
//  AreaModel.m
//  CNAPSManager
//
//  Created by James on 2019/2/27.
//  Copyright © 2019 James. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

+ (instancetype)objectWithDict:(NSDictionary *)dict {
    AreaModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
