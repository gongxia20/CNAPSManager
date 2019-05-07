//
//  DetailAddressCell.h
//  CNAPSManager
//
//  Created by James on 2019/3/6.
//  Copyright © 2019 James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CnapsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailAddressCell : UITableViewCell
// 传入数据模型
@property (nonatomic, strong) CnapsModel *model;

@end

NS_ASSUME_NONNULL_END
