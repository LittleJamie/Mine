//
//  DonewsAnalytics.h
//  DonewsMingProductTest
//
//  Created by Jamie on 16/5/11.
//  Copyright © 2016年 Donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DonewsAnalytics : NSObject
///---------------------------------------------------------------------------------------
/// @name  开启统计
///---------------------------------------------------------------------------------------

/**
 *  注册SDK,首先需要到官网注册并且添加新应用，获得Appkey,此在AppDelegate的didFinishLaunchingWithOptions中调用
 *  初始化后会自动统计 App的启动和退出时间；
 *
 *  @param appKey app管理系统提供的appkey;
 *  @param channelID 安装渠道，ios越狱渠道中使用;
 */

+ (void)registDonewsSDK:(NSString *)appKey channelID:(NSString *)channelID;

///---------------------------------------------------------------------------------------
/// @name  页面统计
///---------------------------------------------------------------------------------------

/**
 *    页面访问统计,当开发者需要时调用.
 *
 *  @param pageName     自定义的页面标识
 *  @param lastPageName 进入该页面前的上一个页面，如果是第一个页面可以为空。
 *  @param pageNum      自定义的访问的页面序号。如：1、2、3
 */
+ (void)onPageAccess:(NSString *)pageName lastPageName:(NSString *)lastPageName pageNum:(int)pageNum;

///---------------------------------------------------------------------------------------
/// @name  事件统计
///---------------------------------------------------------------------------------------

/**
 *  记录事件,当开发者需要时调用.
 *
 *  @param eventname 事件名称
 */
+ (void)onEvents:(NSString *)eventname;
@end
