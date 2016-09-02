//
//  NMTabBarController.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/17.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMTabBarController.h"
#import "NMVideoListViewController.h"

@interface NMTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, weak) UIViewController *lastSelectVC;

@end

@implementation NMTabBarController

- (instancetype)init
{
    if (self = [super init])
    {
        [self addChildVC];
    }
    return self;
}

- (void)addChildVC
{
    NMVideoListViewController *listVC = [[NMVideoListViewController alloc] init];
    listVC.title = @"列表";
    UINavigationController *listVideoVCNavi = [[UINavigationController alloc] initWithRootViewController:listVC];
    
    UIViewController *otherVC = [[UIViewController alloc] init];
    otherVC.title = @"其它";
    UINavigationController *otherNavi = [[UINavigationController alloc] initWithRootViewController:otherVC];
    self.viewControllers = @[listVideoVCNavi,otherNavi];
    self.selectedIndex = 0;
    self.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([self.lastSelectVC isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navi = (UINavigationController *)self.lastSelectVC;
        if ([[navi topViewController] respondsToSelector:@selector(nmListVCstopPlay)]) {
            
            [(NMVideoListViewController *)[navi topViewController] nmListVCstopPlay];
        }
    }
    self.lastSelectVC = viewController;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
