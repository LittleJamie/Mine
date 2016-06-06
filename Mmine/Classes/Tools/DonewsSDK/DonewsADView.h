//
//  DonewsADView.h
//  AD_SDK Sample
//
//  Created by 焦子成 on 16/4/1.
//  Copyright © 2016年 JZC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DonewsADView;

@protocol DonewsADDelegate <NSObject>

@required
/*
 * 使用本SDK必须有相应的appkey
 */
- (NSString *)donewsAdAppkey;

@optional
/*
 * 通知用户，广告请求成功。
 */
- (void)donewsAdRequestDonewsADSucceed;
/*
 * 通知用户，广告请求失败。
 * errorDic 为错误信息
 */
- (void)donewsAdRequestDonewsADFailed:(NSDictionary *)errorDic;
/*
 * 用于获取InformationAd的广告信息,返回的字典就是信息流广告的广告内容信息
 */
- (void)donewsInformationAdDictionary:(NSDictionary *)dic;
/*
 * 用户关闭 Banner 广告时会调用
 */
- (void)donewsAdUserCloseBannerAd;

@end


@interface DonewsADView : UIView

/* 全屏广告
 * 
 * 广告图片像素尺寸：640*960px；640*1136px；750*1334px；1080*1920px
 * countdownTime：全屏广告显示时间(如果 time<=0时，会默认显示4秒)
 */
+ (void)requestFullScreenAdWithDelegate:(id<DonewsADDelegate>)delegate countdownTime:(NSInteger)time;

/* Banner广告
 *
 * 广告图片像素尺寸：640*100px(320宽度屏幕使用)；1080*166px(非320宽度屏幕使用，banner图片显示宽度为手机屏幕宽度，高度等比缩放)
 * showOnView: banner广告显示在哪个视图上
 */
+ (void)requestBannerAdWithDelegate:(id<DonewsADDelegate>)delegate frame:(CGRect)frame showOnView:(UIView *)view closeButtonShow:(BOOL)closeButton;

/* 信息流广告
 *
 * 广告请求成功后会调用 informationAdDictionary: 代理方法，返回一个字典，该字典中存放广告的所有信息，用户可自由显示
 */
+ (void)requestInformationAdWithDelegate:(id<DonewsADDelegate>)delegate;

@end
