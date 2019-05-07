//
//  HomeSubController.m
//  CNAPSManager
//
//  Created by James on 2019/2/26.
//  Copyright © 2019 James. All rights reserved.
//

#import "HomeSubController.h"
#import "GXFmdbManager.h"
#import "AreaModel.h"
#import "BankModel.h"
#import "DetailAddressController.h"

#define subProvinceTableWidth  [UIScreen mainScreen].bounds.size.width * 0.3
#define subCityTableWidth [UIScreen mainScreen].bounds.size.width * 0.7
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height

 NSString * const subProvinceCellIdentifier = @"subProvinceCellIdentifier";
 NSString * const subCityCellIdentifier = @"subCityCellIdentifier";

// 省province    市级city
@interface HomeSubController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *subProvinceTable;

@property (weak, nonatomic) IBOutlet UITableView *subCityTable;

@property (nonatomic, strong) NSMutableArray *areaArray;   /**< 获取到的数据数组 */
@property (nonatomic, strong) NSMutableArray *cutAreaArray;   /**< 地区数据数组 */

@property (nonatomic, strong) NSMutableArray *areaDuplicateArray;   /**< 去重的地区数据数组 */

@property (nonatomic, strong) NSMutableArray *cityArray;   /**< 地区数据数组 */
@property (nonatomic, strong) NSString *areaCityString; /**< 地区城市数组 */

@end

@implementation HomeSubController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *cutAreaArray = [self cutAreaArray:self.areaArray];
    self.cutAreaArray = cutAreaArray;
    self.navigationItem.title = self.bankModelName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.subProvinceTable];
    [self.view addSubview:self.subCityTable];

    [self.subProvinceTable registerClass:[UITableViewCell class] forCellReuseIdentifier:subProvinceCellIdentifier];
    [self.subCityTable registerClass:[UITableViewCell class] forCellReuseIdentifier:subCityCellIdentifier];

    self.subProvinceTable.tableFooterView = [UIView new];
    self.subCityTable.tableFooterView =  [UIView new];
    
    // 两句代码缺一不可
    [self.subProvinceTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.subProvinceTable didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];//实现点击第一行所调用的方法
}

#pragma mark - tableView 数据源代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.subProvinceTable) return self.areaDuplicateArray.count;
    return self.cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    // 左边的 view
    if (tableView == self.subProvinceTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:subProvinceCellIdentifier forIndexPath:indexPath];
        NSString *areaStr = self.areaDuplicateArray[indexPath.row];
        cell.textLabel.text = areaStr;
        // 右边的 view
    }
    else if(tableView == self.subCityTable)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:subCityCellIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = self.cityArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate 代理方法 -
//MARK: - 一个方法就能搞定 右边滑动时跟左边的联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 如果是 左侧的 tableView 直接return
    if (scrollView == self.subProvinceTable) return;
    
    // 取出显示在 视图 且最靠上 的 cell 的 indexPath
    NSIndexPath *topHeaderViewIndexpath = [[self.subCityTable indexPathsForVisibleRows] firstObject];
    
    // 左侧 talbelView 移动的 indexPath
    NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section inSection:0];
    
    // 移动 左侧 tableView 到 指定 indexPath 居中显示
    [self.subProvinceTable scrollToRowAtIndexPath:moveToIndexpath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

//MARK: - 点击 cell 的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 选中 左侧 的 tableView
    if (tableView == self.subProvinceTable) {
        NSString *strName = self.areaDuplicateArray[self.subProvinceTable.indexPathForSelectedRow.row];
        NSString *str = [NSString stringWithFormat:@"%@%@",strName,_bankModelName];
        self.areaCityString = str;
        
        GXFmdbManager *manager = [GXFmdbManager sharedInstance];
        NSMutableArray *areaCityArrayTemp = [manager openAreaData:str];
        NSMutableArray *tempArray= [NSMutableArray array];

        // 字典转模型
        for (NSDictionary *dict in areaCityArrayTemp) {
            AreaModel *areaModel = [AreaModel objectWithDict:dict];
            [tempArray addObject:areaModel.city];
        }
        self.cityArray = tempArray;

        [self.subCityTable reloadData];
        
    } else if (tableView == self.subCityTable) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([DetailAddressController class]) bundle:nil];
        DetailAddressController *vc = [sb instantiateViewControllerWithIdentifier:@"DetailAddressControllerID"];
        
        vc.bankModelName = self.areaCityString;
        vc.cityName = self.cityArray[indexPath.row];

        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (NSMutableArray *)cutAreaArray:(NSArray *)array {
    NSMutableArray *tempArray = [NSMutableArray array];
    // 字典转模型
    for (AreaModel *areaModel in array) {
        // 截取省如(湖南省工商银行--->湖南省)
        NSString *str = @"省";
        NSRange range = [areaModel.province rangeOfString:str];
        
        // 如果没找直辖市的就截取市
        if (range.length == 0) {
            NSString *str = @"市";
            NSRange range = [areaModel.province rangeOfString:str];
            NSString *strNew =  [areaModel.province substringToIndex:range.location+1];
            [tempArray addObject:strNew];
            continue;
        }
        NSString *strNew =  [areaModel.province substringToIndex:range.location+1];
        [tempArray addObject:strNew];
    }
    
    return tempArray;
}

#pragma mark - 懒加载 tableView -
- (NSMutableArray *)areaArray
{
    if (!_areaArray) {
        // 数据库中取出数据
        GXFmdbManager *manager = [GXFmdbManager sharedInstance];
        NSMutableArray *areaArray = [manager openAreaData:self.bankModelName];
        NSMutableArray *tempArray= [NSMutableArray array];
        
        // 字典转模型
        for (NSDictionary *dict in areaArray) {
            AreaModel *areaModel = [AreaModel objectWithDict:dict];
            [tempArray addObject:areaModel];
        }
        _areaArray = tempArray;
    }
    return _areaArray;
}

- (NSMutableArray *)areaDuplicateArray {
    if (!_areaDuplicateArray) {
        _areaDuplicateArray = [NSMutableArray array];
        for (int i = 0; i < [self.cutAreaArray count]; ++i) {
            if ([_areaDuplicateArray containsObject:[self.cutAreaArray objectAtIndex:i]] == NO) {
                [_areaDuplicateArray addObject:[self.cutAreaArray objectAtIndex:i]];
            }
        }
    }
    return _areaDuplicateArray;
}

- (NSMutableArray *)cityArray
{
    if (!_cityArray) {
        // 数据库中取出数据
        self.cityArray = [NSMutableArray array];
        
        // 字典转模型
        for (AreaModel *areaModel in self.areaArray) {
            [self.cityArray addObject:areaModel.city];
        }
    }
    return _cityArray;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}


@end
