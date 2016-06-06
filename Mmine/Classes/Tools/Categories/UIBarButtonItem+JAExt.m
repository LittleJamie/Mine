//
//  UIBarButtonItem+JAExt.m
//  WeiboByMing
//
//  Created by Jamie on 15/12/31.
//  Copyright © 2015年 Jamie. All rights reserved.
//

#import "UIBarButtonItem+JAExt.h"

@implementation UIBarButtonItem (JAExt)
#pragma mark - 添加按钮方法的实现
+(UIBarButtonItem *)itemWithImageName:(NSString *)imageNmae HighImageNmae:(NSString *)highImageNmae Target:(id)target Action:(SEL)action
{
    //    设置导航栏按钮
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageNmae] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImageNmae] forState:UIControlStateHighlighted];
    //    设置按钮尺寸
    button.size = button.currentBackgroundImage.size;
    //    监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
