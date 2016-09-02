//
//  NMPlayControlView.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/14.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMPlayControlView.h"

#define KPlayOrPauseBtn_WH       50                //播放或者暂停按钮尺寸
#define KTooBar_BGColor   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]//工具条背景色
#define KToolBar_Height          40                   //工具条高度

//基本常量
#define KNMAnimationTime         0.5              //动画duration

#define KToolViewHoldTime          5              //工具view保留时间


@interface NMPlayControlView()

@property (nonatomic, strong) NMBottomToolView *bottomToolView;

/** 顶部工具条 */
@property (nonatomic, weak) UIView *topToolView;

//-------  其它view  -------
@property (nonatomic, strong) UIButton *playOrPauseBtn;

@end

@implementation NMPlayControlView


//MARK: ----  get  ----
//-------  底部工具条  -------
- (NMBottomToolView *)bottomToolView
{
    if (_bottomToolView == nil)
    {
        _bottomToolView = [[NMBottomToolView alloc] init];
        _bottomToolView.backgroundColor = KTooBar_BGColor;
        _bottomToolView.height = KToolBar_Height;
    }
    return _bottomToolView;
}

//-------  其它view  -------
- (UIButton *)playOrPauseBtn
{
    if (_playOrPauseBtn == nil)
    {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playOrPauseBtn.height = KPlayOrPauseBtn_WH;
        _playOrPauseBtn.width = KPlayOrPauseBtn_WH;
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"list_btn_pause"] forState:(UIControlStateNormal)];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"list_btn_play"] forState:(UIControlStateSelected)];
        [_playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return  _playOrPauseBtn;
}

//MARK: init
- (instancetype)initWithTopToolView:(UIView *)topToolView delegate:(id<NMPlayControlViewDelegate>)delegate
{
    if (self = [super init])
    {
        _topToolView = topToolView;
        _isHandleTouchEvent = YES;
        _nm_playControlDelegate = delegate;
        [self setUpView];
    }
    return self;
}

- (void)addTopView:(UIView *)topView
{
    if (topView)
    {
        self.topToolView = topView;
        [self addSubview:self.topToolView];
        self.topToolView.backgroundColor = KTooBar_BGColor;
    }
}

