//
//  DonewsAnalytics.m
//  DonewsMingProductTest
//
//  Created by Jamie on 16/5/11.
//  Copyright © 2016年 Donews. All rights reserved.
//

#import "DonewsAnalytics.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "DonewsAdReachability.h"
//-----------------------------------------------------------
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

//-----------------------------------------------
#include <sys/types.h>

#include <sys/sysctl.h>
//测试与正式环境切换
#define test 1

//请求地址
#define kDNAppEntrance @"http://c.tagtic.cn/minfo/reg"
//请求参数--公共参数
#define kRParameter_timestamp     @"timestamp"
#define kRParameter_appkey        @"appkey"
#define kRParameter_app_version   @"app_version"
#define kRParameter_channel       @"channel"
#define kRParameter_lang          @"lang"
#define kRParameter_os_type       @"os_type"
#define kRParameter_os_version    @"os_version"
#define kRParameter_display       @"display"
#define kRParameter_device_type   @"device_type"
#define kRParameter_mac           @"mac"
#define kRParameter_network       @"network"
#define kRParameter_ip            @"ip"
#define kRParameter_register_days @"register_days"
#define kRParameter_event         @"event"
#define kRParameter_suuid         @"suuid"
#define kRParameter_nettype       @"nettype"

//请求参数--可选参数
#define kOParameter_use_interval       @"use_interval"
#define kOParameter_use_duration       @"use_duration"
#define kOParameter_os_upgrade_from    @"os_upgrade_from"
#define kOParameter_app_upgrade_from   @"app_upgrade_from"
#define kOParameter_error_type         @"error_type"
#define kOParameter_page_name          @"page_name"
#define kOParameter_last_page_name     @"last_page_name"
#define kOParameter_page_num           @"page_num"
#define kOParameter_event_name         @"event_name"
#define kOParameter_payment_method     @"payment_method"
#define kOParameter_money              @"money"
#define kOParameter_consumption_point  @"consumption_point"
//事件类型
#define kEvent_PageView  @"PageView"
#define kEvent_Register  @"Register"
#define kEvent_Startup   @"Startup"
#define kEvent_Shutdown  @"Shutdown"
#define kEvent_Ex_event  @"ExEvent"
//实时发送策略下的数据保存文件名
#define kFileName   @"DonesAnalyticsData.plist"
//发送策略下的数据保存文件名
#define kDBFileName   @"DonesAnalyticsDB.plist"
//数据文件的key
#define kFirstStartTime @""


/**
 发送策略
 */
typedef enum : NSUInteger {
    REALTIMETX,     //实时发送；
    LAUNCH,         //启动发送；
    SENDBYINTERVAL, //间隔发送，default 90s,间隔范围：[90~3600]；
    SENDBYDAY,      //每日发送；Not available
    SENDONLYWIFI,   //仅在WIFI下启动发送；Not available
    SENDBYONEXIT,   //进入后台时发送；Not available
} TransferPolicy;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//单例对象
static DonewsAnalytics *_instance = nil;
//事件的类型
void uncaughtExceptionHandlerByMM(NSException *exception);
/*
 * handle the uncaught exception
 */
