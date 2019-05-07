//
//  MyViewController.m
//  CNAPSManager
//
//  Created by James on 2019/3/5.
//  Copyright © 2019 James. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的";
    self.tableView.tableFooterView = [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath.section = %ld", (long)indexPath.section);
    if (1 == indexPath.section) {
    // 发送邮件, 只能在真机上使用
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    // 添加收件人：农业
    NSArray *toRecipients = @[@"gongxia20@qq.com"];
    // 多个收件人的时候，使用componentsJoinedByString方法连接，连接符为@","
    [mailUrl appendFormat:@"mailto:%@", toRecipients[0]];
    // 添加抄送人：
    NSArray *ccRecipients = @[@"gongxia20@qq.com"];
    [mailUrl appendFormat:@"?cc=%@", ccRecipients[0]];
    // 添加密送人：
    NSArray *bccRecipients = @[@"gongxia20@qq.com"];
    [mailUrl appendFormat:@"&bcc=%@", bccRecipients[0]];
    
    // 邮件名称和内容：
    [mailUrl appendString:@"&subject=my email"];
    [mailUrl appendString:@"&body=<b>Hello</b> World!"];
    //url打开，跳转邮件发送的app
    NSString *emailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];
    }
}


@end
