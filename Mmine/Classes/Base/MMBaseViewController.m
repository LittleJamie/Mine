//
//  MMBaseViewController.m
//  Mmine
//
//  Created by Jamie on 16/6/1.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMBaseViewController.h"

@implementation MMBaseViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MColorBackground;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