void uncaughtExceptionHandlerByMM(NSException *exception) {
    if (exception) {
        NSArray *array = [exception callStackSymbols];
        if (array && [array count] > 0) {
            NSMutableString *stack = [NSMutableString stringWithCapacity:0];
            for (NSString *str in array) {
                [stack appendFormat:@"%@\n",str];
            }
        }
    }
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@interface DonewsAnalytics ()<NSURLSessionDelegate>
/**必填，app管理系统提供的appkey*/
@property (nonatomic, copy) NSString *appKey;
/**可选，安装渠道，在android与ios越狱渠道中使用*/
@property (nonatomic, copy) NSString *channelId;
/**必填，设备的IOS或android版本号*/
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;

/**自定义的appVersion，用于替换自动获取的appVersion*/
@property (nonatomic, copy) NSString *customAppVersion;
/**是否输出Log的判定值，默认为No*/
@property (nonatomic, assign) BOOL logValue;

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *firstStartTime;
@property (nonatomic, copy) NSString *backFrontTime;
@property (nonatomic, copy) NSString *exitEnd_time;
@property (nonatomic, copy) NSString *backgroundEndTime;

@property (nonatomic, strong) NSString *filePath;
/**发送策略*/
@property (nonatomic, assign) TransferPolicy transferPolicy;
//发送间隔
@property (nonatomic, assign) double intersvalSecond;
@property (nonatomic, strong) NSString *intersvalFilePath;
/**间隔发送策略下的发送定时器*/
@property (nonatomic, strong) NSTimer *sendTimer;
/**全局通用字典*/
@property (nonatomic, strong) NSMutableDictionary *commonDict;
/**判断是否存储保存推出时间的标记*/
@property (nonatomic, assign) BOOL saveOutTime;
@end
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@implementation DonewsAnalytics

#pragma mark - Public
/// @name  开启统计
+ (void)registDonewsSDK:(NSString *)appKey channelID:(NSString *)channelID
{
    DonewsAnalytics *agent = [DonewsAnalytics sharedInstance];
    agent.appKey = appKey;
    agent.channelId = channelID;
    [agent registAgent];
    [agent registStarttimeAgent];
    
}

/// @name  页面统计
+ (void)onPageAccess:(NSString *)pageName lastPageName:(NSString *)lastPageName pageNum:(long)pageNum
{
    if (_instance) {
        DonewsAnalytics *agent = [DonewsAnalytics sharedInstance];
        [agent createPageParamsDataWithPageName:pageName lastPageName:lastPageName pageNumber:pageNum appkey:agent.appKey];
    }
}
/// @name  事件统计
+ (void)onEvents:(NSString *)eventname
{
    if (_instance) {
        DonewsAnalytics *agent = [DonewsAnalytics sharedInstance];
        [agent createEvent:eventname];
    }
}
/// @name  游戏充值统计
+ (void)onRecharge:(NSString *)paymentMethod money:(long)money
{
    if (_instance) {
        DonewsAnalytics *agent = [DonewsAnalytics sharedInstance];
        [agent createRecharge:paymentMethod money:money];
    }
}
/// @name  游戏消费统计
+ (void)onConsumption:(NSString *)consumptionPoint money:(long)money
{
    if (_instance) {
        DonewsAnalytics *agent = [DonewsAnalytics sharedInstance];
        [agent createConsumption:(NSString *)consumptionPoint money:(long)money];
    }
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/// @name  设置
+ (void)setAppVersion:(NSString *)appVersion
{
    DonewsAnalytics *agent = [DonewsAnalytics sharedInstance];
    agent.customAppVersion = appVersion;
}
/** 设置是否打印sdk的log信息, 默认NO(不打印log)*/
+ (void)setLogEnabled:(BOOL)value
{
    DonewsAnalytics *agent = [DonewsAnalytics sharedInstance];
    agent.logValue = value;
    
}
+(void)setTransferPolicy:(TransferPolicy)transferPolicy
{
    DonewsAnalytics *agent = [DonewsAnalytics sharedInstance];
    agent.transferPolicy = transferPolicy;
    if (agent.transferPolicy == SENDBYINTERVAL) {
        [agent.sendTimer invalidate];
        agent.sendTimer = nil;
        agent.sendTimer = [NSTimer scheduledTimerWithTimeInterval:agent.intersvalSecond target:agent selector:@selector(sendTimerSel) userInfo:nil repeats:YES];
    }
}
+(void)setSendInterval:(double)second
{
    DonewsAnalytics *agent = [DonewsAnalytics sharedInstance];
    if (agent.transferPolicy == SENDBYINTERVAL) {
        if (second > 0.0 && second < 3600) agent.intersvalSecond = second;
        [agent.sendTimer invalidate];
        agent.sendTimer = nil;
        agent.sendTimer = [NSTimer scheduledTimerWithTimeInterval:agent.intersvalSecond target:agent selector:@selector(sendTimerSel) userInfo:nil repeats:YES];
    }
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Override
-(instancetype)init
{
    if (self = [super init]) {
        
        [self createContent];
    }
    return self;
}
-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Private
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
/**启动间隔统计*/
- (void)registStarttimeAgent
{
    if (!_appKey) {
        return;
    }
    //缓存
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.commonDict];
    [dict setObject:@"Startup" forKey:kRParameter_event];
    //程序首次启动的时间
    NSString *firstTime = [self readAppDataWithKey:@"firstStartTime"];
    //上次退出的时间
    NSString *lastTime = [self getSoftwareExitTime];
    //这次启动的时间
    NSString *currentTime = [self getTimeStampStr];
    //启动间隔 (若无法获取上次退出时间则使用程序首次启动时间)
    NSNumber *intervalTime = [self getTimeIntervalSecondsStart:lastTime ? lastTime : firstTime stopTime:currentTime];
    
    if (test) {
        NSLog(@"\n首次启动的时间：%@\n上次退出的时间：%@\n这次启动的时间：%@\n启动间隔：%@",firstTime,lastTime,currentTime,intervalTime);
    }
    [dict setObject:intervalTime forKey:kOParameter_use_interval];
    //根据发送策略对数据进行相应处理
    [self chooseSendPatternWithData:dict];
    
    
}
/**设置自定义统计*/
- (void)createEvent:(NSString *)eventName
{
    if (!_appKey) {
        return;
    }
    //缓存
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.commonDict];
    [dict setObject:@"ExEvent" forKey:kRParameter_event];
    [dict setObject:eventName forKey:kOParameter_event_name];
    //根据发送策略对数据进行相应处理
    [self chooseSendPatternWithData:dict];
}
/**设置页面统计*/
- (void)createPageParamsDataWithPageName:(NSString *)pageName
                            lastPageName:(NSString *)lastPageName
                              pageNumber:(long)pageNumber
                                  appkey:(NSString *)appkey
{
    if (!_appKey) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.commonDict];
    
    [dict setObject:@"PageView" forKey:kRParameter_event];
    
    if (pageName) {
        [dict setObject:pageName forKey:kOParameter_page_name];
    }
    if (lastPageName) {
        [dict setObject:lastPageName forKeyedSubscript:kOParameter_last_page_name];
    }
    if (pageNumber) {
        [dict setObject:[NSNumber numberWithLong:pageNumber] forKey:kOParameter_page_num];
    }
    //根据发送策略对数据进行相应处理
    [self chooseSendPatternWithData:dict];
    
}
/**游戏充值统计*/
- (void)createRecharge:(NSString *)paymentMethod money:(long)money
{
    if (!_appKey) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.commonDict];
    [dict setObject:@"Recharge" forKey:kRParameter_event];
    
    [dict setObject:paymentMethod ? paymentMethod : @"nil" forKey:kOParameter_payment_method];
    long temp = 0;
    [dict setObject:[NSNumber numberWithLong:money ? money : temp] forKey:kOParameter_money];
    
}
/**游戏消费统计*/
- (void)createConsumption:(NSString *)consumptionPoint money:(long)money
{
    if (!_appKey) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.commonDict];
    [dict setObject:@"Consumption" forKey:kRParameter_event];
    [dict setObject:consumptionPoint ? consumptionPoint : @"nil" forKey:kOParameter_payment_method];
    long temp = 0;
    [dict setObject:[NSNumber numberWithLong:money ? money : temp] forKey:kOParameter_money];
}
- (void)createContent
{
    //监听通知
    [self createObserver];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandlerByMM);
    
    self.firstStartTime = [self getTimeStampStr];
    if (self.firstStartTime) {
        self.startTime = self.firstStartTime;
    }
    //初始状态设置
    // app版本
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.appVersion = app_Version ? app_Version : @"0.0";
    //默认发送策略（实时发送）
    self.transferPolicy = REALTIMETX;
    //默认发送间隔 (90s)
    self.intersvalSecond = 2.0f;
    
    
}
//间隔发送策略下间隔一段时间会执行此方法发送数据
- (void)sendTimerSel
{
    
    [self sendDataPoolAndNewData:nil success:nil];
}

