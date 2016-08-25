//
//  DonewsADView.m
//  AD_SDK Sample
//
//  Created by 焦子成 on 16/4/1.
//  Copyright © 2016年 JZC. All rights reserved.
//

#import "DonewsADView.h"
#import "DonewsAdReachability.h"
#import <QuartzCore/QuartzCore.h>
////设备运营商
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//MD5
#import <CommonCrypto/CommonDigest.h>

//获取 IP-----------------------------------------
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
//-----------------------------------------------

#define Screen_Width    [UIScreen mainScreen].bounds.size.width
#define Screen_Height   [UIScreen mainScreen].bounds.size.height

#define IPHONE_4        [UIScreen mainScreen].bounds.size.height==480
#define IPHONE_5        [UIScreen mainScreen].bounds.size.height==568
#define IPHONE_6        [UIScreen mainScreen].bounds.size.height==667
#define IPHONE_6P       [UIScreen mainScreen].bounds.size.height==736

#define authSecret      @"9507acdf858c112e78a88dd5ac205ba3"
#define AD_URL          @"http://r.dsp.tagtic.cn/api/mobile/req1?authKey=%@&signTime=%@&token=%@"
//#define AD_URL          @"http://192.168.25.194:4050/mobile/req1?authKey=%@&signTime=%@&token=%@"

/**********************************************************************************************/
typedef enum{
    DonewsAdTypeFullScreenAd    = 0, // 全屏广告      广告图片像素尺寸：640*960px；640*1136px；750*1334px；1080*1920px
    DonewsAdTypeBannerAd        = 1, // Banner广告   广告图片像素尺寸：640*100px(320宽度屏幕使用)；1080*166px(非320宽度屏幕使用，banner图片显示宽度为手机屏幕宽度，高度等比缩放)
    DonewsAdTypeInformationAd   = 2, // 信息流广告    广告图片像素尺寸：1000*560px
    
}DonewsAdType;
/**********************************************************************************************/

@interface DonewsADView ()<UIWebViewDelegate>

@property (nonatomic,assign) id<DonewsADDelegate> delegate;
@property (nonatomic,assign) DonewsAdType adType;
@property (nonatomic,assign) CGRect bannerFrame;
@property (nonatomic,strong) UIButton *bannerAdCloseButton; // Banner 广告关闭按钮
@property (nonatomic,strong) UIButton *fullScreenAdJumpButton; //全屏广告 跳过 按钮
@property (nonatomic,strong) NSTimer *timer;//全屏广告倒计时显示定时器
@property (nonatomic,strong) UILabel *fullScreenAdCountdownTimeLabel;//全屏广告倒计时显示Label
@property (nonatomic,strong) UIView *bannerShowOnView;//banner 视图显示的 View
@property (nonatomic,assign) NSInteger fullScreenAdCountdownTime;//全屏广告显示倒计时时间设置 默认为 4秒
@property (nonatomic,assign) BOOL showBannerAdCloseButton;//是否显示 Banner 广告关闭按钮 默认为 YES ，显示
@end

@implementation DonewsADView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



