//
//  PlayerViewController.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/13.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMPlayerView.h"

@interface PlayerViewController : UIViewController

@property (nonatomic, weak) NMPlayerView *nmPlayerView;
@property (nonatomic, strong) NSArray *videoArray;

@end