/**设置监听*/
- (void)createObserver
{
    NSNotificationCenter *notifiCenter = [NSNotificationCenter defaultCenter];
    [notifiCenter addObserver:self
                     selector:@selector(willPause:)
                         name:UIApplicationDidEnterBackgroundNotification object:nil];
    [notifiCenter addObserver:self
                     selector:@selector(willResume:)
                         name:UIApplicationWillEnterForegroundNotification object:nil];
    [notifiCenter addObserver:self
                     selector:@selector(willExit:)
                         name:UIApplicationWillTerminateNotification object:nil];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandlerByMM);
    
    
    self.firstStartTime = [self achieveTimeStampStr];
}
#pragma mark - NotificationSpy
- (void)willPause:(NSNotification *)notification
{
    
    self.backgroundEndTime = [self getTimeStampStr];
    self.endTime = self.backgroundEndTime;
    //保存程序退出的时间
    [self saveAppDataWithKey:@"exitTime" value:self.endTime];
    
    [self onAppResume:kDNAppEntrance];
    if (self.backgroundTask != UIBackgroundTaskInvalid) {
        return;
    }
    // 向后台申请时间
    UIApplication* application = [UIApplication sharedApplication];
    self.backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    
}
//程序从后台回到前台
- (void)willResume:(NSNotification *)notification
{
    self.backFrontTime = [self getTimeStampStr];
    if (self.backFrontTime) {
        self.startTime = self.backFrontTime;
    }
    //发送启动统计
    [self registStarttimeAgent];
}
- (void)willExit:(NSNotification *)notification
{
    self.exitEnd_time = [self getTimeStampStr];
    self.endTime = self.exitEnd_time;
    //保存程序退出的时间
    [self saveAppDataWithKey:@"exitTime" value:self.endTime];
    [self onAppResume:kDNAppEntrance];
    [self performSelector:@selector(endAgent) withObject:nil afterDelay:1.0f];
}

