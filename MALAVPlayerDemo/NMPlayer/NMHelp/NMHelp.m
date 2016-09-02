//
//  NMHelp.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/15.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMHelp.h"

@implementation NMHelp

//MARK: 屏幕方向
/**
 *  改变屏幕方向
 *
 *  @param interfaceOrientation UIInterfaceOrientation
 */
+ (void)changeScreenOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&interfaceOrientation atIndex:2];
        [invocation invoke];
    }
}

/**
 *  是否为横屏
 *
 *  @return BOOL
 */
+ (BOOL)isLandscape
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        return YES;
    }
    return NO;
}

//MARK: 时间转换
+ (NSString *)createTimeString:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if (hours == 0) {
        return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


@end
