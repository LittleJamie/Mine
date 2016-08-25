//
//  MMMBookNavigationController.m
//  Mmine
//
//  Created by Jamie on 16/8/24.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMMBookNavigationController.h"
#import "MMMBookViewController.h"

@interface MMMBookNavigationController ()

@property (nonatomic, strong) MMMBookViewController *bookViewController;
@end
@implementation MMMBookNavigationController

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.navigationController.title = title;
}
-(instancetype)init
{
    self = [super initWithRootViewController:self.bookViewController];
    if (self) {
//        self.navigationItem = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.8, 44)];
    }
    return self;
    
}
- (MMMBookViewController *)bookViewController
{
    if (!_bookViewController) {
        _bookViewController = [[MMMBookViewController alloc] init];
    }
    return _bookViewController;
}
@end
