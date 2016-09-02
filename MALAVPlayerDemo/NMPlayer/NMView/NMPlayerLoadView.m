//
//  NMPlayerLoadView.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/14.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMPlayerLoadView.h"
#import "FLAnimatedImage.h"

#define KNMLoadingIMWH           40
#define KNMLoadingLBH            20
#define KNMLoadingIM_LB_Margin   12 //loadingIM和bottomLB竖直方向的间距
#define KNMLoading_BgColor       [UIColor clearColor]

@interface NMPlayerLoadView()

@property (nonatomic, strong) FLAnimatedImageView *loadingIM;
@property (nonatomic, strong) UILabel *bottomLB;
@property (nonatomic, strong) UILabel *centerLB;
/**
 *  是否响应点击;因为loadView在最上层所以如果它响应触摸touch事件就不会向上传递了;
 *  顶部工具条不受影响...
 */
@property (nonatomic, assign) BOOL isHandleTap;

@end

@implementation NMPlayerLoadView

- (FLAnimatedImageView *)loadingIM
{
    if (_loadingIM == nil)
    {
        NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"loading1" ofType:@"gif"];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:gifPath]];
        _loadingIM = [[FLAnimatedImageView alloc] init];
        _loadingIM.animatedImage = image;
        _loadingIM.size = CGSizeMake(KNMLoadingIMWH, KNMLoadingIMWH);
    }
    return _loadingIM;
}

- (UILabel *)bottomLB
{
    if (_bottomLB == nil)
    {
        _bottomLB = [[UILabel alloc] init];
        _bottomLB.textColor = [UIColor whiteColor];
        _bottomLB.textAlignment = NSTextAlignmentCenter;
        _bottomLB.height = KNMLoadingLBH;
    }
    return _bottomLB;
}

- (UILabel *)centerLB
{
    if (_centerLB == nil)
    {
        _centerLB = [[UILabel alloc] init];
        _centerLB.textColor = [UIColor whiteColor];
        _centerLB.textAlignment = NSTextAlignmentCenter;
        _centerLB.height = KNMLoadingLBH;
    }
    return _centerLB;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    self.backgroundColor = KNMLoading_BgColor;
    self.alpha = 0.0f;
    [self addSubview:self.centerLB];
    [self addSubview:self.loadingIM];
    [self addSubview:self.bottomLB];
    self.isHandleTap = NO;
}

- (void)showLodingViewWithBottomText:(NSString *)bottomLBText
{
    if (self.alpha < 1.0)
    {
        self.alpha = 1.0;
    }
    if (!self.centerLB.hidden)
    {
        self.centerLB.hidden = YES;
    }
    self.loadingIM.hidden = NO;
    self.bottomLB.hidden = NO;
    self.bottomLB.text = bottomLBText;
}

- (void)showLoadErrorText:(NSString *)text
{
    self.isHandleTap = YES;
    if (!self.loadingIM.hidden)
    {
        self.loadingIM.hidden = YES;
        self.bottomLB.hidden = YES;
    }
    if (self.alpha < 1.0)
    {
        self.alpha = 1.0;
    }
    self.centerLB.hidden = NO;
    self.centerLB.text = text;
}

- (void)hiddenLoadErrorView
{
    self.isHandleTap = NO;
    [self hiddenLodingView];
}

- (void)showOnlyLoadingView
{
    if (self.alpha == 1.0)
    {
        return;
    }
    self.centerLB.hidden = YES;
    self.bottomLB.hidden = YES;
    self.alpha = 1.0f;
    self.loadingIM.hidden = NO;
}

- (void)hiddenLodingView
{
    if (self.alpha > 0.0)
    {
        self.alpha = 0.0f;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.loadingIM.center = CGPointMake(self.width / 2, self.height / 2);
    self.centerLB.center = self.loadingIM.center;
    self.centerLB.width = self.width;
    self.bottomLB.top = self.loadingIM.bottom + KNMLoadingIM_LB_Margin;
    self.bottomLB.width = self.width;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.nm_loadingDelegate respondsToSelector:@selector(reloadVideo)])
    {
        [self.nm_loadingDelegate reloadVideo];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGFloat topBarHeight = 40;//无论什么时候都要保证可以点击返回箭头返回
    if (CGRectContainsPoint(CGRectMake(0, 0, self.width, topBarHeight), point))
    {
        //如果点击区域在顶部工具条范围；则事件可以向上传递；
        return NO;
    }
    return self.isHandleTap;
}

@end
