//
//  NMPlayControlView.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/14.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMBottomToolView.h"

@protocol NMPlayControlViewDelegate <NSObject>

//MARK:底部工具条代理相关
/**
 *  控制条开始拖动
 *
 *  @param slider UISlider
 */
- (void)nmSliderValueChange:(UISlider *)slider;

/**
 *  控制条被touch了
 *
 *  @param slider UISlider
 */
- (void)nmSliderTouchBegan:(UISlider *)slider;

/**
 *  控制条touch end
 *
 *  @param slider UISlider
 */
- (void)nmSliderTouchEnd:(UISlider *)slider;

/**
 *  全屏按钮被点击
 */
- (void)nmfullScreenBtnClick:(UIButton *)sender;

/**
 *  播放/暂停  按钮被点击
 *
 */
- (void)nmPlayOrPauseBtnClick;

//MARK: 顶部工具条代理相关
/**
 *  更新顶部view及其subView的frame
 *
 *  @param frame 顶部工具条当前frame
 */
- (void)nmupdateTopViewFrame:(CGRect)frame;

@end

@interface NMPlayControlView : UIView


@property (nonatomic, weak) id<NMPlayControlViewDelegate> nm_playControlDelegate;
@property (nonatomic, assign) BOOL isHandleTouchEvent;//是否响应触摸事件


- (instancetype)initWithTopToolView:(UIView *)topToolView delegate:(id<NMPlayControlViewDelegate>)delegate;

//MARK: 底部工具条相关方法
- (void)setCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime;
- (void)setPlayProgress:(CGFloat)playProgress;
- (void)setLoadProgress:(CGFloat)loadProgress;
//更改全屏按钮的选中状态(切换图标)
- (void)changeToFullScrren:(BOOL)isFullScreen;

//MARK: 其它view相关
- (void)setPlayOrPauseBtnSelectState:(BOOL)select;

- (void)showOrHiddenPlayControlView;
- (void)setToolViewHidden:(NSNumber *)isHidden;
- (void)hiddenToolViewWithTime:(double)time;
- (void)showToolViewWithHoldTime:(double)time;


- (void)addTopView:(UIView *)topView;

- (void)resetView;
@end
