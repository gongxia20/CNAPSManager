//
//  HomeViewController.m
//  CNAPSManager
//
//  Created by James on 2019/2/22.
//  Copyright © 2019 James. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionCell.h"
#import "GXFmdbManager.h"
#import "BankModel.h"
#import "HomeSubController.h"
#import "SearchBarController.h"
#import "MyViewController.h"

@interface HomeViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *bankArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BankModel *bankModel;

@end

@implementation HomeViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行";
    [self addLeftItem];
    self.tabBarController.tabBar.hidden = YES;
    
    // 创建layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 滚动方向.
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    if (IPhone6_OR_before) {
        layout.itemSize = CGSizeMake(118, 140);
    } else {
        layout.itemSize = CGSizeMake(130, 150);
    }
//    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.center = self.view.center;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];

    // Register cell classes 注册视图
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)addLeftItem {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [leftButton setTitle:@"查询" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
//    [rightButton setTitle:@"我的" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"tabbar_my"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)clickButton:(UIButton *)button {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([SearchBarController class]) bundle:nil];
    SearchBarController *vc = [sb instantiateViewControllerWithIdentifier:@"SearchBarControllerID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickRightButton:(UIButton *)button {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([MyViewController class]) bundle:nil];
    MyViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MyViewControllerID"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *imageName = [NSString stringWithFormat:@"%02ldbank",indexPath.row + 1];
    
    // Configure the cell
    cell.image = [UIImage imageNamed:imageName];
    self.bankModel = self.bankArray[indexPath.row];
    cell.bankLabel.text = self.bankModel.name;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bankArray.count;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([HomeSubController class]) bundle:nil];
    HomeSubController *vc = [sb instantiateViewControllerWithIdentifier:@"HomeSubControllerID"];
    
    self.bankModel = self.bankArray[indexPath.row];
    vc.bankModelName = self.bankModel.name;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"dianji jin lai ");
}

#pragma mark - 懒加载
- (NSMutableArray *)bankArray
{
    if (!_bankArray) {
        // 数据库中取出数据
        GXFmdbManager *manager = [GXFmdbManager sharedInstance];
        NSMutableArray *tempArray = [manager openBankData];
        self.bankArray = [NSMutableArray array];
        
        // 字典转模型
        for (NSDictionary *dict in tempArray) {
            BankModel *bankModelTemp = [BankModel objectWithDict:dict];
//                NSLog(@"---bankModelTemp.name=%@",bankModelTemp.name);
            [self.bankArray addObject:bankModelTemp];
        }
    }
    return _bankArray;
}
@end
