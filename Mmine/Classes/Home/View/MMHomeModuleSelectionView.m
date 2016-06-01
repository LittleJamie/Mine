
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
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.frame;
    CGFloat cellH = self.bounds.size.height;
    CGFloat cellW = self.bounds.size.width;
    
    self.text.frame = CGRectMake(cellH * 0.3, 0, cellW, cellH * 0.3);
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
        _text.font = [UIFont systemFontOfSize:13.0];
        
    }
    return _text;
}
@end
#pragma mark - View
@interface MMHomeModuleSelectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation MMHomeModuleSelectionView

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
    self.scrollsToTop = NO;
    [self registerClass:[MMHomeMSCell class] forCellWithReuseIdentifier:cellID];
}
#pragma mark - Delegate\DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.contentArray.count ? self.contentArray.count : 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MMHomeMSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.contentArray[indexPath.item];
    return cell;
}
@end

