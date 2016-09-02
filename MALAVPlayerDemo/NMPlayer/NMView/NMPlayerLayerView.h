//
//  NMPlayerLayerView.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/15.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMQueuePlayer.h"

@interface NMPlayerLayerView : UIView

@property (nonatomic, weak) NMQueuePlayer *nm_QueuePlayer;
@property (readonly, weak, nonatomic) AVPlayerLayer *playerLayer;

@end
