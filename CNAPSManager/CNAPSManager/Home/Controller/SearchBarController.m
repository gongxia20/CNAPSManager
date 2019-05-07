//
//  SearchBarController.m
//  CNAPSManager
//
//  Created by James on 2019/3/5.
//  Copyright © 2019 James. All rights reserved.
//

#import "SearchBarController.h"
#import "SearchBar.h"
#import "CnapsModel.h"
#import "DetailAddressCell.h"
#import "MapViewController.h"

@interface SearchBarController () <UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) SearchBar *searchBar; /**< 搜索框 */

@property (nonatomic, strong) NSMutableArray *cnapsModel;
@end

@implementation SearchBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    SearchBar *searchBar = [[SearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, 300, 30);
    self.navigationItem.titleView = searchBar;
    
    searchBar.delegate = self;
    self.searchBar = searchBar;
  
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // 1.添加按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    
    // 2.替换leftView
    self.searchBar.leftIcon = @"statistic_triangle";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.cnapsModel = [NSMutableArray array];
    self.cnapsModel = [self cnapsModelBranchBankName:textField.text];
    [self.tableView reloadData];
    return YES;
}

- (void)cancle
{
//    DDActionLog;
    
    // 0.清除取消按钮
    self.navigationItem.rightBarButtonItem = nil;
    // 1.关闭键盘
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    // 2.还原leftView
    self.searchBar.leftIcon = @"searchbar_icon";
}

#pragma mark - 监听scorllerView的拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 1.关闭键盘
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cnapsModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CnapsModel *model = self.cnapsModel[indexPath.row];
    
    DetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:detailAddressCell forIndexPath:indexPath];
   cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.model = model;
    // sdwebImage注意要加占位图
//    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tupian"]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma arguments -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailAddressCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([MapViewController class]) bundle:nil];
    MapViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MapViewControllerID"];
    vc.branchBankName = cell.model.branchBankName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 获取数组
- (NSMutableArray *)cnapsModelBranchBankName:(NSString *)textFieldString {
        GXFmdbManager *manager = [GXFmdbManager sharedInstance];
        NSMutableArray *array = [manager openCnapsData:self.searchBar.text];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            CnapsModel *model = [CnapsModel objectWithDict:dict];
            [tempArray addObject:model];
        _cnapsModel = tempArray;
    }
    return _cnapsModel;
}

@end
