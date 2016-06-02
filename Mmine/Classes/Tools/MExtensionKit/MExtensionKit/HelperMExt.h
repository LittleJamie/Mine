//
//  HelperMExt.h
//  CompanyTest
//
//  Created by Jamie on 16/3/24.
//  Copyright © 2016年 Donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelperMExt : NSObject
/**
 *	随机生成UUID
 *	@return 生成的uuid字符串
 */
+(NSString*)getUUID_Ext;

/**
 *	生成随机数
 *	@param length 随机数的位数
 *	@return 随机数的字符串
 */
+(NSString *)getRandomNumberwithLength_Ext:(int)length;

/**
 *	生成随机字符串，区分大小写
 *	@param  字符长度
 *	@return 字符串
 */
+(NSString *)getRandomStringwithLength_Ext:(int)length;

/**
 *	生成随机字符和数字字符串
 *	@param length 字符串的长度
 *	@return 字符串
 */
+(NSString *)getRandomNumberAndStringWithLength_Ext:(int)length;


@end
