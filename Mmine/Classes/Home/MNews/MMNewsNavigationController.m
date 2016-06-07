//
//  MMNewsNavigationController.m
//  Mmine
//
//  Created by Jamie on 16/6/7.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMNewsNavigationController.h"

#import "MMNewsViewController.h"

@interface MMNewsNavigationController ()
@property (nonatomic, strong) MMNewsViewController *newsViewController;
@end
@implementation MMNewsNavigationController
-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.newsViewController.title = title;
    
}
- (instancetype)init
{
   
    self = [super initWithRootViewController:self.newsViewController];
    if (self) {

       
    }
    return self;
}
-(MMNewsViewController *)newsViewController
{
    if (!_newsViewController) {
        _newsViewController = [[MMNewsViewController alloc] init];
    }
    return _newsViewController;
}
@end
