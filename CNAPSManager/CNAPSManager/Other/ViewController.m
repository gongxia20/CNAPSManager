//
//  ViewController.m
//  CNAPSManager
//
//  Created by James on 2019/2/18.
//  Copyright © 2019年 James. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MyViewController.h"
#import "HomeViewController.h"
#import "BaseNavigationController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *titleArray = @[@"首页", @"我的"];
    NSArray *imageArray = @[@"tabbar_home",@"tabbar_my"];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([MyViewController class]) bundle:nil];
    MyViewController *vc = [sb instantiateInitialViewController];
    
    self.viewControllers = @[[[BaseNavigationController alloc] initWithRootViewController:[HomeViewController new]],
                             [[BaseNavigationController alloc] initWithRootViewController:vc]];
    
    for (int i = 0; i < self.viewControllers.count; ++i) {
        UIViewController *vc = self.viewControllers[i];
        vc.tabBarItem.title  = titleArray[i];
        vc.tabBarItem.image = [UIImage imageNamed:imageArray[i]];
    }
}

@end