/****全屏广告****/
+ (void)requestFullScreenAdWithDelegate:(id<DonewsADDelegate>)delegate countdownTime:(NSInteger)time{
    DonewsADView *view0 = [[DonewsADView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view0.delegate = delegate;
    
    if (time > 0) view0.fullScreenAdCountdownTime = time;
    else view0.fullScreenAdCountdownTime = 4;
    
    view0.adType = DonewsAdTypeFullScreenAd;
    
    [view0 showDonewsAd];
}

/****Banner广告****/
+ (void)requestBannerAdWithDelegate:(id<DonewsADDelegate>)delegate frame:(CGRect)frame showOnView:(UIView *)view closeButtonShow:(BOOL)closeButton{
    
//    if (!view.window) {
    if (![DonewsADView isDisplayedInScreenWithView:view]) {
        if ([delegate respondsToSelector:@selector(donewsAdRequestDonewsADFailed:)]) {
            [delegate donewsAdRequestDonewsADFailed:@{@"msg":@"当前视图未显示在屏幕上！"}];
        }
        return;
    }
    
    CGRect rect;
    CGFloat h;
    if (Screen_Width == 320) {//320宽度的屏幕使用 640*100px 的广告图片
        h = 50;
    }else{
        //非320宽度的屏幕使用 1080*166px 的广告图片，根据屏幕宽度 宽高等比缩放
        h = floor((Screen_Width*166)/1080);//广告图片高度(宽度为屏幕宽度)
    }
    CGFloat y = (frame.origin.y > (view.bounds.size.height-h))?(view.bounds.size.height-h):frame.origin.y;// 如果Y值超出所在视图的高度，则在屏幕最下方。
    rect = CGRectMake(0, y, Screen_Width, h);
    
    DonewsADView *view1 = [[DonewsADView alloc] initWithFrame:rect];
    view1.delegate = delegate;
    view1.adType = DonewsAdTypeBannerAd;
    view1.bannerShowOnView = view;
    view1.showBannerAdCloseButton = closeButton;
    view1.bannerFrame = rect;
    
    [view1 showDonewsAd];
}

/****信息流广告****/
+ (void)requestInformationAdWithDelegate:(id<DonewsADDelegate>)delegate{
    DonewsADView *view2 = [[DonewsADView alloc] initWithFrame:CGRectZero];
    view2.delegate = delegate;
    view2.adType = DonewsAdTypeInformationAd;
    
    [view2 showDonewsAd];
}

#pragma mark - 
// 判断View是否显示在屏幕上
+ (BOOL)isDisplayedInScreenWithView:(UIView *)view{
    //view 映射到 window 上的 rect
    CGRect rect = [view convertRect:view.bounds toView:view.window];
    //判断两个矩形是否相交
    BOOL intersect = CGRectIntersectsRect(rect, view.window.frame);
    return intersect;
}

- (void)showDonewsAd{
    if (self.bannerShowOnView) {
        if (!self.bannerShowOnView.window) {
            if ([self.delegate respondsToSelector:@selector(donewsAdRequestDonewsADFailed:)]) {
                [self.delegate donewsAdRequestDonewsADFailed:@{@"msg":@"当前视图未显示在屏幕上！"}];
            }
            return;
        }
    }
    // 设备连网方式
    NetworkStatus status = [[DonewsAdReachability reachabilityWithHostName:@"www.baidu.com"] currentReachabilityStatus];
    if (status == ReachableViaWiFi || status == ReachableViaWWAN) {//WiFi || 移动网络
        [self requestAdData];
    } else {
        //未连接网络
        if ([self.delegate respondsToSelector:@selector(donewsAdRequestDonewsADFailed:)]) {
            [self.delegate donewsAdRequestDonewsADFailed:@{@"msg":@"No Internet connection."}];
        }
    }
}




#pragma mark - Request AD

- (void)requestAdData{
    NSURL *url = [NSURL URLWithString:[self getRequestHead]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [self getRequestBody];
    NSURLSession *session = [NSURLSession sharedSession];
    //    session.delegateQueue = [NSOperationQueue mainQueue];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"\n请求结果:\n%@\n",jsonDic);
                
                if (jsonDic == nil || jsonDic[@"msg"]) {//请求失败
                    if ([self.delegate respondsToSelector:@selector(donewsAdRequestDonewsADFailed:)]) {
                        [self.delegate donewsAdRequestDonewsADFailed:jsonDic];
                    }
                    return ;
                }
                [self requestFinished:jsonDic];
                
            }else{
                if ([self.delegate respondsToSelector:@selector(donewsAdRequestDonewsADFailed:)]) {
                    NSString *errorInfo = error.localizedDescription ? error.localizedDescription : @"The request timed out.";
                    [self.delegate donewsAdRequestDonewsADFailed:@{@"msg":errorInfo}];
//                    [self.delegate donewsAdRequestDonewsADFailed:@{@"msg":@"The request timed out."}];
                }
            }
        });
    }];
    [dataTask resume];
}

