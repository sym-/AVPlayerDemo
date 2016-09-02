//
//  NMNotifation.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/14.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMNotifation.h"

@interface NMNotifation()

@property (nonatomic, assign) BOOL isRegisterNotifation;

@end

@implementation NMNotifation

- (NMNotifation *)initWithDelegate:(id<NMNotifationDelegate>)delegate
{
    if (self = [super init])
    {
        _nmNotifationDelegate = delegate;
    }
    return self;
}

- (void)addNotifation
{
    self.isRegisterNotifation = YES;
    //设备旋转
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)removeNotifation
{
    if (self.isRegisterNotifation)
    {
        //设备旋转
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        // app退到后台
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        // app进入前台
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        self.isRegisterNotifation = NO;
    }
}

//应用进入后台
- (void)appDidEnterBackground
{
    if ([self.nmNotifationDelegate respondsToSelector:@selector(nm_appDidEnterBackground)])
    {
        [self.nmNotifationDelegate nm_appDidEnterBackground];
    }
}

//应用即将进入前台
- (void)appWillEnterForeground
{
     if ([self.nmNotifationDelegate respondsToSelector:@selector(nm_appWillEnterForeground)])
     {
         [self.nmNotifationDelegate nm_appWillEnterForeground];
     }
}

//MARK: 屏幕旋转相关
- (void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if ([self.nmNotifationDelegate respondsToSelector:@selector(nm_onDeviceOrientationChange:)])
    {
        [self.nmNotifationDelegate nm_onDeviceOrientationChange:interfaceOrientation];
    }
}


@end
