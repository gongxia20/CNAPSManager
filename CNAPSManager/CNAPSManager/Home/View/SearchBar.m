//
//  SearchBar.m
//  CNAPSManager
//
//  Created by James on 2019/3/19.
//  Copyright © 2019 James. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar
// 通过代码创建控件时会调用
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

// 通过xib/Storboard创建时调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // 一次性的初始化
    // 设置边框样式
    self.borderStyle = UITextBorderStyleRoundedRect;
    // 设置提醒文本
    self.placeholder = @"请输入您想搜索的内容";
    
    // 设置右边的图标
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_icon"]];
    self.leftView = icon;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    // 设置清除按钮
    self.clearButtonMode = UITextFieldViewModeAlways;
}

- (void)setLeftIcon:(NSString *)leftIcon
{
    _leftIcon = leftIcon;
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:leftIcon]];
    icon.width = 30;
    icon.contentMode = UIViewContentModeCenter;
    self.leftView = icon;
}


@end
