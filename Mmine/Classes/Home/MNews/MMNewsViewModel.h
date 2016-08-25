//
//  MMNewsViewModel.h
//  Mmine
//
//  Created by Jamie on 16/6/8.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMNewsViewModel : NSObject

/**
 *  获取新闻概要模型
 */
@property(nonatomic,strong)RACCommand *fetchNewsEntityCommand;


+ (void)loadChannelListData:(void (^)(NSArray *listArray))block;
+ (NSArray *)loadChannelList;
@end
