//
//  NMPlayerView.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/12.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMQueuePlayer.h"
#import "NMPlayControlView.h"
#import "NMPlayerLayerView.h"

@protocol NMPlayerViewDelegate <NSObject>

@required
/**
 *  视频加载完毕调用代理方法
 *
 *  @param isLoadSuccess 视频是否加载成功
 */
- (void)loadVideoFinish:(BOOL)isLoadSuccess;

/**
 *  获取半屏时playview的frame
 *
 *  @return CGRect
 */
- (CGRect)getHalfScreenFrame;

@optional
/**
 *  更新topview的frame
 */
- (void)updateTopViewFrame:(CGRect)frame;

@end

@interface NMPlayerView : UIView

/** 是否为全屏 */
@property (nonatomic, assign, readonly) BOOL isFullScreen;

/** 当屏幕方向发生改变的时候是否更新屏幕 */
@property (nonatomic, assign) BOOL isUpdateScreen;

/** 是否正在播放 */
//@property (nonatomic, assign, readonly) BOOL isPlaying;

/** 记录父视图 */
@property (nonatomic, weak) UIView *selfSuperView;

@property (nonatomic, weak) id<NMPlayerViewDelegate> nmPlayerViewDelegate;

- (NMPlayerView *)initWithFrame:(CGRect)frame topView:(UIView *)topView selfSuperView:(UIView *)selfSuperView delegate:(id<NMPlayerViewDelegate>)delegate;

- (void)setTopView:(UIView *)topView playerDeleagte:(id<NMPlayerViewDelegate>) delegate;

#pragma mark - 外部接口
- (void)playVideo;
- (void)pauseVideo;
- (void)changeToHalfScreen;

/**
 *  播放视频
 *
 *  @param videoUrlArray 视频源地址数组
 */
- (void)playWithVideoUrlArray:(NSArray<NSString *> *)videoUrlArray;

/**
 *  释放资源（在使用NMPlayerView的vc的dealloc方法中调用）
 */
- (void)releaseSelf;

- (void)playWithVideoUrlArray:(NSArray<NSString *> *)videoUrlArray selfSuperView:(UIView *)selfSuperView;

- (void)replaceSuperView:(UIView *)selfSuperView;

- (void)removePlayer;

@end
