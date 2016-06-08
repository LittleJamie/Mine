//
//  MMNewsViewModel.m
//  Mmine
//
//  Created by Jamie on 16/6/8.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMNewsViewModel.h"

@implementation MMNewsViewModel

+(void)loadChannelListData:(void (^)(NSArray *))block
{
    if (block) {
        block(@[@"热点",@"科技",@"体育",@"汽车",@"娱乐",@"社会",@"时尚",@"旅游",@"数码",@"游戏",@"家居",@"教育",@"星座",@"情感",@"电影"]);
    }
}
+(NSArray *)loadChannelList
{
    return @[@"热点",@"科技",@"体育",@"汽车",@"娱乐",@"社会",@"时尚",@"旅游",@"数码",@"游戏",@"家居",@"教育",@"星座",@"情感",@"电影"];
}
@end
