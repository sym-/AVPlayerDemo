//
//  NMHelp.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/15.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMHelp : NSObject

//MARK: 屏幕方向
+ (BOOL)isLandscape;
+ (void)changeScreenOrientation:(UIInterfaceOrientation)interfaceOrientation;

//MARK: 时间转换
+ (NSString *)createTimeString:(int)time;

@end
