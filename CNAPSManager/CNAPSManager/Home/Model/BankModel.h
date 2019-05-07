//
//  BankModel.h
//  CNAPSManager
//
//  Created by James on 2019/2/26.
//  Copyright © 2019 James. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *href;
@property (nonatomic, strong) NSString *id;

+ (instancetype)objectWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
