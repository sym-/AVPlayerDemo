//
//  NMGestureView.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/15.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMGestureView.h"
#import "NMForwardView.h"
#import "NMQueuePlayer.h"

static CGPoint lastTransation = {0, 0};

@interface NMGestureView()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) double currentTime;
@property (nonatomic, assign) double totalTime;
@property (nonatomic, assign) BOOL   isChangeTimeStr;//上面的两个值是否可以改变
@property (nonatomic, assign) CGFloat seekProgress;

@end

@implementation NMGestureView

- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        self.isChangeTimeStr = YES;
        [self addGesture];
    }
    return self;
}

- (void)setCurrentTime:(double)currentTime totalTime:(double)totalTime
{
    if (self.isChangeTimeStr)
    {
        self.currentTime = currentTime;
        self.totalTime = totalTime;
    }
}

- (void)addGesture
{
    //展示或者隐藏toolView手势
    UITapGestureRecognizer *singleClickGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick)];
    [self addGestureRecognizer:singleClickGes];

    //双击开始或者暂停播放
    UITapGestureRecognizer *doubleClickGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick)];
    doubleClickGes.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleClickGes];
    [singleClickGes requireGestureRecognizerToFail:doubleClickGes];
    
    //拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
}

#pragma mark - 单击
- (void)singleClick
{
    if ([self.nm_gesDelegate respondsToSelector:@selector(nm_singleClick)])
    {
        [self.nm_gesDelegate nm_singleClick];
    }
}

- (void)doubleClick
{
    if ([self.nm_gesDelegate respondsToSelector:@selector(nm_doubleClick)])
    {
        [self.nm_gesDelegate nm_doubleClick];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)panGes
{
    UIGestureRecognizerState state = panGes.state;
     CGPoint transation = [panGes translationInView:self];
    if (state == UIGestureRecognizerStateBegan)
    {
        lastTransation = transation;
        self.seekProgress = self.currentTime / self.totalTime;
        self.isChangeTimeStr = NO;
    }
    else if (state == UIGestureRecognizerStateChanged)
    {
        BOOL isForward = (transation.x > lastTransation.x);
        lastTransation = transation;
        NSLog(@"======%@",NSStringFromCGPoint(transation));
       [self showForwardViewWithTransationX:transation.x isForward:isForward];
    }
    else
    {
        [NMForwardView hiddenForWardView];
        self.isChangeTimeStr = YES;
        if([self.nm_gesDelegate respondsToSelector:@selector(nm_seekWithProgress:)])
        {
            [self.nm_gesDelegate nm_seekWithProgress:self.seekProgress];
        }
    }
}

- (int)getSeconds:(NSString *)timeStr
{
    int seconds = 0;
    NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
    seconds = [[timeArray firstObject] intValue] * 60 + [[timeArray lastObject] intValue];
    return seconds;
}

- (void)showForwardViewWithTransationX:(CGFloat)transationX isForward:(BOOL)isForward
{
    CGFloat progress = transationX / self.width;
    double currentSeconds;
    currentSeconds = self.currentTime + progress * self.totalTime;
    if (currentSeconds < 0)
    {
        currentSeconds = 0;
    }
    if(currentSeconds > self.totalTime)
    {
        currentSeconds = self.totalTime;
    }
    NSString *str = [NSString stringWithFormat:@"%@/%@",[NMHelp createTimeString:currentSeconds],[NMHelp createTimeString:self.totalTime]];
    self.seekProgress = currentSeconds / self.totalTime;
    [NMForwardView showWithStr:str isForward:YES inView:self progress:self.seekProgress];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        return [NMHelp isLandscape];
    }
    return YES;
}

@end
