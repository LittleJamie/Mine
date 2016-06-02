//
//  UIFont+ExtensionMExt.m
//  CompanyTest
//
//  Created by Jamie on 16/3/29.
//  Copyright © 2016年 Donews. All rights reserved.
//

#import "UIFont+ExtensionMExt.h"
#import "UIDevice+ExtensionMExt.h"
@implementation UIFont (ExtensionMExt)


+ (UIFont *)mm_appNavTitleFont {
    return [self mm_appFontWith:32.0];
}
+ (UIFont *)mm_appBigTitleFont {
    return [self mm_appFontWith:36.0];
}
+ (UIFont *)mm_appTitleFont {
    return [self mm_appFontWith:32.0];
}


+ (UIFont *)mm_appFontWith:(CGFloat)iPhone_6FontPx {
    
    //    CGFloat screenW = [[UIScreen mainScreen] currentMode].size.width;
    //    CGFloat screenH = [[UIScreen mainScreen] currentMode].size.height;
    //
    //    UIDevice *device = [[UIDevice alloc] init];
    //    CGFloat deviceInch = [device is3_5Inch_Ext]?3.5:([device is4Inch_Ext]?4:([device is4_7Inch_Ext]?4.7:([device is5_5Inch_Ext]?5.5:4.7)));
    //
    //    CGFloat ppiCount = sqrt(screenW*screenW+screenH*screenH)/deviceInch;//px/inch
    //
    //    NSLog(@"---当前设备ppi:%f",ppiCount);
    //    CGFloat font_pt = font_px/ppiCount/72;
    
    CGFloat perPt = [[UIScreen mainScreen] bounds].size.width/[[UIScreen mainScreen] currentMode].size.width;
    CGFloat font_pt = iPhone_6FontPx*perPt;
    
    UIDevice *device = [[UIDevice alloc] init];
    if (![device isRetain_Ext]) {
        font_pt = font_pt * 0.5;
    } else if ([device is4Inch_Ext]||[device is4_7Inch_Ext]) {
        
    } else if ([device is5_5Inch_Ext]) {
        font_pt = font_pt * 1.5;
    } else {
        
    }
    
    return [UIFont systemFontOfSize:font_pt];
}




+ (UIFont *)mm_appBoldFontWith:(CGFloat)iPhone_6FontPx {
    CGFloat perPt = [[UIScreen mainScreen] bounds].size.width/[[UIScreen mainScreen] currentMode].size.width;
    CGFloat font_pt = iPhone_6FontPx*perPt;
    
    UIDevice *device = [[UIDevice alloc] init];
    if (![device isRetain_Ext]) {
        font_pt = font_pt * 0.5;
    } else if ([device is4Inch_Ext]||[device is4_7Inch_Ext]) {
        
    } else if ([device is5_5Inch_Ext]) {
        font_pt = font_pt * 1.5;
    } else {
        
    }
    return [UIFont boldSystemFontOfSize:font_pt];
}
@end
