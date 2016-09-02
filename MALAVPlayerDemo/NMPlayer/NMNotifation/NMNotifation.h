//
//  NMNotifation.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/14.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NMNotifationDelegate <NSObject>

- (void)nm_appDidEnterBackground;

//应用即将进入前台
- (void)nm_appWillEnterForeground;

//MARK: 屏幕旋转相关
- (void)nm_onDeviceOrientationChange:(UIInterfaceOrientation)interfaceOrientation;

@end

@interface NMNotifation : NSObject

@property (nonatomic, weak) id<NMNotifationDelegate> nmNotifationDelegate;

- (NMNotifation *)initWithDelegate:(id<NMNotifationDelegate>)delegate;
- (void)addNotifation;
- (void)removeNotifation;



@end