/**设置启动统计*/
-(void)onAppResume:(NSString *)urlStr{
    if (!_appKey) return;
    //缓存
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.commonDict];
    //程序首次启动时间
    NSString *firstTime = [self readAppDataWithKey:@"firstStartTime"];
    //程序启动的时间
    NSString *startTime = self.startTime;
    //程序退出的时间
    NSString *stopTime = [self readAppDataWithKey:@"exitTime"];
    //程序使用时长
    NSString *durationTime = [self getTimeIntervalSecondsStart:startTime stopTime:stopTime ? stopTime : firstTime];
    [dict setObject:durationTime forKey:kOParameter_use_duration];
    [dict setObject:@"Shutdown" forKey:kRParameter_event];
    //根据发送策略对数据进行相应处理
    [self chooseSendPatternWithData:dict];
}
/**结束统计*/
- (void)endAgent {
    if (_instance) {
        _instance = nil;
    }
}
/**注册统计*/
- (void)registAgent
{
    [self checkUpGrade];
    NSMutableDictionary *saveDict = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    if (saveDict){
        NSString *msg = [saveDict objectForKey:@"resgistMessage"];
        if ([msg isEqualToString:@"OK"]) return;
    }
    
    if (!_appKey && ![self judgeNetworkWith:kDNAppEntrance]) return;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.commonDict];
    NSMutableArray *postArray = [NSMutableArray array];
    [self getInfoParamsWithDictionary:dict];
    [dict setObject:@"Register" forKey:kRParameter_event];
    [self getOptionalParameters:dict];
    [postArray addObject:dict];
    [self POST:postArray withUrl:kDNAppEntrance success:^(NSDictionary * dict) {
        
        NSString *msg = [dict valueForKey:@"msg"];
        if ([msg isEqualToString:@"OK"]) [self saveAppDataWithKey:@"resgistMessage" value:msg];
    }];
}
//检测系统和软件升级情况
- (void)checkUpGrade
{
    //存储的系统版本
    NSString *saveOsVersion = [self readAppDataWithKey:@"firstOsVersion"];
    //存储的软件版本
    NSString *saveAppVersion = [self readAppDataWithKey:@"firstAppVersion"];
    //当前系统版本
    NSString *currentOsVersion = [[UIDevice currentDevice] systemVersion];
    //当前软件版本
    NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if (![saveOsVersion isEqualToString:currentOsVersion] && !saveOsVersion ) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.commonDict];
        [dict setObject:@"OSUpgrade" forKey:kRParameter_event];
        [dict setObject:saveOsVersion forKey:kOParameter_os_upgrade_from];
        //根据发送策略对数据进行相应处理
        [self chooseSendPatternWithData:dict];
    }
    if (![saveAppVersion isEqualToString:currentAppVersion] && !saveAppVersion ) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.commonDict];
        [dict setObject:@"AppUpgrade" forKey:kRParameter_event];
        [dict setObject:saveAppVersion forKey:kOParameter_app_upgrade_from];
        //根据发送策略对数据进行相应处理
        [self chooseSendPatternWithData:dict];
    }
    
}
#pragma mark - Tool

