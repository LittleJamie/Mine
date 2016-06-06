//
//  MMAppDelegate.m
//  Mmine
//
//  Created by Jamie on 16/6/1.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import "MMAppDelegate.h"
#import "MMFirstTabBarController.h"
#import "MMFirstNavigationController.h"
#import "MMHomeViewController.h"
#import "MMMeViewController.h"
#import "MMOneViewController.h"
#import "DonewsAnalytics.h"
@interface MMAppDelegate ()<UITabBarControllerDelegate,UINavigationControllerDelegate>

@end
@implementation MMAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    self.window.backgroundColor = [UIColor whiteColor];
    [self createRootViewController];
    
    [self.window makeKeyAndVisible];
    
    [DonewsAnalytics registDonewsSDK:@"test" channelID:nil];
    return YES;
}
- (void)createRootViewController
{
    MMFirstTabBarController *tabBarController = [MMFirstTabBarController new];
    tabBarController.delegate = self;
    tabBarController.selectedIndex = 0;
    tabBarController.viewControllers = [self createTabBarRootViewControllers];
    self.window.rootViewController = tabBarController;
}

- (NSArray *)createTabBarRootViewControllers
{
    MMHomeViewController *homeVC = [MMHomeViewController new];
    MMFirstNavigationController *homeNav = [[MMFirstNavigationController alloc] initWithRootViewController:homeVC];
    homeNav.delegate = self;
    homeNav.title = @"首页";
    homeNav.tabBarItem.title = @"首页";
    
    MMOneViewController *oneVC = [MMOneViewController new];
    MMFirstNavigationController *oneNav = [[MMFirstNavigationController alloc] initWithRootViewController:oneVC];
    oneNav.delegate = self;
    oneNav.title = @"工具";
    oneNav.tabBarItem.title = @"工具";
    
    
    MMMeViewController *meVC = [MMMeViewController new];
    MMFirstNavigationController *meNav = [[MMFirstNavigationController alloc] initWithRootViewController:meVC];
    meNav.delegate = self;
    meNav.title = @"ME";
    meNav.tabBarItem.title = @"ME";
    
    return @[homeNav,oneNav,meNav];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
