//
//  UIBarButtonItem+JAExt.h
//  WeiboByMing
//
//  Created by Jamie on 15/12/31.
//  Copyright © 2015年 Jamie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (JAExt)
/**
 *  添加按钮的方法
 *
 *  @param imageNmae     图片名
 *  @param highImageNmae 高亮状态的图片名
 *  @param target        点击目标对象
 *  @param action        点击执行目标对象的方法
 *
 *  @return 输出一个按钮
 */
+(UIBarButtonItem *)itemWithImageName:(NSString *)imageNmae HighImageNmae:(NSString *)highImageNmae Target:(id)target Action:(SEL)action;
@end
