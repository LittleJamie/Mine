
//
//  MMNewsListView.m
//  Mmine
//
//  Created by Jamie on 16/6/12.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMNewsListView.h"

@implementation MMNewsListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createContent];
    }
    return self;
}
-(void)setList:(NSArray *)list
{
    _list = list;
    CGFloat buttonW = 60;
    self.contentSize = CGSizeMake(list.count * buttonW, 0);
    for (NSInteger i = 0; i < self.list.count; i++) {
        UIButton *button = [[UIButton alloc] init];
            
        button.backgroundColor = MRandomColor;
        [button setTitle:self.list[i] forState:UIControlStateNormal];
        NSLog(@"%f",button.y);
        [self addSubview: button];
    }
    for (UIView *view in self.subviews) {
        NSLog(@"%@",view);
    }
}
- (void)createContent
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat buttonW = 60;
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIButton *button = self.subviews[i];
        button.x = i * buttonW;
        button.size = CGSizeMake(buttonW, 44);
    }
    
}
@end
