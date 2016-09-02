//
//  NMBottomToolView.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/13.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMPlayerSlider.h"

@protocol NMBottomToolViewDelegate <NSObject>



@end

@interface NMBottomToolView : UIView

@property (nonatomic, weak) id <NMBottomToolViewDelegate> nmbottomToolViewDelegate;
/** 播放进度条 */
@property (nonatomic, strong) NMPlayerSlider *nmSlider;

/** 当前播放时间label */
@property (nonatomic, strong) UILabel *currentTiemLB;

/** 视频总时长label */
@property (nonatomic, strong) UILabel *totalTimeLB;

/** 全屏按钮 */
@property (nonatomic, strong) UIButton *fullScreenBtn;


- (void)setCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime;
- (void)setPlayProgress:(CGFloat)playProgress;
- (void)setLoadProgress:(CGFloat)loadProgress;
- (void)changeToFullScrren:(BOOL)isFullScreen;

@end
