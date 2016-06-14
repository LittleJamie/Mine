//
//  MMApp.h
//  Mmine
//
//  Created by Jamie on 16/6/14.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface MMApp : MTLModel<MTLJSONSerializing>
/**Header中的App相关信息*/
@property (nonatomic,copy)NSString *PackageName;
@property (nonatomic,copy)NSString *AppName;
@property (nonatomic,copy)NSString *Version;
@property (nonatomic,copy)NSString *MobileType;
@property (nonatomic,copy)NSString *Channel;

@end
