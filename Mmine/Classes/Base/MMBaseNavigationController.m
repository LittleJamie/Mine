
//
//  MMBaseNavigationController.m
//  Mmine
//
//  Created by Jamie on 16/6/1.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMBaseNavigationController.h"

@implementation MMBaseNavigationController

+(void)initialize
{
    [self setNavigationBarTheme];
    [self setBarButtonItemTeme];
}
+ (void)setBarButtonItemTeme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10.0 weight:1.0];
//    textAttrs[NSShadowAttributeName] = [[NSShadow alloc] init];
    [appearance setTitleTextAttributes:textAttrs];
}

+ (void)setNavigationBarTheme
{
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    //    设置文字属性
    //    设置普通状态的文字属性Normal
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:25];
//    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    //    设置高亮状态的文字属性Highlighted
    NSMutableDictionary *hightextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    hightextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [appearance setTitleTextAttributes:hightextAttrs forState:UIControlStateHighlighted];
    //    设置不可用状态(disable)的文字属性Disabled
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:hightextAttrs forState:UIControlStateDisabled];
}

#pragma mark - 拦截navigation push 控制器行为的方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    判断是否为栈底控制器如果不是栈底控制器则隐藏 tabbar
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = NO;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_back" HighImageNmae:@"navigationbar_back_highlighted" Target:self Action:@selector(back)];
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_more" HighImageNmae:@"navigationbar_more_highlighted" Target:self Action:@selector(more)];
        
    }
    [super pushViewController:viewController animated:animated];
}
/**
 *  返回按钮执行的方法
 */
-(void)back
{
    [self popViewControllerAnimated:YES];
}
/**
 *  更多按钮执行的方法
 */
-(void)more
{
    [self popToRootViewControllerAnimated:YES];
}

@end