- (void)chooseSendPatternWithData:(NSMutableDictionary *)dict
{
    [self getInfoParamsWithDictionary:dict];
    switch (self.transferPolicy) {
        case REALTIMETX:
            //实时发送；
            if (![self judgeNetworkWith:kDNAppEntrance]) [self saveDataToPool:dict];
            else [self sendDataPoolAndNewData:dict success:^(BOOL pass) {
                [self saveAppOutTime];
            }];
            break;
        case LAUNCH:
            //启动发送；
            /**在启动发送策略下，保存数据到数据池中并在初始方法及程序回到前台通知中调用发送数据方法*/
            [self saveDataToPool:dict];
            break;
        case SENDBYINTERVAL:
            //间隔发送，default 90s,间隔范围：[90~3600]；
            /**在间隔发送策略下，保存数据到数据池中并在初始方法及程序回到前台通知中调用发送数据方法*/
            [self saveDataToPool:dict];
            break;
        case SENDBYDAY:
            //每日发送；
            [self saveDataToPool:dict];
            break;
        case SENDONLYWIFI:
            //仅在WIFI下启动发送；
            [self saveDataToPool:dict];
            break;
        case SENDBYONEXIT:
            //进入后台时发送；
            [self saveDataToPool:dict];
            break;
            
        default:
            [self saveDataToPool:dict];
            break;
    }
}
- (void)saveAppOutTime
{
    if (!self.saveOutTime) {
        [self saveAppDataWithKey:@"exitTime" value:[self getTimeStampStr]];
        self.saveOutTime = YES;
    }
}
/**
 *  将数据存入预先设置的数据池
 *  @param dict 要存入的数据
 */
- (void)saveDataToPool:(NSMutableDictionary *)dict
{
    NSMutableArray *saveArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.intersvalFilePath];
    if (!saveArray) saveArray = [NSMutableArray array];
    [saveArray addObject:dict];
    [NSKeyedArchiver archiveRootObject:saveArray toFile:self.intersvalFilePath];
    [self saveAppOutTime];
}
/**
 *  发送数据池中的数据
 *  @param dict 要发送的数据（没有时可传nil）
 *  @param success 是否发送回调的Block，携带一个是否发送成功的BOOL值
 *
 *  @return 缓存池中是否有数据
 */
- (BOOL)sendDataPoolAndNewData:(NSDictionary *)dict success:(void (^)(BOOL pass))success
{
    NSMutableArray *saveArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.intersvalFilePath];
    BOOL have = YES;
    if (!saveArray){
        saveArray = [NSMutableArray array];
        have = NO;
    }
    if (dict) [saveArray addObject:dict];
    if (saveArray.count > 0) {
        
        [self POST:saveArray withUrl:kDNAppEntrance success:^(NSDictionary * dict) {//如果请求成功则清空数据池
            
            if ([self resultWithDictionary:dict]) {
                if (success)  success(YES);
                if (have) [[NSFileManager defaultManager] removeItemAtPath:self.intersvalFilePath error:nil];
            }else {
                if (success)  success(NO);
            }
        }];
    }
    return have;
}
/**
 *  根据-请求返回的数据判断请求是否成功
 *  @param dict 返回的数据
 *  @return 是否成功
 */
- (BOOL)judgeResultWith:(NSDictionary *)dict
{
    NSString *msg = [dict valueForKey:@"msg"];
    if ([msg isEqualToString:@"OK"]) return YES;
    return NO;
}

