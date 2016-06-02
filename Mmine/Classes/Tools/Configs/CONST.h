//
//  CONST.h
//  Mmine
//
//  Created by Jamie on 16/6/1.
//  Copyright © 2016年 Ming. All rights reserved.
//

#ifndef CONST_h
#define CONST_h

/**
 *  1.判断是否是iOS7/8
 */
#define iOS8 [[UIDevice currentDevice].systemVersion doubleValue] >= 8.0
//判断是否为IOS7.0以后
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define _IOS7_NAV_HEIGHT  (IOS7_OR_LATER ? 44 : 64);
#define _IOS7_HEIGHTPLUS (_IOS7_ ? 0 : 20)

//屏幕尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

//自定义颜色
// 颜色
// 颜色
#define MColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//随机颜色
#define MRandomColor  [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]

//背景颜色
#define MColorBackground MColor(240, 240, 240)

#endif /* CONST_h */
