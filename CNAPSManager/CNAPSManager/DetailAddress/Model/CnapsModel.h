//
//  CnapsModel.h
//  CNAPSManager
//
//  Created by James on 2019/3/6.
//  Copyright © 2019 James. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CnapsModel : NSObject
// 前面三个是要做显示用的
@property (nonatomic, strong) NSString *branchBankAddress;  // 详细地址位置,有时候没有(天津市宁河县芦台镇建设路 17 号)
@property (nonatomic, strong) NSString *branchBankName; // 中国农业发展银行天津市蓟县支行(需要显示用的)
@property (nonatomic, strong) NSString *branchBankCnaps;  // 203110000098 cnaps号

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *bankName;  // 银行名字如:(农业发展银行)
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *province;  // 某某市银行名字(直辖市农业发展银行)

+ (instancetype)objectWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
