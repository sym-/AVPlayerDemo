//
//  NMPlayerView.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/12.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMPlayerView.h"
#import "NMNotifation.h"
#import "NMPlayerLoadView.h"
#import "NMGestureView.h"

//UI
#define KSelf_BGColor     [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]//self背景色
#define KToolViewHoldTime          5              //工具view保留时间

#define KNMLoadFailedText     @"加载失败，点击重试!"
#define KNMLoadingText        @"加载中..."

@interface NMPlayerView()<NMQueuePlayerDelegate, NMPlayControlViewDelegate, NMNotifationDelegate, NMPlayerLoadViewDelegate, NMGestureViewDelegate>


/** 半屏状态下播放器的frame */
@property (nonatomic, assign) CGRect halfScreenFrame;

/** 是否正在拖动slider */
@property (nonatomic, assign) BOOL isDragSlider;

@property (nonatomic, strong) NMNotifation *nm_noti;//通知
@property (nonatomic, weak)   NMQueuePlayer *nm_QueuePlayer;//AVPlayer
@property (nonatomic, strong) NMPlayerLayerView *nm_playerLayerView;//AVPlayerLayer
@property (nonatomic, strong) NMPlayerLoadView *nm_LoadingView;
@property (nonatomic, strong) NMPlayControlView *nm_playControlView;
@property (nonatomic, strong) NMGestureView *nm_gestureView;//手势

@property (nonatomic, strong) NSArray *currentVideoUrlArray;//保存当前播放的urlArray

@end

@implementation NMPlayerView

//MARK: get set
- (NMPlayerLayerView *)nm_playerLayerView
{
    if (_nm_playerLayerView == nil)
    {
        _nm_playerLayerView = [[NMPlayerLayerView alloc] init];
    }
    return _nm_playerLayerView;
}

- (NMPlayerLoadView *)nm_LoadingView
{
    if (_nm_LoadingView == nil)
    {
        _nm_LoadingView = [[NMPlayerLoadView alloc] init];
        _nm_LoadingView.nm_loadingDelegate = self;
    }
    return _nm_LoadingView;
}

- (NMGestureView *)nm_gestureView
{
    if (_nm_gestureView == nil)
    {
        _nm_gestureView = [[NMGestureView alloc] init];
        _nm_gestureView.nm_gesDelegate = self;
    }
    return _nm_gestureView;
}

- (NMNotifation *)nm_noti
{
    if (_nm_noti == nil)
    {
        _nm_noti = [[NMNotifation alloc] initWithDelegate:self];
    }
    return _nm_noti;
}

- (void)setNm_QueuePlayer:(NMQueuePlayer *)nm_QueuePlayer
{
    _nm_QueuePlayer = nm_QueuePlayer;
    _nm_QueuePlayer.nm_delegate = self;
    _nm_playerLayerView.playerLayer.player = nm_QueuePlayer;
}

//MARK: 初始化相关
- (NMPlayerView *)initWithFrame:(CGRect)frame topView:(UIView *)topView selfSuperView:(UIView *)selfSuperView delegate:(id<NMPlayerViewDelegate>)delegate
{
    if (self = [self initWithFrame:frame])
    {
        self.halfScreenFrame = frame;
        self.nm_playControlView = [[NMPlayControlView alloc] initWithTopToolView:topView delegate:self];
        self.selfSuperView = selfSuperView;
        self.nmPlayerViewDelegate = delegate;
        [self initPlayerView];
    }
    return self;
}

- (void)setTopView:(UIView *)topView playerDeleagte:(id<NMPlayerViewDelegate>)delegate
{
    self.nmPlayerViewDelegate = delegate;
    [self.nm_playControlView addTopView:topView];
}

- (void)initPlayerView
{
    self.isUpdateScreen = YES;
    //创建并添加子view
    [self creatSubView];
}

- (void)creatSubView
{
    self.backgroundColor = KSelf_BGColor;
    [self addSubview:self.nm_playerLayerView];
    [self addSubview:self.nm_gestureView];
    [self addSubview:self.nm_playControlView];
    [self addSubview:self.nm_LoadingView];
}

//MARK: 调整subView的frame
- (void)layoutSubviews
{
   if (!self.isUpdateScreen) return;
    
    [super layoutSubviews];
    self.nm_playerLayerView.frame = self.bounds;
    self.nm_playControlView.frame = self.bounds;
    self.nm_LoadingView.frame = self.bounds;
    self.nm_gestureView.frame = self.bounds;
}

//MARK: NMNotifationDelegate 通知代理方法
//应用进入后台
- (void)nm_appDidEnterBackground
{
    [self pauseVideo];
}

//应用即将进入前台
- (void)nm_appWillEnterForeground
{

}

