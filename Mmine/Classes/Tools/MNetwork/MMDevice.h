//
//  MMDevice.h
//  Mmine
//
//  Created by Jamie on 16/6/14.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
@interface MMDevice : MTLModel<MTLJSONSerializing>
/**Header中Device相关信息*/
@property (nonatomic,copy)NSString *Platform;
@property (nonatomic,copy)NSString *Model;
@property (nonatomic,copy)NSString *Factory;
@property (nonatomic,copy)NSString *ScreenSize;
@property (nonatomic,copy)NSString *Denstiy;
@property (nonatomic,copy)NSString *IMEI;
@property (nonatomic,copy)NSString *Mac;
@property (nonatomic,copy)NSString *ClientId;

@end
