//
//  NMGestureView.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/15.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NMGestureViewDelegate <NSObject>

- (void)nm_singleClick;
- (void)nm_doubleClick;
- (void)nm_seekWithProgress:(CGFloat)progress;

@end

@interface NMGestureView : UIView

@property (nonatomic, weak) id<NMGestureViewDelegate> nm_gesDelegate;

- (void)setCurrentTime:(double)currentTime totalTime:(double)totalTime;


@end
