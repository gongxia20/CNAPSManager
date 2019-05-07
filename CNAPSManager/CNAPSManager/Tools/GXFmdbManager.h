//
//  GXFmdbManager.h
//  CNAPSManager
//
//  Created by James on 2019/2/25.
//  Copyright © 2019 James. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface GXFmdbManager : NSObject

+ (GXFmdbManager *)sharedInstance;

- (NSMutableArray *)openBankData; /**< 打开银行名数据表 */

- (NSMutableArray *)openAreaData:(NSString *)bankProvince; /**< 打开地区省份的 */

- (NSMutableArray *)openCnapsData:(NSString *)bankModelName cityName:(NSString *)cityName; /**< 打开地区的详细介绍表格 */

- (NSMutableArray *)openCnapsData:(NSString *)branchBankName; /**< 搜索界面打开地区的详细介绍表格 */
@end

NS_ASSUME_NONNULL_END
