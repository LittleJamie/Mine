//
//  MMMBookListView.m
//  Mmine
//
//  Created by Jamie on 16/8/24.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMMBookListView.h"
#import "MMMBookAllListTableView.h"
#import "MMMBookRecentlyListTableView.h"

@interface MMMBookListView ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *recentlyRead;
@property (nonatomic, strong) UIButton *allRead;
@property (nonatomic, strong) UIView *indexView;
@property (nonatomic, assign) BOOL isAllList;
@property (nonatomic, strong) UIScrollView *allContentView;
@property (nonatomic, strong) NSArray *allListArray;
@property (nonatomic, strong) NSArray *recentlyListArray;
@end
@implementation MMMBookListView
static NSString * cellID = @"allcell";
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView
{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor blueColor];
    [self addSubview:self.indexView];
    [self addSubview:self.allContentView];
    
}
-(NSArray *)allListArray
{
    if (!_allListArray) {
        _allListArray = @[@"1",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"110",@"111",@"112",@"113",@"114"];
    }
    return _allListArray;
}
-(NSArray *)recentlyListArray
{
    if (!_recentlyListArray) {
        _recentlyListArray = @[@"21",@"212",@"213",@"214",@"215",@"216",@"217",@"218",@"219",@"2110",@"2111",@"2112",@"2113",@"2114"];
    }
    return _recentlyListArray;
}
- (UIScrollView *)allContentView
{
    if (!_allContentView) {
        _allContentView = [[UIScrollView alloc] init];
        _allContentView.frame = CGRectMake(0, 64 + kScreenHeight * 0.06, kScreenWidth, kScreenHeight - (64 + kScreenHeight * 0.06));
        _allContentView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - (64 + kScreenHeight * 0.06));
        _allContentView.backgroundColor = [UIColor grayColor];
        _allContentView.pagingEnabled = YES;
        MMMBookAllListTableView *allTable = [[MMMBookAllListTableView alloc] init];
        allTable.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - (64 + kScreenHeight * 0.06));
        allTable.contentArray = self.allListArray;
        [_allContentView addSubview:allTable];
        
        MMMBookRecentlyListTableView *recentlyTable = [[MMMBookRecentlyListTableView alloc] init];
        recentlyTable.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - (64 + kScreenHeight * 0.06));
        recentlyTable.contentArray = self.recentlyListArray;
        [_allContentView addSubview:recentlyTable];
        
    }
    
    return _allContentView;
}
-(UIView *)indexView
{
    if (!_indexView) {
        _indexView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight * 0.06)];
        _indexView.backgroundColor = [UIColor redColor];
        
        UIButton  *allReadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.5, kScreenHeight * 0.06)];
        [allReadBtn addTarget:self action:@selector(allReatBtnClick) forControlEvents:UIControlEventTouchDown];
//        allReadBtn.backgroundColor = [UIColor greenColor];
        [allReadBtn setTitle:@"书架" forState:UIControlStateNormal];
        [allReadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        allReadBtn.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:1.0];
        [_indexView addSubview:allReadBtn];
        self.allRead = allReadBtn;
        [allReadBtn setBackgroundImage:[UIImage imageWithColor_Ext:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        UIButton *recentlyReadBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth * 0.5, 0, kScreenWidth * 0.5, kScreenHeight*0.06)];
        [recentlyReadBtn addTarget:self action:@selector(recentlyReatBtnClick) forControlEvents:UIControlEventTouchDown];
//        recentlyReadBtn.backgroundColor = [UIColor grayColor];
        [recentlyReadBtn setTitle:@"最近阅读" forState:UIControlStateNormal];
        recentlyReadBtn.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:1.0];
        [_indexView addSubview:recentlyReadBtn];
        self.recentlyRead = recentlyReadBtn;
        
    }
    return _indexView;
    
}
#pragma mark - Event Processing
- (void)allReatBtnClick
{
    
    
    self.isAllList = self.isAllList ? NO : YES;
    self.indexView.backgroundColor = self.isAllList ? [UIColor blackColor] : [UIColor redColor];
    
    MLog(@"%d",self.isAllList ? YES : NO);
    MLog(@"点击了书架")
}
- (void)recentlyReatBtnClick
{
    MLog("点击了最近阅读")
}
#pragma mark - DataSource Delegate

@end
