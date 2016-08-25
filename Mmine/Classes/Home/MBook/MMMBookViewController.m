//
//  MMMBookViewController.m
//  Mmine
//
//  Created by Jamie on 16/6/2.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMMBookViewController.h"
#import "UIBarButtonItem+JAExt.h"
#import "MMMBookListView.h"
@implementation MMMBookViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self createNavigation];
    [self createContent];
}

- (void)createNavigation
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_back_withtext" HighImageNmae:@"navigationbar_back_withtext_highlighted" Target:self Action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_back_withtext" HighImageNmae:@"navigationbar_back_withtext_highlighted" Target:self Action:@selector(back)];
    
}
- (void)createContent
{
    [self.view addSubview:[[MMMBookListView alloc] init]];
}

#pragma mark - Event Processing
//Navi左侧按钮点击事件
- (void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
@end
