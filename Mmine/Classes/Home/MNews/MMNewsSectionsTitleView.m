//
//  MMNewsSectionsTitleView.m
//  Mmine
//
//  Created by Jamie on 16/6/12.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMNewsSectionsTitleView.h"
#import "MMNewsSectionsTitleViewCell.h"
#import "MMNewsModel.h"
@interface MMNewsSectionsTitleView ()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation MMNewsSectionsTitleView
static NSString *newsId = @"newsCellId";
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
    self.dataSource = self;
    self.delegate = self;
    
    [self registerClass:[MMNewsSectionsTitleViewCell class] forCellReuseIdentifier: newsId];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMNewsSectionsTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsId forIndexPath:indexPath];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}
@end