//获取即时请求参数数据
- (void)getInfoParamsWithDictionary:(NSMutableDictionary *)dict
{
    // 1.时间轴
    [dict setObject:[self achieveTimeStampStr] forKey:kRParameter_timestamp];
    
    // 2.运营商种类
    [dict setObject:[self getNetwork] forKey:kRParameter_network];
    
    // 3.获取ip地址
    [dict setObject:[self getIPAddress:YES] ? [self getIPAddress:YES] : @"NULL" forKey:kRParameter_ip];
    
    // 4.获取网络类型
    [dict setObject:[self getNetWorkType] forKey:kRParameter_nettype];
    
}
/**
 *  注册sdk方法中所需添加的参数
 */
- (void)getOptionalParameters:(NSDictionary *)dict
{
    //1.升级前的系统版本号
    [dict setValue:[self getInitializationOsVersion] forKey:kOParameter_os_upgrade_from];
    //2.升级前的软件版本号
    [dict setValue:[self getInitializationAppVersion] forKey:kOParameter_app_upgrade_from];
}

/**获取注册天数*/
- (NSString *)getregisterDays
{
    NSMutableDictionary *cacheDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    NSString *firstStartTime = @"";
    NSString *registerDays = @"";
    if (!cacheDictionary) {
        firstStartTime = [self getTimeStampStr];
        [tempDict setObject:firstStartTime forKey:@"firstStartTime"];
        [NSKeyedArchiver archiveRootObject:tempDict toFile:self.filePath];
        
    }else{
        NSMutableDictionary *saveDict = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
        firstStartTime = [saveDict objectForKey:@"firstStartTime"];
    }
    
    registerDays = [self getTimeIntervalDays:firstStartTime];
    return registerDays;
}
/**
 计算与当前时间的时间间隔天数
 */
-(NSString *)getTimeIntervalDays:(NSString *)timeStr
{
    NSString *currentTime = [self getTimeStampStr];
    NSInteger currentTimeInt = [currentTime integerValue];
    NSInteger timestrInt = [timeStr integerValue];
    NSInteger days = (currentTimeInt - timestrInt)/60/60/24;
    
    return [NSString stringWithFormat:@"%ld",(long)days];
}
/**计算开始和结束的时间差*/
- (NSNumber *)getTimeIntervalSecondsStart:(NSString *)startTime stopTime:(NSString *)stopTime
{
    
    NSInteger startTimeInt = [startTime integerValue];
    NSInteger stopTimeInt = [stopTime integerValue];
    NSInteger senconds = (stopTimeInt - startTimeInt);
    
    return [NSNumber numberWithLong:(long)senconds];
//    return [NSString stringWithFormat:@"%ld",(long)senconds];
}
//获取时间戳
- (NSString *)getTimeStampStr
{
    UInt64 timeDate = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%llu",timeDate];
}
/**获取初始时的AppVersion*/
- (NSString *)getInitializationAppVersion
{
    return [self getInitializationDataWithKey:@"firstAppVersion" value:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}
/**获取初始时的OsVersion*/
- (NSString *)getInitializationOsVersion
{
    return [self getInitializationDataWithKey:@"firstOsVersion" value:[[UIDevice currentDevice] systemVersion]];
}
/**
 *  通过key获取存储的数据，如果没有获取到对应key下的数据则将传入来的数据以传入来的key进行保存
 *
 *  @param key   查找、保存值所用的key
 *  @param value 需要保存的数据
 *
 *  @return 查找到的数据
 */
- (NSString *)getInitializationDataWithKey:(NSString *)key value:(NSString *)value
{
    NSMutableDictionary *cacheDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    NSString *firstData = value ? value : @"nil";
    if (!cacheDictionary) {
        [tempDict setObject:firstData forKey:key];
        [NSKeyedArchiver archiveRootObject:tempDict toFile:self.filePath];
        return firstData;
    }else{
        firstData = [cacheDictionary objectForKey:key];
        if (firstData) {
            return firstData;
        }else{
            NSString *tempData = value ? value : @"nil";
            [cacheDictionary setObject:tempData forKey:key];
            [NSKeyedArchiver archiveRootObject:cacheDictionary toFile:self.filePath];
            return tempData;
        }
    }
    
}
/**获取上次软件退出的时间*/
- (NSString *)getSoftwareExitTime
{
    NSMutableDictionary *cacheDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    NSString *exitTime = @"";
    if (!cacheDictionary) {//没有记录则记录当前时间
        exitTime = [self getTimeStampStr];
        [tempDict setObject:exitTime forKey:@"exitTime"];
        [NSKeyedArchiver archiveRootObject:tempDict toFile:self.filePath];
        return exitTime;
    }else{//有记录读取记录
        NSMutableDictionary *saveDict = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
        exitTime = [saveDict objectForKey:@"exitTime"];
        return exitTime;
    }
    
}
/**
 *  保存、读取App的数据
 *  @return 返回已成功保存的数据
 */
- (void)saveAppDataWithKey:(NSString * __nonnull)key value:(NSString * __nonnull)value
{
    NSMutableDictionary *cacheDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    NSString *saveValue = @"nil";
    if (!cacheDictionary) {//没有文件则保存传入的数据为文件
        if (value) {
            saveValue = value;
            [tempDict setObject:saveValue forKey:key];
            [NSKeyedArchiver archiveRootObject:tempDict toFile:self.filePath];
        }
    }else{//有文件则将键值存入文件
        if (value) {
            saveValue = value;
            [cacheDictionary setObject:saveValue forKey:key];
            [NSKeyedArchiver archiveRootObject:cacheDictionary toFile:self.filePath];
        }
    }
}
/**
 *  读取保存的数据
 *  @return 保存的数据
 */
- (NSString *)readAppDataWithKey:(NSString *  __nonnull)key
{
    NSMutableDictionary *cacheDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    NSString *saveData = [cacheDictionary objectForKey:key];
    if (saveData) return saveData;
    else return @"nil";
}
/**
 *  根据提供的文件名生成相应的文件保存路径*/
- (NSString *)getSaveFilePath:(NSString *)subFileName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:[NSString stringWithFormat:@"/%@",subFileName]];
}