- (void)requestFinished:(NSDictionary *)dic{
    switch (_adType) {
        case DonewsAdTypeBannerAd:
        {
            UIWebView *webView = [[UIWebView alloc] initWithFrame:self.bounds];
            webView.delegate = self;
            webView.scrollView.bounces = NO;
            webView.scrollView.scrollEnabled = NO;
            webView.backgroundColor = [UIColor clearColor];
            if (!dic[@"htmladcontent"]) {
                if ([self.delegate respondsToSelector:@selector(donewsAdRequestDonewsADFailed:)]) {
                    [self.delegate donewsAdRequestDonewsADFailed:@{@"msg":@"null"}];
                }
                return;
            }
            [webView loadHTMLString:dic[@"htmladcontent"] baseURL:nil];
            
            [self addSubview:webView];
            
            if (self.showBannerAdCloseButton) {
                [self addSubview:self.bannerAdCloseButton];
                [self bringSubviewToFront:self.bannerAdCloseButton];
            }
            
            [self.bannerShowOnView addSubview:self];
            
            if ([self.delegate respondsToSelector:@selector(donewsAdRequestDonewsADSucceed)]) {
                [self.delegate donewsAdRequestDonewsADSucceed];
            }
        }
            break;
        case DonewsAdTypeFullScreenAd:
        {
            UIWebView *webView = [[UIWebView alloc] initWithFrame:self.bounds];
            webView.scrollView.bounces = NO;
            webView.scrollView.scrollEnabled = NO;
            webView.delegate = self;
            webView.backgroundColor = [UIColor clearColor];
            if (dic[@"htmladcontent"]) {
                [webView loadHTMLString:dic[@"htmladcontent"] baseURL:nil];
            }else{
                if ([self.delegate respondsToSelector:@selector(donewsAdRequestDonewsADFailed:)]) {
                    [self.delegate donewsAdRequestDonewsADFailed:@{@"msg":@"null"}];
                }
                return;
            }
            [self addSubview:webView];
            
            UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
            [window addSubview:self];
            
            [self addSubview:self.fullScreenAdJumpButton];
            
            [self addSubview:self.fullScreenAdCountdownTimeLabel];
            if (![_timer isValid]) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTrigger:) userInfo:nil repeats:YES];
            }
            /*直接使用倒计时关闭全屏广告
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.fullScreenAdCountdownTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self removeFromSuperview];
             });
             */
            if ([self.delegate respondsToSelector:@selector(donewsAdRequestDonewsADSucceed)]) {
                [self.delegate donewsAdRequestDonewsADSucceed];
            }
        }
            break;
        case DonewsAdTypeInformationAd:
        {
            if ([self.delegate respondsToSelector:@selector(donewsInformationAdDictionary:)]) {
                [self.delegate donewsInformationAdDictionary:dic];
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Request Head and Body

-(NSString *)getRequestHead{
    NSString *appkey = [_delegate donewsAdAppkey];
    
    NSString *signTime = [NSString stringWithFormat:@"%.0f",[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]];
    NSString *token = [self getMd5_32Bit_String:[signTime stringByAppendingString:authSecret]];
    
    NSString *requestStr = [NSString stringWithFormat:AD_URL,appkey,signTime,token];
    NSLog(@"\nPost请求头:\n%@",requestStr);
    return requestStr;
}

- (NSData *)getRequestBody{
    NSDictionary *imp = [self getImpDic];
    NSDictionary *device = [self getDeviceDic];
    
    NSDictionary *jsonDic = @{@"imp":imp,@"device":device};
    NSLog(@"\nPost请求体:\n%@",jsonDic);
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    
    return data;
}

- (NSDictionary *)getImpDic{
    NSMutableDictionary *impressionDic = [NSMutableDictionary dictionary];
    
    if (_adType == DonewsAdTypeBannerAd) {//--banner 广告
        NSMutableDictionary *bannerDic = [NSMutableDictionary dictionary];
        //>此处 banner 广告像素宽高请求 写死 320屏宽的使用640*100px的广告图片，其他屏幕使用1080*166px的广告图片
        if (Screen_Width == 320) {
            bannerDic[@"w"] = [NSNumber numberWithFloat:_bannerFrame.size.width*2];
            bannerDic[@"h"] = [NSNumber numberWithFloat:_bannerFrame.size.height*2];
        }else{
            bannerDic[@"w"] = @"1080";
            bannerDic[@"h"] = @"166";
        }
        
        if (_bannerFrame.origin.y == 0) {
            bannerDic[@"pos"] = @1;
        } else if (_bannerFrame.origin.y == Screen_Height-50) {
            bannerDic[@"pos"] = @2;
        } else {
            bannerDic[@"pos"] = @3;
        }
        
        impressionDic[@"banner"] = bannerDic;
        impressionDic[@"native"] = @0;
        impressionDic[@"instl"] = @0;
        impressionDic[@"ext"] = @{@"splash":@0};
    } else if (_adType == DonewsAdTypeInformationAd) {//--信息流广告
        impressionDic[@"banner"] = @{};
        impressionDic[@"native"] = @1;
        impressionDic[@"instl"] = @0;
        impressionDic[@"ext"] = @{@"splash":@0};
    } else if (_adType == DonewsAdTypeFullScreenAd) {//--全屏广告
        impressionDic[@"banner"] = @{};
        impressionDic[@"native"] = @0;
        impressionDic[@"instl"] = @0;
        impressionDic[@"ext"] = @{@"splash":@1};
    }
    return impressionDic;
}

// get geo Dic
- (NSMutableDictionary *)getGeo{
    NSMutableDictionary *geoDic = [NSMutableDictionary dictionary];
    //经纬度坐标
    
    //设备当前所在国家代码
    NSLocale *locale = [NSLocale currentLocale];
    if (locale) {
        [geoDic setObject:[locale localeIdentifier] forKey:@"country"];
    }
    
    return geoDic;
}

- (NSDictionary *)getDeviceDic {
    NSMutableDictionary *deviceDic = [NSMutableDictionary dictionary];
    
     //1.imei recommended string  设备的IMEI
     
     //2.dpid  recommended  string  AndroidID或IDFA
     
     //3.mac recommended  string MAC地址的SHA1哈希值，MAC地址原 文格式为 AA:BB:CC:DD:EE:FF
//    [deviceDic setObject:[self getMacAddress] forKey:@"mac"];
     //4.ua recommended  string 设备浏览器的User-Agent字符串
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    if (secretAgent) {
        [deviceDic setObject:secretAgent forKey:@"ua"];
    }
     //5.geo recommended  G 	e 	o object Geo对象，描述设备位置信息
    NSDictionary *geoDic = [NSDictionary dictionaryWithDictionary:[self getGeo]];
    [deviceDic setObject:geoDic forKey:@"geo"];
     //6.ip recommended string  设备的IP地址
    NSString *ip = [self getIPAddress:YES];
    [deviceDic setObject:ip ? ip : @"" forKey:@"ip"];
     //7.devicetype  optional  integer 设备类型，参考附录6.1
    if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"]) {
        [deviceDic setObject:[NSNumber numberWithInt:1] forKey:@"devicetype"];
    } else if ([[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        [deviceDic setObject:[NSNumber numberWithInt:3] forKey:@"devicetype"];
    }else {
        [deviceDic setObject:[NSNumber numberWithInt:0] forKey:@"devicetype"];
    }
     //8.make optional string 设备制造商
     [deviceDic setObject:@"Apple" forKey:@"make"];
     //9.model  optional string 设备型号
     [deviceDic setObject:[UIDevice currentDevice].model  forKey:@"model"];
     //10.os  optional  string 设备操作系统
    if ([UIDevice currentDevice].systemName) {
        [deviceDic setObject:[UIDevice currentDevice].systemName forKey:@"os"];
    }
     //11.osv  optional  string  设备操作系统版本号
    if ([[UIDevice currentDevice] systemVersion]) {
        [deviceDic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osv"];
    }
     //12.connectiontype optional  integer 设备联网方式，参考附录6.2
    NetworkStatus status = [[DonewsAdReachability reachabilityWithHostName:@"www.baidu.com"] currentReachabilityStatus];
    if (status == ReachableViaWiFi) {
        [deviceDic setObject:[NSNumber numberWithInt:1] forKey:@"connectiontype"];
    } else if (status == ReachableViaWWAN) {
        [deviceDic setObject:[NSNumber numberWithInt:2] forKey:@"connectiontype"];
    } else {
        [deviceDic setObject:[NSNumber numberWithInt:0] forKey:@"connectiontype"];
    }
     //13.carrier optional string 设 备 使 用 的 运 营 商 ， 使 用 M N C
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    if (carrier.mobileCountryCode) {
        [deviceDic setObject:carrier.mobileCountryCode forKey:@"carrier"];
    }
    if (carrier.mobileNetworkCode) {
        [deviceDic setObject:carrier.mobileNetworkCode forKey:@"carrier"];
    }
     //14.language optional string 设备的语言设置，使用 alpha-2 /IS O
    if ([[NSLocale preferredLanguages] firstObject]) {
        [deviceDic setObject:[[NSLocale preferredLanguages] firstObject] forKey:@"language"];
    }
     //15.639-1 w optional integer 设备屏幕分辨率宽度像素数
     //16.h optional integer 设备屏幕分辨率高度像素数
    if (IPHONE_6P) {//1080*1920
        //        [deviceDic setObject:[NSNumber numberWithFloat:Screen_Width*3] forKey:@"w"];
        //        [deviceDic setObject:[NSNumber numberWithFloat:Screen_Height*3] forKey:@"h"];
        [deviceDic setObject:@"1080" forKey:@"w"];
        [deviceDic setObject:@"1920" forKey:@"h"];
    }else{
        [deviceDic setObject:[NSNumber numberWithFloat:Screen_Width*2] forKey:@"w"];
        [deviceDic setObject:[NSNumber numberWithFloat:Screen_Height*2] forKey:@"h"];
    }
     //17.ppi optional integer 设备屏幕每英寸像素数，ppi
     
     //18.pxratio optional float 屏幕密度,IOS 系统 1 为标清,大于等于 2 为高清;
     
     //19.ext.orientation optional integer 设备屏幕方向：1 - 竖向，2 - 横向
    long a = (long)[[UIApplication sharedApplication] statusBarOrientation];
    if(a){
        if (a == 1) {
            [deviceDic setObject:@{@"orientation":[NSNumber numberWithInt:1]} forKey:@"ext"];
        } else {
            [deviceDic setObject:@{@"orientation":[NSNumber numberWithInt:2]} forKey:@"ext"];
        }
    }
    //20.suuid
    if ([[UIDevice currentDevice] identifierForVendor]) {
        [deviceDic setObject:[[UIDevice currentDevice] identifierForVendor].UUIDString forKey:@"suuid"];
    }
    
        return deviceDic;
}


#pragma mark - UI show on AD

- (UIButton *)bannerAdCloseButton {
    if (!_bannerAdCloseButton) {
        
        _bannerAdCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width-20, 0, 20, 20)];
        _bannerAdCloseButton.backgroundColor = [UIColor clearColor];
        _bannerAdCloseButton.exclusiveTouch = YES;
        _bannerAdCloseButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        [_bannerAdCloseButton addTarget:self action:@selector(bannerAdCloseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // draw the close image
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        CGContextRef ctx = CGBitmapContextCreate(nil, 40, 40, 8, 0, colorspace,
                                                 kCGImageAlphaPremultipliedLast);
        CGColorSpaceRelease(colorspace);
        CGPoint center = CGPointMake(20, 20);
        CGContextAddArc(ctx, center.x, center.y, 18, 0, 2*M_PI, 0);
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.8 alpha:0.5].CGColor);
        CGContextFillPath(ctx);
        
        CGContextMoveToPoint(ctx, 20-8, 20-8);
        CGContextAddLineToPoint(ctx, 20+8, 20+8);
        CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.0 alpha:0.8].CGColor);
        CGContextSetLineWidth(ctx, 2.0);
        CGContextStrokePath(ctx);
        
        CGContextMoveToPoint(ctx, 20-8, 20+8);
        CGContextAddLineToPoint(ctx, 20+8, 20-8);
        CGContextStrokePath(ctx);
        
//        CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
//        CGContextSetLineWidth(ctx, 1.0);
//        CGContextAddArc(ctx, center.x, center.y, 14, 0, 2*M_PI, 0);
//        CGContextStrokePath(ctx);
        
        // set the image
        CGImageRef backImgRef = CGBitmapContextCreateImage(ctx);
        CGContextRelease(ctx);
        UIImage *image = [[UIImage alloc] initWithCGImage:backImgRef];
        CGImageRelease(backImgRef);
        
        [_bannerAdCloseButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    return _bannerAdCloseButton;
}

- (UIButton *)fullScreenAdJumpButton{
    if (!_fullScreenAdJumpButton)
    {
        _fullScreenAdJumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenAdJumpButton.backgroundColor = [UIColor whiteColor];
        _fullScreenAdJumpButton.frame = CGRectMake(Screen_Width-20-55, 30, 60, 20);
        [_fullScreenAdJumpButton setTitle:@"   跳过" forState:UIControlStateNormal];
        [_fullScreenAdJumpButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_fullScreenAdJumpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _fullScreenAdJumpButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _fullScreenAdJumpButton.layer.cornerRadius = 10;
        [_fullScreenAdJumpButton addTarget:self action:@selector(fullScreenAdJumpButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenAdJumpButton;
}

- (UILabel *)fullScreenAdCountdownTimeLabel{
    if (!_fullScreenAdCountdownTimeLabel) {
        _fullScreenAdCountdownTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(Screen_Width-20-20, 30, 20, 20)];
        _fullScreenAdCountdownTimeLabel.backgroundColor = [UIColor clearColor];
        _fullScreenAdCountdownTimeLabel.textColor = [UIColor blackColor];
        _fullScreenAdCountdownTimeLabel.font = [UIFont systemFontOfSize:15];
        _fullScreenAdCountdownTimeLabel.adjustsFontSizeToFitWidth = YES;
        _fullScreenAdCountdownTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fullScreenAdCountdownTimeLabel.text = [NSString stringWithFormat:@"%ld",(long)--_fullScreenAdCountdownTime];
        _fullScreenAdCountdownTimeLabel.alpha = 0.5f;
    }
    return _fullScreenAdCountdownTimeLabel;
}

- (void)bannerAdCloseButtonClicked:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(donewsAdUserCloseBannerAd)]) {
        [self.delegate donewsAdUserCloseBannerAd];
    }
    [self removeFromSuperview];
}

- (void)fullScreenAdJumpButtonClicked{
    [self removeFromSuperview];
}

- (void)timerTrigger:(NSTimer *)time{
    _fullScreenAdCountdownTime--;
    if (_fullScreenAdCountdownTime > 0) {
        _fullScreenAdCountdownTimeLabel.text = [NSString stringWithFormat:@"%ld",(long)_fullScreenAdCountdownTime];
    }else{
        [_timer invalidate];
        [self removeFromSuperview];
    }
    
}


#pragma mark - UIWebViewDelegate
//点击广告图片跳转浏览器打开
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationTyp{
    NSLog(@"----->webViewshouldStartLoad");
    if ( navigationTyp == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}
//------------------------测试----------------------------//
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"----->webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"----->webViewDidFinishLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"----->webViewdidFailLoad");
}
//-------------------------测试---------------------------//


#pragma mark - MD5 String

- (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    
    const char *cStr = [srcString UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (int)strlen(cStr), digest );
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
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

- (void)getPPI
{
    
}
//获取mac地址
- (NSString *) getMacAddress
{
    NSString *mac =[[NSUserDefaults standardUserDefaults] objectForKey:@"BUEncryptedMacAddress"];
    return mac ? mac : @"02:00:00:00:00:00";
}
//-----------------------------------------------------
@end
