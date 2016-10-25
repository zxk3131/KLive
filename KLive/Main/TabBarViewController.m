//
//  TabBarViewController.m
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "TabBarViewController.h"
#import "NavViewController.h"
#import "HotViewController.h"
#import "StartLiveViewController.h"
#import "MineTableViewController.h"

@interface TabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self addChildViewController:[HotViewController new] notmalimageNamed:@"toolbar_home" selectedImage:@"toolbar_home_sel" title:@"热门"];
    
    [self addChildViewController:[[StartLiveViewController alloc] init] notmalimageNamed:@"toolbar_live" selectedImage:nil title:@"直播"];
    
    [self addChildViewController:[[MineTableViewController alloc] init] notmalimageNamed:@"toolbar_me" selectedImage:@"toolbar_me_sel" title:@"个人中心"];
    
}

- (void)addChildViewController:(UIViewController *)childController notmalimageNamed:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title
{
    NavViewController *nav = [[NavViewController alloc] initWithRootViewController:childController];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.title = title;
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : KBasicColor} forState:UIControlStateNormal];
    
    [self addChildViewController:nav];
}

#pragma mark 代理方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController == tabBarController.childViewControllers[1]){
        
        [self presentViewController:[[StartLiveViewController alloc] init] animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

@end
