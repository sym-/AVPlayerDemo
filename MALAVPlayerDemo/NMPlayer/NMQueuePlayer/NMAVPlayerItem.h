//
//  NMAVPlayerItem.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/12.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NMAVPlayerItem : AVPlayerItem

@property (nonatomic, assign) double itemStartTime;
@property (nonatomic, assign) double itemEndTime;
@property (nonatomic, assign) double itemDuration;
@property (nonatomic, assign) NSInteger itemPartNO;
@property (nonatomic, assign) double itemLoadTime;
@property (nonatomic, assign) BOOL loadFinish;

+ (NMAVPlayerItem *)itemWithAsset:(AVURLAsset *)asset startTiem:(double)startTime partNO:(NSInteger)partNO;

- (BOOL)timeIsINItem:(double)time;

@end
