//
//  MMHomeViewController.m
//  Mmine
//
//  Created by Jamie on 16/6/1.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMHomeViewController.h"
#import "MMHomeModuleModel.h"
#import "MMHomeModuleSelectionView.h"
#import "MMHomeViewModel.h"
#import "MMRotatorView.h"
#import "UIBarButtonItem+JAExt.h"
#import "MMNewsNavigationController.h"
#import "MMSecondNavigationController.h"
@interface MMHomeViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *moduleArray;
@property (nonatomic, strong) NSArray *rotatorArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@end
@implementation MMHomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    //通过viewmodel加载数据
    [MMHomeViewModel loadModuleSelectionViewData:^(NSArray *moduleArray) {
        self.moduleArray = moduleArray;
    }];
    [MMHomeViewModel loadRotatorData:^(NSArray *rotatorArray) {
        self.rotatorArray = rotatorArray;
    }];
    [self createContent];
    [self createNavigation];

}

- (void)createContent
{
    self.title = @"首页";
    self.navigationController.navigationBar.hidden = NO;
    [self.view addSubview:self.scrollView];
    self.view.backgroundColor = MColorBackground;

    
    MMHomeModuleSelectionView *msView = [[MMHomeModuleSelectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 4 * 3) collectionViewLayout:[UICollectionViewLayout new]];
    
    msView.backgroundColor = [UIColor blackColor];
    msView.contentArray = self.moduleArray;
    [msView clickCell:^(NSInteger itemNum) {
        MMHomeModuleModel *model = self.moduleArray[itemNum];
        
        Class class = NSClassFromString(model.className);
        if (class) {
            UIViewController *viewController = class.new;
            viewController.title = model.name;
            
            [self presentViewController:viewController animated:NO completion:nil];
//            [self.navigationController pushViewController:viewController animated:YES];
        }
    }];
    [self.scrollView addSubview:msView];
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);

}

- (void)createNavigation
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_check_in" HighImageNmae:@"navigationbar_check_in_highlighted" Target:self Action:@selector(leftBarClick)];
}
- (void)leftBarClick
{
    NSLog(@"1111");
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
-(NSArray *)moduleArray
{
    if (!_moduleArray) {
        _moduleArray = [NSArray new];
    }
    return _moduleArray;
}
- (NSArray *)rotatorArray
{
    if (!_rotatorArray) {
        _rotatorArray = [NSArray new];
    }
    return _rotatorArray;
}

#pragma mark 头部显示的内容

@end
