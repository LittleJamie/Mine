//
//  MMNewsViewModel.m
//  Mmine
//
//  Created by Jamie on 16/6/8.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMNewsViewModel.h"
#import "MMNetwork.h"
#import "MMNewsModel.h"
#import "MMNetWorkResult.h"
@implementation MMNewsViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createRACCommand];
    }
    return self;
}
- (void)createRACCommand
{
    @weakify(self);
    _fetchNewsEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           @strongify(self)
           [self loadNewsListWithURL:input success:^(NSArray *array, NSError *error) {
               [subscriber sendNext:array];
               [subscriber sendCompleted];
               if (error) {
                   [subscriber sendError:error];
               }
           }];
           return nil;
       }];
    }];
}
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

- (void)loadNewsListWithURL:(NSString *)url success:(void (^)(NSArray *array,NSError *error))success
{
    NSString *fullURL = [@"http://c.m.163.com/" stringByAppendingString:url];
    [[MMNetwork shareInstance] getWithURL:fullURL params:nil resultClass:[MMNewsModel class] completionBlock:^(NSURLSessionDataTask *task, MMNetWorkResult *networkResult, NSError *error) {
        NSLog(@"%@",networkResult);
        if (success && error == nil) {
            success(networkResult.result,nil);
        }
        if (error) {
            success(nil,error);
        }
    }];
}

@end
