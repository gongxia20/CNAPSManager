//
//  CnapsModel.m
//  CNAPSManager
//
//  Created by James on 2019/3/6.
//  Copyright © 2019 James. All rights reserved.
//

#import "CnapsModel.h"

@implementation CnapsModel
+ (instancetype)objectWithDict:(NSDictionary *)dict {
    
    CnapsModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
