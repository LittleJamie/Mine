//
//  UIView+ExtensionMExt.m
//  CompanyTest
//
//  Created by Jamie on 16/3/24.
//  Copyright © 2016年 Donews. All rights reserved.
//

#import "UIView+ExtensionMExt.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIView (ExtensionMExt)

- (CGFloat)frameX_Ext;
{
    return self.frame.origin.x;
}
- (CGFloat)frameY_Ext
{
    return self.frame.origin.y;
}
- (CGFloat)frameWidth_Ext
{
    return self.frame.size.width;
}

- (CGFloat)frameHeight_Ext
{
    return self.frame.size.height;
}




- (UIImage *)screenshot_Ext
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0)
    {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenshot;
    }
    else{
        UIGraphicsBeginImageContext(self.bounds.size);
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
}


- (UIView *)currentFirstResponderView_Ext
{
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView currentFirstResponderView_Ext];
        if (firstResponder != nil) {
            return firstResponder;
        }
        
    }
    
    return nil;
}


//**********************************************
/** 控件的 X*/
-(CGFloat)x{
    CGRect rect = self.frame;
    return rect.origin.x;
}
-(void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
/** 控件的 Y*/
-(CGFloat)y{
    CGRect rect = self.frame;
    return rect.origin.y;
}
-(void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
/** 控件的 宽*/
-(CGFloat)width{
    CGRect rect = self.frame;
    return rect.size.width;
}
-(void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
/** 控件的 高*/
-(CGFloat)height{
    CGRect rect = self.frame;
    return rect.size.height;
}
-(void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
/** 控件的 尺寸*/
-(CGSize)size{
    return self.frame.size;
}
-(void)setSize:(CGSize)size{
    self.width = size.width;
    self.height = size.height;
}
-(void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
/** 控件的 中心点坐标 X*/
-(CGFloat)centerX{
    return self.center.x;
}
-(void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
/** 控件的 中心点坐标 Y*/

-(CGFloat)centerY{
    return self.center.y;
}
@end
