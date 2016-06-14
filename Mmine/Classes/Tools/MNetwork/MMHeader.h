//
//  MMHeader.h
//  Mmine
//
//  Created by Jamie on 16/6/14.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "Mantle.h"
@class MMApp,MMDevice;
@interface MMHeader : MTLModel<MTLJSONSerializing>

/**请求的header头*/
@property (nonatomic,strong)MMApp *App;
@property (nonatomic,strong)MMDevice *Device;


@end
