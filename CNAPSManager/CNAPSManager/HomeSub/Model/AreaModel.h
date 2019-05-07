//
//  AreaModel.h
//  CNAPSManager
//
//  Created by James on 2019/2/27.
//  Copyright © 2019 James. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AreaModel : NSObject

@property (nonatomic, strong) NSString *province;  // 省
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *href;
@property (nonatomic, strong) NSString *id;


+ (instancetype)objectWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
