//
//  HelperMExt.m
//  CompanyTest
//
//  Created by Jamie on 16/3/24.
//  Copyright © 2016年 Donews. All rights reserved.
//

#import "HelperMExt.h"

@implementation HelperMExt
+(NSString*)getUUID_Ext
{
    CFUUIDRef puuid = CFUUIDCreate( kCFAllocatorDefault );
    CFStringRef uuidString = CFUUIDCreateString( kCFAllocatorDefault, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( kCFAllocatorDefault, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+(NSString *)getRandomNumberwithLength_Ext:(int)length
{
    if (length==0 ||length<0)
    {
        return nil;
    }
    NSMutableString * result=[NSMutableString string];
    
    for (int i=0; i<length; i++)
    {
        if (i==0)
        {
            [result appendFormat:@"%d",arc4random()%9+1];
        }
        else{
            [result appendFormat:@"%d",arc4random()%10];
        }
    }
    
    return result;
}

+(NSString *)getRandomStringwithLength_Ext:(int)length
{
    
    if (length==0 ||length<0)
    {
        return nil;
    }
    NSMutableString * result=[NSMutableString string];
    
    for (int i=0; i<length; i++)
    {
        if ((arc4random()%2+1)%2==0)
        {
            [result appendFormat:@"%c",arc4random()%26+97];
        }
        else{
            [result appendFormat:@"%c",arc4random()%26+65];
        }
    }
    
    return result;
}

+(NSString *)getRandomNumberAndStringWithLength_Ext:(int)length
{
    if (length==0 ||length<0)
    {
        return nil;
    }
    NSMutableString * result=[NSMutableString string];
    
    for (int i=0; i<length; i++)
    {
        if ((arc4random()%3+1)==1)
        {
            [result appendFormat:@"%c",arc4random()%26+97];
        }
        else if ((arc4random()%3+1)==1)
        {
            [result appendFormat:@"%c",arc4random()%26+65];
        }
        else{
            [result appendFormat:@"%d",arc4random()%10];
        }
    }
    
    return result;
}
@end
