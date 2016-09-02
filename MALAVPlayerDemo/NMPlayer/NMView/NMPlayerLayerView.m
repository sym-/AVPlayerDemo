//
//  NMPlayerLayerView.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/15.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMPlayerLayerView.h"

@implementation NMPlayerLayerView

- (NMQueuePlayer *)nm_QueuePlayer
{
    return (NMQueuePlayer *)self.playerLayer.player;
}

- (void)setNm_QueuePlayer:(NMQueuePlayer *)nm_QueuePlayer
{
    self.playerLayer.player = nm_QueuePlayer;
}

- (AVPlayerLayer *)playerLayer
{
    return (AVPlayerLayer *)self.layer;
}

// override UIView
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

@end
