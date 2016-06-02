//
//  ExtensionMacros.h
//  CompanyTest
//
//  Created by Jamie on 16/3/24.
//  Copyright © 2016年 Donews. All rights reserved.
//


#ifndef ExtensionSDK_ExtensionMacros_h
#define ExtensionSDK_ExtensionMacros_h

///是否打印log
#define kLogEnable_Ext 0

#if kLogEnable_Ext
#define kExtLog(...) NSLog(__VA_ARGS__)
#else
#define kExtLog(...) nil
#endif


#ifndef kLibraryCaches_Ext
#define kLibraryCaches_Ext [NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()]
#endif

#ifndef kCachesDocument_Ext
#define kCachesDocument_Ext [NSString stringWithFormat:@"%@/CachesDocument",kLibraryCaches_Ext]
#endif

#ifndef kCrashLogPath_Ext
#define kCrashLogPath_Ext [NSString stringWithFormat:@"/%@/kCrashLog",kCachesDocument_Ext]
#endif
#endif
