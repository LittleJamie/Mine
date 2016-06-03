
//
//  MMHomeModuleSelectionView.m
//  Mmine
//
//  Created by Jamie on 16/6/1.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMHomeModuleSelectionView.h"
#import "MMHomeModuleModel.h"
static NSString *cellID = @"msCell";
#pragma mark - Cell
@interface MMHomeMSCell : UICollectionViewCell
@property (nonatomic, strong) MMHomeModuleModel *model;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *text;
@end
@implementation MMHomeMSCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createContent];
    }
    return self;
}
- (void)createContent
{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.text];
    
    
}
-(void)setModel:(MMHomeModuleModel *)model
{
    _model = model;
    if (model.image) self.imageView.image = [UIImage imageNamed:model.image];
    if (model.name) self.text.text = model.name;
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
    CGFloat cellH = self.bounds.size.height;
    CGFloat cellW = self.bounds.size.width;
    CGFloat textH = cellH * 0.3;
    CGFloat textY = cellH - textH;
    CGFloat imageH = cellH - textH + 1;
    CGFloat imageW = cellW;
    self.text.frame = CGRectMake(0, textY, cellW, textH);
    self.imageView.frame = CGRectMake(0, 0, imageW, imageH);
}
-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView= [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
-(UILabel *)text
{
    if (!_text) {
        _text = [UILabel new];
        _text.font = [UIFont systemFontOfSize:12.0];
        _text.baselineAdjustment = UIBaselineAdjustmentNone;
        _text.textAlignment = NSTextAlignmentCenter;
        _text.backgroundColor = MColorBackground;
       
    }
    return _text;
}
@end
#pragma mark - View
@interface MMHomeModuleSelectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation MMHomeModuleSelectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    layout1.itemSize = CGSizeMake(kScreenWidth / 4  - 1, kScreenWidth / 4 - 1);
    layout1.minimumLineSpacing = 1;
    layout1.minimumInteritemSpacing = 0;
    layout1.sectionInset = UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
    
    self = [super initWithFrame:frame collectionViewLayout:layout1];
    if (self) {
        [self createContent];
        
    }
    return self;
}
- (void)createContent
{
    self.delegate = self;
    self.dataSource = self;
    self.scrollsToTop = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    [self registerClass:[MMHomeMSCell class] forCellWithReuseIdentifier:cellID];
    self.scrollEnabled = NO;
    self.allowsMultipleSelection = YES;
}
#pragma mark - Delegate\DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)self.contentArray.count);
    return self.contentArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MMHomeMSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.model = self.contentArray[indexPath.item];
    cell.backgroundColor = MColorBackground;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.block) {
        self.block(indexPath.item);
    }
}
- (void)clickCell:(ItemBlock)block
{
    if (block) {
        self.block = block;
    }
    
}
@end

