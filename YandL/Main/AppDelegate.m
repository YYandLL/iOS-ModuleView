//
//  AppDelegate.m
//  YandL
//
//  Created by YandL on 16/12/14.
//  Copyright © 2016年 YandL. All rights reserved.
//

#import "AppDelegate.h"
#import "TXBYTabBarController.h"
#import "IndexViewController.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) TXBYTabBarController *tab;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设置应用
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    // 设置窗口的根控制器
    [self setupTabbar];
    
    self.window.rootViewController = self.tab;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)setupTabbar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    TXBYTabBarController *tab = [[TXBYTabBarController alloc] init];
    self.tab = tab;
    // Tabbar背景色
    tab.backgroundColor =[UIColor whiteColor];
    // Tabbar标题颜色
    tab.titleColor = TXBYColor(82, 82, 82);
    // 标题选中的颜色
    tab.selectedTitleColor = ESMainColor;
    // 导航栏的颜色
    tab.navigationController.navigationBarBarTintColor = ESMainColor;
    tab.navigationController.barButtonItemColor = [UIColor whiteColor];
    tab.navigationController.barButtonItemFont = [UIFont systemFontOfSize:16];
    tab.navigationController.navigationBarTintColor = [UIColor whiteColor];
    // 导航栏的标题颜色
    tab.navigationController.globalBackgroundColor = ESGlobalBgColor;

    tab.navigationController.navigationBarTitleColor = [UIColor whiteColor];
    
    // 1. 首页
    HomeViewController *home = [[HomeViewController alloc] init];
    home.model_id = @"1";
    [tab addChildViewController:home title:@"全部类型" imageName:@"tabbar_home"];
    
    HomeViewController *home1 = [[HomeViewController alloc] init];
    [tab addChildViewController:home1 title:@"个人中心" imageName:@"tabbar_profile"];
    
    IndexViewController *other = [[IndexViewController alloc] init];
    [tab addChildViewController:other title:@"其它" imageName:@"tabbar_discover"];
    
    
}

@end
