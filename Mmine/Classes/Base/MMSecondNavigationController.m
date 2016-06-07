//
//  MMSecondNavigationController.m
//  Mmine
//
//  Created by Jamie on 16/6/7.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMSecondNavigationController.h"

#import "UIBarButtonItem+JAExt.h"
@implementation MMSecondNavigationController

//+ (void)initialize
//{
//    if (self == [MMSecondNavigationController class]) {
//        [self createNavigation];
//    }
//}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self createNavigation];
    }
    return self;
}
- (void)createNavigation
{
//    MMSecondNavigationController *naviController = [MMSecondNavigationController a]
    self.navigationController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_back_withtext" HighImageNmae:@"navigationbar_back_withtext_highlighted" Target:self Action:@selector(back)];
}
- (void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
@end