//屏幕方向发生改变
- (void)nm_onDeviceOrientationChange:(UIInterfaceOrientation)interfaceOrientation
{
    if (!self.isUpdateScreen) return;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        [self setHalfScreen];
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        if ([self.nmPlayerViewDelegate respondsToSelector:@selector(getHalfScreenFrame)])
        {
            self.halfScreenFrame = [self.nmPlayerViewDelegate getHalfScreenFrame];
        }
        CGFloat rotaion = M_PI_2;
        if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        {
            rotaion = -M_PI_2;
        }
        [self setFullScreenWithRotaion:rotaion];
    }
}

//MARK: NMPlayControlViewDelegate 播放控制view代理
- (void)nmSliderValueChange:(UISlider *)slider
{
    self.isDragSlider = YES;
}

- (void)nmSliderTouchBegan:(UISlider *)slider
{
    self.isDragSlider = YES;
}

- (void)nmSliderTouchEnd:(UISlider *)slider
{
    __weak NMPlayerView *weakSelf = self;
    [self.nm_QueuePlayer seekWithProgress:slider.value withcompletion:^{
        
        weakSelf.isDragSlider = NO;
        [weakSelf.nm_playControlView hiddenToolViewWithTime:KToolViewHoldTime];
    }];
}

- (void)nmfullScreenBtnClick:(UIButton *)sender
{
    if (!self.isUpdateScreen) return;
    
    if (self.isFullScreen)
    {
        [NMHelp changeScreenOrientation:UIInterfaceOrientationPortrait];
    }
    else
    {
        [NMHelp changeScreenOrientation:UIInterfaceOrientationLandscapeRight];
    }
}

- (void)nmPlayOrPauseBtnClick
{
    if (self.nm_QueuePlayer.isPlaying)
    {
        [self pauseVideo];
    }
    else
    {
        [self playVideo];
    }
}

- (void)nmupdateTopViewFrame:(CGRect)frame
{
    if ([self.nmPlayerViewDelegate respondsToSelector:@selector(updateTopViewFrame:)])
    {
        [self.nmPlayerViewDelegate updateTopViewFrame:frame];
    }
}

//MARK: NMPlayerLoadViewDelegate 加载view代理
- (void)reloadVideo
{
    if (self.currentVideoUrlArray)
    {
        [self playWithVideoUrlArray:self.currentVideoUrlArray];
    }
}

//MARK: NMQueuePlayerDelegate  AVQueuePlayer代理
- (void)nowPlayTime:(double)nowTime totalTime:(double)totalTime playProgress:(CGFloat)playProgress
{
    NSString *nowTimeStr = [NMHelp createTimeString:nowTime];
    NSString *totalTimeStr = [NMHelp createTimeString:totalTime];
    [self.nm_playControlView setCurrentTime:nowTimeStr totalTime:totalTimeStr];
    [self.nm_gestureView setCurrentTime:nowTime totalTime:totalTime];
    if (!self.isDragSlider)
    {
        [self.nm_playControlView setPlayProgress:playProgress];
    }
    if (self.nm_QueuePlayer.isBlocked)
    {
        //NSLog(@"显示卡了 但是正在播放");
    }
}

- (void)playStatusChange:(BOOL)isPlaying
{
   
}

- (void)updateLoadProgress:(CGFloat)newProgress
{
    if (newProgress >= 0.0f && newProgress <= 1.01f)
    {
        [self.nm_playControlView setLoadProgress:newProgress];
    }
}

- (void)playEnd
{
    __weak NMPlayerView *ws = self;
    [self.nm_QueuePlayer seekWithProgress:0.0 withcompletion:^{
    
        [ws pauseVideo];
    }];
}

- (void)nmPlayFailed
{
    [self.nm_LoadingView showLoadErrorText:KNMLoadingText];
}

- (void)nmplayBlocked
{
    if (self.nm_QueuePlayer.isPlaying)
    {
        [self.nm_LoadingView showOnlyLoadingView];
    }
}

- (void)nmBlockEnd
{
    [self.nm_LoadingView hiddenLodingView];
}

//MARK: 手势
//单击显示/隐藏工具条
- (void)nm_singleClick
{
    [self.nm_playControlView showOrHiddenPlayControlView];
}

//双击  暂停/播放
- (void)nm_doubleClick
{
    if(self.nm_QueuePlayer.isPlaying)
    {
        [self pauseVideo];
    }
    else
    {
        [self playVideo];
    }
}

//滑动seek
- (void)nm_seekWithProgress:(CGFloat)progress
{
    [self.nm_QueuePlayer seekWithProgress:progress withcompletion:nil];
}

