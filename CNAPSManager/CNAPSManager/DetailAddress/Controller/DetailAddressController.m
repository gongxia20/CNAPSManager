//
//  DetailAddressController.m
//  CNAPSManager
//
//  Created by James on 2019/3/5.
//  Copyright © 2019 James. All rights reserved.
//

#import "DetailAddressController.h"
#import "CnapsModel.h"
#import "DetailAddressCell.h"
#import "MapViewController.h"

@interface DetailAddressController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *cnapsModel;
//@property (nonatomic, strong) DetailAddressCell *cell;
@end

@implementation DetailAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.cityName;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
}

#pragma arguments -- tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cnapsModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ;
    CnapsModel *model = self.cnapsModel[indexPath.row];
    DetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:detailAddressCell forIndexPath:indexPath];
    
    cell.model = model;
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


- (NSMutableArray *)cnapsModel {
    if (!_cnapsModel) {
        GXFmdbManager *manager = [GXFmdbManager sharedInstance];
        NSMutableArray *array = [manager openCnapsData:self.bankModelName cityName:self.cityName];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            CnapsModel *model = [CnapsModel objectWithDict:dict];
            [tempArray addObject:model];
        }
        _cnapsModel = tempArray;
    }
    return _cnapsModel;
}


- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

@end
