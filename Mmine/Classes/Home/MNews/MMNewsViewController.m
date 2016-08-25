//
//  MMNewsViewController.m
//  Mmine
//
//  Created by Jamie on 16/6/1.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMNewsViewController.h"
#import "UIBarButtonItem+JAExt.h"
#import "MMNewsViewModel.h"
#import "MMNewsListView.h"
#import "MMNetwork.h"
#import "MMNewsModel.h"
#import "MMNetWorkResult.h"
#import "DonewsAnalytics.h"
@implementation MMNewsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavigation];
    [self createContent];
}
- (void)createNavigation
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_back_withtext" HighImageNmae:@"navigationbar_back_withtext_highlighted" Target:self Action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_back_withtext" HighImageNmae:@"navigationbar_back_withtext_highlighted" Target:self Action:@selector(back)];

}
- (void)createContent
{
    NSArray *listArray = [MMNewsViewModel loadChannelList];
    MMNewsListView *topScrollView = [[MMNewsListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 108)];
    topScrollView.list = listArray;
    topScrollView.backgroundColor = MRandomColor;

    
    [self.view addSubview:topScrollView];
//    MMNewsModel *params = [[MMNewsModel alloc] init];
    [[MMNetwork shareInstance] getWithURL:@"http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html" params:nil resultClass:[MMNewsModel class] completionBlock:^(NSURLSessionDataTask *task, MMNetWorkResult *networkResult, NSError *error) {
//        NSLog(@"%@",networkResult.result);
    }];

    [DonewsAnalytics onPageAccess:@"news" lastPageName:@"home" pageNum:2];
    [DonewsAnalytics onEvents:@"test1"];
}
#pragma mark - Event Processing
//Navi左侧按钮点击事件
- (void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
@end
