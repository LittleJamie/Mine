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

@end
