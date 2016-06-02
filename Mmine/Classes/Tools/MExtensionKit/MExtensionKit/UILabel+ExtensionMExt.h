//
//  UILabel+ExtensionMExt.h
//  CompanyTest
//
//  Created by Jamie on 16/3/24.
//  Copyright © 2016年 Donews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ExtensionMExt)
/**
 * 适应字数高度的大小，宽度固定，高度根据字数得到
 *
 * @return 大小
 */
- (CGSize)fitTextHeight_Ext;

/**
 * 适应字数的宽度的大小，高度不变，宽度根据字数长度
 *
 * @return 大小
 */
- (CGSize)fitTextWidth_Ext;


@end
