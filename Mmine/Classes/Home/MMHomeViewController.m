//
//  MMHomeViewController.m
//  Mmine
//
//  Created by Jamie on 16/6/1.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMHomeViewController.h"
#import "MMHomeModuleModel.h"

@interface MMHomeViewController ()
@property (nonatomic, strong) NSMutableArray *moduleArray;
@end
@implementation MMHomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)addModuleWithText:(NSString *)text className:(NSString *)className image:(NSString *)image
{
//    MMHomeModuleModel *model
//    [self.moduleArray addObject:model];
}
-(NSMutableArray *)moduleArray
{
    if (!_moduleArray) {
        _moduleArray = [NSMutableArray new];
    }
    return _moduleArray;
}
@end
