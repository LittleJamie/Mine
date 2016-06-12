
//
//  MMNewsSectionsTitleViewCell.m
//  Mmine
//
//  Created by Jamie on 16/6/12.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMNewsSectionsTitleViewCell.h"

@implementation MMNewsSectionsTitleViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createContent];
    }
    return self;
}
- (void)createContent
{
    
}
- (void)setNews:(MMNewsModel *)news
{
    self.news = news;
    
}
@end
