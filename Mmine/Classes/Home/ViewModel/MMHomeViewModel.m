//
//  MMHomeViewModel.m
//  Mmine
//
//  Created by Jamie on 16/6/2.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMHomeViewModel.h"
#import "MMHomeModuleModel.h"

@interface MMHomeViewModel ()
@property (nonatomic, strong) NSMutableArray *moduleArray;
@end
@implementation MMHomeViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)loadModuleSelectionViewData:(void (^)(NSArray *moduleArray))block
{
    MMHomeViewModel *viewModel = [MMHomeViewModel new];
    
    [viewModel addModuleWithName:@"MNews" className:@"MMNewsViewController" image:nil];
    [viewModel addModuleWithName:@"MBook" className:@"MMMBookViewController" image:nil];
    [viewModel addModuleWithName:@"MBrowser" className:@"MMMBrowserViewController" image:nil];
    [viewModel addModuleWithName:@"MCalendar" className:@"MMNCalenderViewController" image:nil];
    [viewModel addModuleWithName:@"MContacts" className:@"MMMContactsViewController" image:nil];
    [viewModel addModuleWithName:@"MMemorandum" className:@"MMMMemorandumViewController" image:nil];
    [viewModel addModuleWithName:@"MMusicPlayer" className:@"MMMMusicPlayerViewController" image:nil];
    [viewModel addModuleWithName:@"MPhone" className:@"MMMPhoneViewController" image:nil];
    [viewModel addModuleWithName:@"MPockerBook" className:@"MMMPocketBookViewController" image:nil];
    [viewModel addModuleWithName:@"MVideoPlayer" className:@"MMMVideoViewController" image:nil];
    [viewModel addModuleWithName:nil className:nil image:nil];
    [viewModel addModuleWithName:nil className:nil image:nil];
    if (block) {
        block(viewModel.moduleArray);
    }
}

- (void)addModuleWithName:(NSString *)name className:(NSString *)className image:(NSString *)image
{
    MMHomeModuleModel *model = MMHomeModuleModel.new;
    model.name = name;
    model.className = className;
    model.image = image;
    [self.moduleArray addObject:model];
}

-(NSMutableArray *)moduleArray
{
    if (!_moduleArray) {
        _moduleArray = [NSMutableArray new];
    }
    return _moduleArray;
}

@end
