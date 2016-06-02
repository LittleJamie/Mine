//
//  MMHomeViewModel.h
//  Mmine
//
//  Created by Jamie on 16/6/2.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMHomeViewModel : NSObject

+ (void)loadModuleSelectionViewData:(void (^)(NSArray *moduleArray))block;
@end
