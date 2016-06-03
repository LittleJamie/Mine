//
//  MMOneViewController.m
//  Mmine
//
//  Created by Jamie on 16/6/1.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMOneViewController.h"

#import "MMHomeModuleModel.h"
#import "MMHomeModuleSelectionView.h"
#import "MMHomeViewModel.h"
@interface MMOneViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *moduleArray;
@property (nonatomic, strong) NSArray *rotatorArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@implementation MMOneViewController
static NSString *cellID = @"oneCell";
static NSString *headerID = @"oneHeader";
static NSString *footerID = @"onefooter";

-(void)viewDidLoad
{
    [super viewDidLoad];
    //通过viewmodel加载数据
    [MMHomeViewModel loadModuleSelectionViewData:^(NSArray *moduleArray) {
        self.moduleArray = moduleArray;
    }];
    
    [self createContent];
    
}

- (void)createContent
{
    
    [self.view addSubview:self.collectionView];
    
    
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
#pragma mark - dataSource/delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell sizeToFit];
    cell.backgroundColor = MRandomColor;
    
    return cell;
}
#pragma mark 头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
    MMHomeModuleSelectionView *msView = [[MMHomeModuleSelectionView alloc] initWithFrame:CGRectMake(0, 0, headerView.bounds.size.width, headerView.bounds.size.height) collectionViewLayout:[UICollectionViewLayout new]];
    
    msView.backgroundColor = [UIColor blackColor];
    msView.contentArray = self.moduleArray;
    [msView clickCell:^(NSInteger itemNum) {
        MMHomeModuleModel *model = self.moduleArray[itemNum];
        
        Class class = NSClassFromString(model.className);
        if (class) {
            UIViewController *viewController = class.new;
            viewController.title = model.name;
            self.title = @"";
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }];
    [headerView addSubview:msView];
    
    return headerView;
}
#pragma mark UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择%ld",(long)indexPath.item);
}

//创建collectionView
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, kScreenWidth / 4 * 3);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)collectionViewLayout:flowLayout];
        flowLayout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight * 0.3);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.backgroundColor = MColorBackground;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
    }
    return _collectionView;
}
@end