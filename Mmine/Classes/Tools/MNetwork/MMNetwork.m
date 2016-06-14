//
//  MMNetwork.m
//  Mmine
//
//  Created by Jamie on 16/6/13.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMNetwork.h"

#import "AFNetworking.h"
#import "MMApp.h"
#import "MMDevice.h"
#import "MMHeader.h"
#import "MMNetWorkResult.h"

#define kMMBody @"Body"
#define kMMCode @"Code"
#define kMMMessage @"Message"

#define kDNbody @"body"
#define kDNcode @"code"
#define kDNmessage @"message"
//成功回调的Block
typedef void(^successBlock) (id);
//失败回调的Block
typedef void(^failureBlock) (NSError *error);
@implementation MMNetwork

#pragma mark - shared
+(MMNetwork *)shareInstance
{
    static MMNetwork *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
#pragma mark - override
-(instancetype)init
{
    if (self = [super init]) {
        _cacheHeaderDictionary = [[NSMutableDictionary alloc] init];
        NSDictionary *tempHeader = [self getHeader];
        if (tempHeader) {
            [_cacheHeaderDictionary addEntriesFromDictionary:tempHeader];
        }
    }
    return self;
}
- (NSDictionary *)getHeader
{
    NSDictionary *info=[[NSBundle mainBundle] infoDictionary];
    //在此替换模型
    MMApp *app=[[MMApp alloc] init];
    
    app.PackageName=info[@"CFBundleIdentifier"];
    NSString *appName=info[@"CFBundleDisplayName"];
    if (!appName) {
        appName=info[@"CFBundleName"];
    }
    app.AppName=appName;
    app.Version=info[@"CFBundleShortVersionString"];
    app.MobileType=@"iOS";
    app.Channel=@"1";
    
    
    MMDevice *device=[[MMDevice alloc] init];
    device.Platform=@"iOS";
    device.Model=@"1";
    device.Factory=@"Apple";
    device.ScreenSize=NSStringFromCGSize([[UIScreen mainScreen] currentMode].size);
    device.Denstiy=@"1";
    device.IMEI=@"123";
    device.Mac=@"00:00:00:00:00:00";
    device.ClientId=[[UIDevice currentDevice] udidString_Ext];
    
    
    MMHeader *header=[[MMHeader alloc] init];
    header.Device=device;
    header.App=app;
    return [MTLJSONAdapter JSONDictionaryFromModel:header error:nil];
}
- (NSURLSessionDataTask *)getWithURL:(NSString *)url params:(id)params resultClass:(Class)resultClass completionBlock:(netWorkCompletionBlock)completionBlock isAnimation:(BOOL)animation
{
    NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:params error:nil];
    NSURLSessionDataTask *task = [self GET:url parameters:dict success:^(id responseObject) {
        if (completionBlock) {
            MMNetWorkResult *resultObj = [[MMNetWorkResult alloc] init];
            resultObj.code = [responseObject[kMMCode] integerValue];
            resultObj.message = responseObject[kMMMessage];
            
            NSMutableArray *temp = [NSMutableArray arrayWithArray:responseObject[kMMBody]];
            
            if (temp && ![temp isEqual:[NSNull null]]) {
                resultObj.result = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:resultClass fromJSONArray:temp error:nil]];
                //                UIFont *font = [UIFont systemFontOfSize:12 weight:0.8];
                completionBlock(task,resultObj,nil);
            }
        }
    } failure:^(NSError *error) {
        completionBlock(task,nil,error);
    }];
    
    return task;
}
-(NSURLSessionDataTask *)postWithURL:(NSString *)url params:(id)params resultClass:(Class)resultClass completionBlock:(netWorkCompletionBlock)completionBlock
{
    NSDictionary *requestDictionary = nil;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (!params) {
        NSDictionary *paramsDict = [MTLJSONAdapter JSONDictionaryFromModel:params error:nil];
        requestDictionary = @{kMMBody:[self getEffectiveObject:paramsDict]};
    }
    
    
    [dict addEntriesFromDictionary:requestDictionary];
    if (self.cacheHeaderDictionary) {
        [dict setObject:[self getEffectiveObject:self.cacheHeaderDictionary] forKey:@"Header"];
    }
    
//    MBProgressHUD *hud = nil;
//    if (animation) {
//        
//        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
//        hud=[[MBProgressHUD alloc] initWithView:window];
//        
//        hud.mode = MBProgressHUDModeIndeterminate;
//        hud.animationType = MBProgressHUDAnimationFade;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [window  addSubview:hud];
//            [hud show:YES];
//        });
//    }
    NSURLSessionDataTask *task = [self POST:url parameters:dict success:^(id responseObject) {
        if (completionBlock) {
            MMNetWorkResult *resultObj = [[MMNetWorkResult alloc] init];
            resultObj.code = [responseObject[kMMCode] integerValue];
            resultObj.message = responseObject[kMMMessage];
            
            id temp = responseObject[kMMBody];
            if ([temp isKindOfClass:[NSDictionary class]]) {//body为字典
                
                NSMutableArray *tempArray = [NSMutableArray array];
                if (temp && ![temp isEqual:[NSNull null]] && resultClass != nil) {
                    id resultSubObj = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:temp error:nil];
                    [tempArray addObject:resultSubObj];
                }else{
                    [tempArray addObject:temp];
                }
                resultObj.result = tempArray;
                
            }else if ([temp isKindOfClass:[NSArray class]]){//body为数组
                
                if (temp && ![temp isEqual:[NSNull null]] && resultClass != nil) {
                    resultObj.result = [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:resultClass fromJSONArray:temp error:nil]];
                }else{
                    resultObj.result = [NSMutableArray arrayWithArray:temp];
                }
            }else{
                NSLog(@"body非数组,非字典");
            }
            
//            if (animation) {
//                [hud hide:YES];
//            }
            completionBlock(temp,resultObj,nil);
            
        }
    } failure:^(NSError *error) {
        
//        if (animation) {
//            [hud hide:YES];
//        }
        completionBlock(task,nil,error);
    }];
    
    return task;
    
}

- (id)getEffectiveObject:(id)obj
{
    if (obj == nil)
        return  [NSNull null];
    
    else return obj;
}

/**
 *  JSON字典转字符串
 *
 *  @param dicationary JSON字典
 *
 *  @return 字符串
 */
- (NSString *)getJSONStringWithDicationary:(NSDictionary *)dicationary
{
    NSData *data = [self getJSONDataWithDictionary:dicationary];
    if (data) {
        __autoreleasing NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return string;
    }
    return nil;
}

/**
 *  JSON转data
 *
 *  @param dictionary JSON字典
 *
 *  @return Data
 */
- (NSData *)getJSONDataWithDictionary:(NSDictionary *)dictionary
{
    NSError *error = nil;
    NSData *data = nil;
    NSException *except = nil;
    @try {
        data = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];
    } @catch (NSException *exception) {
        except = exception;
    } @finally {
        
    }
    if (error || except) {
        return nil;
    }
    return data;
}
#pragma mark - AFN封装

- (NSURLSessionDataTask *)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html,text/plain", nil];
    NSURLSessionDataTask *task = [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    return task;
}
- (NSURLSessionDataTask *)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(successBlock)success failure:(failureBlock)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html,text/plain",@"application/json", nil];
    NSURLSessionDataTask *task = [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    return task;
}
@end
