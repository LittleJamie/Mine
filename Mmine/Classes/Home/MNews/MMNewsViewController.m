//
//  MMNewsViewController.m
//  Mmine
//
//  Created by Jamie on 16/6/1.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMNewsViewController.h"
#import "UIBarButtonItem+JAExt.h"

@implementation MMNewsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavigation];
    [self createContent];
}
- (void)createNavigation
{
//    self.navigationController.tabBarItem.ba
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_back_withtext" HighImageNmae:@"navigationbar_back_withtext_highlighted" Target:self Action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_back_withtext" HighImageNmae:@"navigationbar_back_withtext_highlighted" Target:self Action:@selector(back)];
    UIScrollView *topScrollView = [[UIScrollView alloc] init];
    
    topScrollView.frame = CGRectMake(0, 0, kScreenWidth * 0.7, 44);
    topScrollView.contentSize = CGSizeMake(400, 0);
    topScrollView.backgroundColor = [UIColor blueColor];
    CGFloat buttonW = 60;
    for (NSInteger i = 0; i < 10; i++) {
        UIButton *button = [[UIButton alloc] init];
        
        button.x = i * buttonW;
        button.size = CGSizeMake(buttonW, 44);
        button.backgroundColor = MRandomColor;
        [topScrollView addSubview: button];
    }
    self.navigationItem.titleView = topScrollView;
    NSLog(@"%f",self.navigationItem.titleView.frame.origin.x);
    [self.navigationController.navigationBar addSubview:topScrollView];
}
- (void)createContent
{
    
}
#pragma mark - Event Processing
//Navi左侧按钮点击事件
- (void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
@end