/**判断服务器地址是否可用*/
- (BOOL)judgeNetworkWith:(NSString * __nonnull)urlStr
{
    DonewsAdReachability *reachability = [DonewsAdReachability reachabilityWithHostName:kDNAppEntrance];
    NetworkStatus status = [reachability currentReachabilityStatus];
    return status == NotReachable ? NO : YES;
}
//获取时间轴
- (NSString *)achieveTimeStampStr
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SSS"];
    
    NSString *dateString1 = [dateFormatter stringFromDate:currentDate];
    NSString *dateString2 = [dateString1 stringByReplacingOccurrencesOfString:@" "withString:@"T"];
    NSString *dateString = [NSString stringWithFormat:@"%@Z",dateString2];
    return dateString;
    
}
/**运营商种类*/
- (NSString *)getNetwork
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    
    NSString *networkCode = carrier.mobileNetworkCode;
    if (networkCode) {
        if ([networkCode  isEqual: @"01"] || [networkCode  isEqual: @"06"] || [networkCode  isEqual: @"09"] ) {
            return @"unicom";
        }
        if ([networkCode  isEqual: @"00"] || [networkCode  isEqual: @"02"] || [networkCode  isEqual: @"07"] ) {
            return @"cmcc";
        }
        if ([networkCode  isEqual: @"03"] || [networkCode  isEqual: @"05"] || [networkCode  isEqual: @"11"] ) {
            return @"chinanet";
        }
        if ([networkCode  isEqual: @"04"]) {
            return @"Global Star Satellite";
        }
        if ([networkCode  isEqual: @"20"]) {
            return @"China Tietong";
        }
    }
    return networkCode ? networkCode : @"nil";
}
/**
 *  获取网络类型
 */
- (NSString *)getNetWorkType
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [NSString new];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"未知";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    state = @"未知";
                    break;
            }
        }
    }
    //根据状态选择
    return state ? state : @"nil";
}

