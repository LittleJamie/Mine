//
//  MMNetwork.h
//  Mmine
//
//  Created by Jamie on 16/6/13.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMNetWorkResult;
typedef void(^netWorkCompletionBlock)(NSURLSessionDataTask *task, MMNetWorkResult *networkResult, NSError *error);
//成功回调的Block
typedef void(^successBlock) (id);
//失败回调的Block
typedef void(^failureBlock) (NSError *error);
@interface MMNetwork : NSObject

@property (nonatomic, strong) NSMutableDictionary *cacheHeaderDictionary;

+(MMNetwork *)shareInstance;
- (NSURLSessionDataTask *)getWithURL:(NSString *)url params:(id)params resultClass:(Class)resultClass completionBlock:(netWorkCompletionBlock)completionBlock;
- (NSURLSessionDataTask *)postWithURL:(NSString *)url params:(id)params resultClass:(Class)resultClass completionBlock:(netWorkCompletionBlock)completionBlock;



- (id)getEffectiveObject:(id)obj;

- (NSData *)getBodyStringFromParameters:(NSDictionary *)parmenters encoden:(NSStringEncoding)en;

- (NSString *)getJSONStringWithDicationary:(NSDictionary *)dicationary;


- (NSURLSessionDataTask *)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure;
@end
