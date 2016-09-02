//
//  NMQueuePlayer.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/12.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMAVPlayerItem.h"
#import "NMLoadVideoModel.h"

@protocol NMQueuePlayerDelegate <NSObject>

/**
 *  播放时间代理
 *
 *  @param nowTimeStr   当前时间
 *  @param totalTimeStr 总时长
 *  @param playProgress 播放进度
 */
- (void)nowPlayTime:(double)nowTime totalTime:(double)totalTime playProgress:(CGFloat)playProgress;

/**
 *  播放状态改变
 *
 *  @param isPlaying 是否正在播放
 */
- (void)playStatusChange:(BOOL)isPlaying;

/**
 *  更新加载进度
 *
 *  @param newProgress 新的进度
 */
- (void)updateLoadProgress:(CGFloat)newProgress;

/**
 *  播放完成
 */
- (void)playEnd;

/**
 *  播放失败
 */
- (void)nmPlayFailed;

/**
 *  播放卡顿了
 */
- (void)nmplayBlocked;

/**
 *  卡顿结束
 */
- (void)nmBlockEnd;

@end

@interface NMQueuePlayer : AVQueuePlayer

@property (nonatomic, strong) NMLoadVideoModel *model;
@property (nonatomic, weak) id<NMQueuePlayerDelegate> nm_delegate;
/**
 *  视频是否是卡顿状态
 */
@property (nonatomic, assign, readonly) BOOL isBlocked;

/**
 *  AVPlayer是否是在播放状态
 */
@property (nonatomic, assign, readonly) BOOL isPlaying;

/**
 *  加载视频资源
 *
 *  @param videoUrlArray 视频地址数组
 *  @param finishBlock   回调block
 */
- (void)preparePlayWithVideoUrlArray:(NSArray *)videoUrlArray finishBlcok:(void(^)(BOOL))finishBlock;


/**
 *  释放资源
 */
- (void)releaseResource;

#pragma mark - 播放控制

- (void)seekWithProgress:(CGFloat)progress withcompletion:(void(^)(void))completion;

@end
