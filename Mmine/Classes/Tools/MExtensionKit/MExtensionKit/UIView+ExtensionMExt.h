//
//  UIView+ExtensionMExt.h
//  CompanyTest
//
//  Created by Jamie on 16/3/24.
//  Copyright © 2016年 Donews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ExtensionMExt)
/**
 * @brief 获得视图的x值
 *
 * @return x值
 */
- (CGFloat)frameX_Ext;

/**
 * @brief 获得视图的y值
 *
 * @return y值
 */
- (CGFloat)frameY_Ext;

/**
 *	@brief	获取视图宽度
 *
 *	@return	宽度值（像素）
 */
- (CGFloat)frameWidth_Ext;


/**
 *	@brief	获取视图高度
 *
 *	@return	高度值（像素）
 */
- (CGFloat)frameHeight_Ext;


/**
 *	@brief	获取view的截图
 *
 *	@return	图片
 */
- (UIImage *)screenshot_Ext;


/**
 *	@brief	得到当前的第一响应者
 *
 *	@return	返回第一响应者，没有返回nil
 */
- (UIView *)currentFirstResponderView_Ext;

@end
