//
//  NMAVPlayerItem.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/12.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMAVPlayerItem.h"

@implementation NMAVPlayerItem

+ (NMAVPlayerItem *)itemWithAsset:(AVURLAsset *)asset startTiem:(double)startTime partNO:(NSInteger)partNO
{
    NMAVPlayerItem *item = [[NMAVPlayerItem alloc] initWithAsset:asset];
    CMTime newDuration = asset.duration;
    BOOL hasValidDuration = CMTIME_IS_NUMERIC(newDuration) && newDuration.value != 0;
    double newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0;
    item.itemDuration = newDurationSeconds;
    item.itemStartTime = startTime;
    item.itemEndTime   = startTime + newDurationSeconds;
    item.itemPartNO = partNO;
    item.loadFinish = NO;
    item.itemLoadTime = 0.0f;
    return item;
}

- (void)setItemLoadTime:(double)itemLoadTime
{
    if (itemLoadTime >0 && itemLoadTime < _itemDuration + 0.1)
    {
        _itemLoadTime = itemLoadTime;

    }
    if (itemLoadTime + 0.1 >= _itemDuration)
    {
        _loadFinish = YES;
    }
}

- (BOOL)timeIsINItem:(double)time
{
    if (time >= self.itemStartTime && time <= self.itemEndTime)
    {
        return YES;
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%.2f %.2f %.2f",self.itemStartTime,self.itemEndTime,self.itemDuration];
}

@end