//MARK: 外部接口
- (void)playVideo
{
     [self.nm_playControlView setPlayOrPauseBtnSelectState:NO];
    if (self.nm_QueuePlayer.isPlaying == NO)
    {
        [self.nm_QueuePlayer play];
        if (self.nm_QueuePlayer.isBlocked)//如果在卡顿状态显示加载view
        {
            [self nmplayBlocked];
        }
    }
}

- (void)pauseVideo
{
    [self.nm_playControlView setPlayOrPauseBtnSelectState:YES];
    if (self.nm_QueuePlayer.isPlaying == YES)
    {
        [self.nm_QueuePlayer pause];
    }
}

//切换到半屏
- (void)changeToHalfScreen
{
    [NMHelp changeScreenOrientation:UIInterfaceOrientationPortrait];
}

//播放视频
- (void)playWithVideoUrlArray:(NSArray<NSString *> *)videoUrlArray
{
    if (self.nm_QueuePlayer)
    {
        [self.nm_QueuePlayer releaseResource];
        [self.nm_playControlView resetView];
    }
    self.currentVideoUrlArray = videoUrlArray;
    if (videoUrlArray)
    {
        NMQueuePlayer *nmPlayer = [[NMQueuePlayer alloc] init];
        self.nm_QueuePlayer = nmPlayer;
        [self.nm_LoadingView showOnlyLoadingView];
        __weak NMPlayerView *ws = self;
        [self.nm_QueuePlayer preparePlayWithVideoUrlArray:videoUrlArray finishBlcok:^(BOOL loadSuccess){
            
            if (!loadSuccess)
            {
                [ws.nm_LoadingView showLoadErrorText:KNMLoadFailedText];
            }
            if ([ws.nmPlayerViewDelegate respondsToSelector:@selector(loadVideoFinish:)])
            {
                [ws.nmPlayerViewDelegate loadVideoFinish:loadSuccess];
            }
            [ws.nm_noti addNotifation];
        }];
        [self.nm_playControlView showToolViewWithHoldTime:KToolViewHoldTime];
    }
}

- (void)replaceSuperView:(UIView *)selfSuperView
{
    if (self.superview)
    {
        [self removeFromSuperview];
    }
    if (selfSuperView)
    {
        self.selfSuperView = selfSuperView;
        [selfSuperView addSubview:self];
    }
}

- (void)playWithVideoUrlArray:(NSArray<NSString *> *)videoUrlArray selfSuperView:(UIView *)selfSuperView
{
    [self replaceSuperView:selfSuperView];
    [self playWithVideoUrlArray:videoUrlArray];
}

//MARK: 私有方法
//FIXME: 需要重写...
- (void)setFullScreenWithRotaion:(float)rotaion
{
    if (self.selfSuperView == nil)
    {
        return;
    }
    CGSize newSize = CGSizeMake(MAX(NMScreenWidth, NMScreenHeight), MIN(NMScreenWidth, NMScreenHeight));
    _isFullScreen = YES;
    [self.nm_playControlView changeToFullScrren:YES];
    [UIView animateWithDuration:0.5f animations:^{
        
        self.transform = CGAffineTransformMakeRotation(rotaion);
        
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            UIWindow *kewWionds = [UIApplication sharedApplication].keyWindow;
            kewWionds.windowLevel = UIWindowLevelStatusBar + 1;
        }
    }];
    self.frame = CGRectMake(0, 0, newSize.height, newSize.width);
    [self removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)setHalfScreen
{
    if (self.selfSuperView == nil)
    {
        return;
    }
    _isFullScreen = NO;
    [self.nm_playControlView changeToFullScrren:NO];
    UIWindow *kewWionds = [UIApplication sharedApplication].keyWindow;
    kewWionds.windowLevel = UIWindowLevelNormal;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            [self removeFromSuperview];
            self.origin = CGPointZero;
            [self.selfSuperView addSubview:self];
        }
    }];
    self.frame = self.halfScreenFrame;
}

//MARK: dealloc
- (void)releaseSelf
{
    if (self.nm_QueuePlayer)
    {
        [self.nm_QueuePlayer releaseResource];
        self.nm_QueuePlayer = nil;
    }
    [self.nm_noti removeNotifation];
}

//释放player(AVPlayer + notifation)
- (void)removePlayer
{
    [self replaceSuperView:nil];
    if (self.nm_QueuePlayer)
    {
        [self.nm_QueuePlayer releaseResource];
        self.nm_playerLayerView.nm_QueuePlayer = nil;
        self.nm_QueuePlayer = nil;
        [self.nm_playControlView resetView];
    }
    [self.nm_noti removeNotifation];
}

- (void)dealloc
{
    NSLog(@"NMPlayerView dealloc");
}

@end