//获取mac地址
- (NSString *) getMacAddress
{
    NSString *mac =[[NSUserDefaults standardUserDefaults] objectForKey:@"BUEncryptedMacAddress"];
    return mac ? mac : @"02:00:00:00:00:00";
}
//获取wifi下的ip地址
- (NSString *) localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return @"nil";
}
//----------------------------------------------------
/**获取IP地址*/
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
//-----------------------------------------------------
//获得设备型号
- (NSString *)getCurrentDevice
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}


#pragma mark - network
- (void)POST:(id)params withUrl:(NSString *)urlStr success:(void (^)(NSDictionary *_Nullable))success
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:18];
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setValue:[NSString stringWithFormat:@"application/json"]
      forHTTPHeaderField:@"Content-Type"];
    if (test) {
        NSLog(@"%@",params);
    }
    NSError *error = nil;
    NSData *postData = nil;
    if (params) postData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    
    [urlRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *con = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *Session = [NSURLSession sessionWithConfiguration:con delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [Session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dict != nil) if (success)  success(dict);
            if (self.logValue) NSLog(@"%@",dict ? [self resultWithDictionary:dict] : @"上传出现错误");
        }
    }];
    [task resume];
}
//请求结果打印分析方法
- (NSString *)resultWithDictionary:(NSDictionary *)dict
{
    NSString *msgStr = [NSString stringWithFormat:@"%@",dict[@"msg"]];
    NSString *resultStr = @"";
    if ([msgStr isEqualToString:@"OK"]) resultStr = [NSString stringWithFormat:@"\n%@\n",@"统计数据上传成功"];
    else resultStr = [NSString stringWithFormat:@"\n%@\n%@\n",@"统计数据上传失败",msgStr];
    
    return resultStr;
}

#pragma mark - Lazy loading
-(NSString *)filePath
{
    if (!_filePath) _filePath = [self getSaveFilePath:kFileName];
    return _filePath;
}
- (NSString *)intersvalFilePath
{
    if (!_intersvalFilePath) _intersvalFilePath = [self getSaveFilePath:kDBFileName];
    return _intersvalFilePath;
}
- (NSMutableDictionary *)commonDict
{
    if (!_commonDict) {
        _commonDict = [NSMutableDictionary dictionary];
        // 1.appkey
        [_commonDict setObject:_appKey forKey:kRParameter_appkey];
        // 2.app版本号
        if (_customAppVersion) [_commonDict setObject:_customAppVersion forKey:kRParameter_app_version];
        else [_commonDict setObject:_appVersion forKey:kRParameter_app_version];
        
        // 3.获取渠道
        [_commonDict setObject:[NSString stringWithFormat:@"%@",(self.channelId && ![self.channelId isEqualToString:@""]) ? self.channelId : @"App Store"] forKey:kRParameter_channel];
        // 4.用户语言
        NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
        [_commonDict setObject:currentLanguage ? currentLanguage : @"unknown" forKey:kRParameter_lang];
        // 5.系统类型
        [_commonDict setObject:[UIDevice currentDevice].systemName forKey:kRParameter_os_type];
        
        // 6.iOS版本号
        [_commonDict setObject:[[UIDevice currentDevice] systemVersion] forKey:kRParameter_os_version];
        
        // 7.设备分辨率
        CGSize size_screen = [[UIScreen mainScreen]bounds].size;
        CGFloat scale_screen = [UIScreen mainScreen].scale;
        CGFloat x = scale_screen * size_screen.width;
        CGFloat y = scale_screen * size_screen.height;
        NSString *display = [NSString stringWithFormat:@"%d*%d",(int)x,(int)y];
        [_commonDict setObject:display forKey:kRParameter_display];
        
        // 8.设备类型
        [_commonDict setObject:[self getCurrentDevice] forKey:kRParameter_device_type];
        
        // 9.设备mac地址
        [_commonDict setObject:[self getMacAddress] forKey:kRParameter_mac];
        
        //10.获取注册天数
        [_commonDict setObject:[self getregisterDays] forKey:kRParameter_register_days];
        
        // 11.uuid
        [_commonDict setObject:[[UIDevice currentDevice] identifierForVendor].UUIDString forKey:kRParameter_suuid];
    }
    return _commonDict;
}
@end