- (void)setUpView
{
    self.backgroundColor = [UIColor clearColor];
    [self addTopView:self.topToolView];
    [self addSubview:self.playOrPauseBtn];
    [self setUpBottomToolView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //--------- 底部控制条 -----------
    //底部控制条
    self.bottomToolView.width = self.width;
    self.bottomToolView.bottom = self.height;
    
    //----------  顶部工具条   ----------
    if (self.topToolView)
    {
        self.topToolView.width = self.width;
        self.topToolView.height = KToolBar_Height;
        self.topToolView.origin = CGPointZero;
        if([self.nm_playControlDelegate respondsToSelector:@selector(nmupdateTopViewFrame:)])
        {
            [self.nm_playControlDelegate nmupdateTopViewFrame:self.topToolView.frame];
        }
    }
  
    //----------  其它view   ----------
    //播放或者暂停按钮
    self.playOrPauseBtn.center = CGPointMake(self.width / 2, self.height / 2);
}

//MARK: bottomView
- (void)setUpBottomToolView
{
    [self.bottomToolView.nmSlider.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.bottomToolView.nmSlider.slider addTarget:self action:@selector(sliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.bottomToolView.nmSlider.slider addTarget:self action:@selector(sliderTouchEnd:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [self.bottomToolView.fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.bottomToolView];
}

/**
 *  控制条开始拖动
 *
 *  @param slider UISlider
 */
- (void)sliderValueChange:(UISlider *)slider
{
    if ([self.nm_playControlDelegate respondsToSelector:@selector(nmSliderValueChange:)])
    {
        [self.nm_playControlDelegate nmSliderValueChange:slider];
    }
}

/**
 *  控制条被touch了
 *
 *  @param slider UISlider
 */
- (void)sliderTouchBegan:(UISlider *)slider
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setToolViewHidden:) object:[NSNumber numberWithBool:YES]];
    if ([self.nm_playControlDelegate respondsToSelector:@selector(nmSliderTouchBegan:)])
    {
        [self.nm_playControlDelegate nmSliderTouchBegan:slider];
    }
}

/**
 *  控制条touch end
 *
 *  @param slider UISlider
 */
- (void)sliderTouchEnd:(UISlider *)slider
{
    if ([self.nm_playControlDelegate respondsToSelector:@selector(nmSliderTouchEnd:)])
    {
        [self.nm_playControlDelegate nmSliderTouchEnd:slider];
    }
}

/**
 *  全屏按钮点击了
 */
- (void)fullScreenBtnClick:(UIButton *)sender
{
    if ([self.nm_playControlDelegate respondsToSelector:@selector(nmfullScreenBtnClick:)])
    {
        [self.nm_playControlDelegate nmfullScreenBtnClick:sender];
    }
}

- (void)changeToFullScrren:(BOOL)isFullScreen
{
    [self.bottomToolView changeToFullScrren:isFullScreen];
}

- (void)setCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime
{
    [self.bottomToolView setCurrentTime:currentTime totalTime:totalTime];
}

- (void)setPlayProgress:(CGFloat)playProgress
{
    [self.bottomToolView setPlayProgress:playProgress];
}

- (void)setLoadProgress:(CGFloat)loadProgress
{
    [self.bottomToolView setLoadProgress:loadProgress];
}

//MARK: 其它view
- (void)playOrPauseBtnClick:(UIButton *)sender
{
    if ([self.nm_playControlDelegate respondsToSelector:@selector(nmPlayOrPauseBtnClick)])
    {
        [self.nm_playControlDelegate nmPlayOrPauseBtnClick];
    }
}

- (void)setPlayOrPauseBtnSelectState:(BOOL)select
{
    self.playOrPauseBtn.selected = select;
}

//显示/隐藏toolView
- (void)showOrHiddenPlayControlView
{
    if (self.alpha <= 0.1f)
    {
        [self setToolViewHidden:[NSNumber numberWithBool:NO]];
        [self hiddenToolViewWithTime:KToolViewHoldTime];
    }
    else
    {
        [self setToolViewHidden:[NSNumber numberWithBool:YES]];
    }
}

//MARK: help
- (void)setToolViewHidden:(NSNumber *)isHidden
{
    BOOL toolViewIsHidden = (self.alpha <= 0.1f);
    if (toolViewIsHidden == isHidden.boolValue)
    {
        return;
    }
    CGFloat alpha = 1.0f;
    if (isHidden.boolValue)
    {
        alpha = 0.0f;
    }
    [UIView animateWithDuration:KNMAnimationTime animations:^{
        
        self.alpha = alpha;
    }];
}

- (void)hiddenToolViewWithTime:(double)time
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setToolViewHidden:) object:[NSNumber numberWithBool:YES]];
    [self performSelector:@selector(setToolViewHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:time];
}

- (void)showToolViewWithHoldTime:(double)time
{
    [self setToolViewHidden:[NSNumber numberWithBool:NO]];
    [self hiddenToolViewWithTime:time];
}

/**
 *  重置view里的数据
 */
- (void)resetView
{
    [self setCurrentTime:@"00:00" totalTime:@"00:00"];
    [self setLoadProgress:0.0];
    [self setPlayProgress:0.0];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL isTouchTopToolView = CGRectContainsPoint(self.topToolView.frame, point);
    if (!self.isHandleTouchEvent)
    {
        return isTouchTopToolView;
    }
    BOOL isTouchPlayOrPauseBtn = CGRectContainsPoint(self.playOrPauseBtn.frame, point);
    BOOL isTouchBottomToolView = CGRectContainsPoint(self.bottomToolView.frame, point);
    if (isTouchPlayOrPauseBtn || isTouchBottomToolView || isTouchTopToolView)
    {
        return YES;
    }
    return NO;
}

@end
