//
//  UILabel+ExtensionMExt.m
//  CompanyTest
//
//  Created by Jamie on 16/3/24.
//  Copyright © 2016年 Donews. All rights reserved.
//

#import "UILabel+ExtensionMExt.h"

@implementation UILabel (ExtensionMExt)


- (CGSize)fitTextHeight_Ext
{
    CGSize size=CGSizeMake(self.bounds.size.width, NSIntegerMax);
    
    return [self contentSizeWithSize:size];
}

- (CGSize)fitTextWidth_Ext
{
    CGSize size=CGSizeMake( NSIntegerMax,self.bounds.size.height);
    
    return [self contentSizeWithSize:size];
}

- (CGSize)contentSizeWithSize:(CGSize)sizet {
    
    
#ifndef __IPHONE_7_0
#define __IPHONE_7_0     70000
#endif
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0)
    {
        
        CGSize size=[self.text sizeWithFont:self.font constrainedToSize:sizet lineBreakMode:self.lineBreakMode];
        return size;
    }
    else{
        
        /*
         NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
         paragraphStyle.lineBreakMode = self.lineBreakMode;
         paragraphStyle.alignment = self.textAlignment;
         */
        NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                      };///NSParagraphStyleAttributeName : paragraphStyle
        
        CGSize contentSize = [self.text boundingRectWithSize:sizet
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes:attributes
                                                     context:nil].size;
        return contentSize;
        
        
    }
#else
    NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                  };///NSParagraphStyleAttributeName : paragraphStyle
    
    CGSize contentSize = [self.text boundingRectWithSize:sizet
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    return contentSize;
    
#endif
    
    
    
    
    
}

@end
