//
//  LanguageMExt.m
//  CompanyTest
//
//  Created by Jamie on 16/3/24.
//  Copyright © 2016年 Donews. All rights reserved.
//

#import "LanguageMExt.h"
NSString *LocalFileName_Language=@"Localization";
NSString * const MSLocalLanguageDidChangeNotification = @"ESLocalLanguageDidChangeNotification";


@implementation LanguageMExt
static  NSBundle *bundle = nil;
static  NSString * labguageString=nil;

+(void)initialize {
    if (LocalFileName_Language.length==0) {
        LocalFileName_Language=@"Localization";
    }
    NSArray* languages = [NSLocale preferredLanguages];
    __strong  NSString *current = [languages objectAtIndex:0];
    [self setLanguage:current];
    
}

/*
 example calls:
 [Language setLanguage:@"it"];
 [Language setLanguage:@"de"];
 */
+(void)setLanguage:(NSString *)l {
    
    BOOL isHave=NO;
    
    NSFileManager * manager=[NSFileManager defaultManager];
    
    if (l.length>0) {
        NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
        if ([manager fileExistsAtPath:path]) {
            isHave=YES;
            labguageString=nil;
            bundle=nil;
            labguageString=[[NSString  alloc]initWithFormat:@"%@",l];
            bundle=[[NSBundle alloc]initWithPath:path];
        }
    }
    
    
    if (isHave==NO) {
        
        NSArray* languages = [NSLocale preferredLanguages];
        NSString *current = [languages objectAtIndex:0];
        NSString * testPath=[[ NSBundle mainBundle ] pathForResource:current ofType:@"lproj" ];
        if ([manager fileExistsAtPath:testPath]==NO) {
            current=@"en";
            testPath=[[NSBundle mainBundle] pathForResource:current ofType:@"lproj"];
        }
        labguageString=nil;
        bundle=nil;
        labguageString=[[NSString alloc]initWithFormat:@"%@",current];
        bundle=[[NSBundle alloc]initWithPath:testPath];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MSLocalLanguageDidChangeNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"CurrentLanguage",labguageString, nil]];
    
}
+(NSString *)getCurrentLanguageStringWithLocal
{
    if (labguageString==nil||labguageString.length==0 ) {
        [self initialize];
    }
    return labguageString;
}
+(NSString *)getLocalizedString:(NSString *)key alter:(NSString *)alternate{
    if (bundle==nil) {
        [self initialize];
    }
    if (LocalFileName_Language.length==0) {
        LocalFileName_Language=@"Localization";
    }
    return  NSLocalizedStringFromTableInBundle(key, LocalFileName_Language, bundle, alternate);
}

+(NSString *)localizedStringWithKey:(NSString *)key withAlter:(NSString *)alternate
{
    if (bundle==nil) {
        [self initialize];
    }
    return NSLocalizedStringFromTableInBundle(key, @"Localization", bundle, alternate);
}
@end
