//
//  NMBottomToolView.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/13.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMBottomToolView.h"

#define KLabel_DefaultText       @"00:00"             //label默认文本
#define KMarginWithSuperView     8                  //和父视图之间的距离
#define KMarginWithBrotherView   10                //兄弟视图之间的距离
#define KLabel_Height            15                //label高度
#define KFullScreenBtn_HW        40                //全屏按钮尺寸
#define KSliderHeight            15                //播放进度条高度
#define KLabelFontSize           12                //label字体大小

@interface NMBottomToolView()

@end

@implementation NMBottomToolView

- (NMPlayerSlider *)nmSlider
{
    if(_nmSlider == nil)
    {
        _nmSlider = [[NMPlayerSlider alloc] init];
        _nmSlider.height = KSliderHeight;
    }
    return _nmSlider;
}

- (UILabel *)currentTiemLB
{
    if (_currentTiemLB == nil)
    {
        _currentTiemLB = [[UILabel alloc] init];
        _currentTiemLB.textColor = [UIColor whiteColor];
        _currentTiemLB.height = KLabel_Height;
        _currentTiemLB.textAlignment = NSTextAlignmentCenter;
        _currentTiemLB.text = KLabel_DefaultText;
        _currentTiemLB.font = [UIFont systemFontOfSize:KLabelFontSize];
    }
    return _currentTiemLB;
}

- (UILabel *)totalTimeLB
{
    if (_totalTimeLB == nil)
    {
        _totalTimeLB = [[UILabel alloc] init];
        _totalTimeLB.textColor = [UIColor whiteColor];
        _totalTimeLB.height = KLabel_Height;
        _totalTimeLB.textAlignment = NSTextAlignmentCenter;
        _totalTimeLB.text = KLabel_DefaultText;
        _totalTimeLB.font = [UIFont systemFontOfSize:KLabelFontSize];
    }
    return _totalTimeLB;
}

- (UIButton *)fullScreenBtn
{
    if (_fullScreenBtn == nil)
    {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenBtn.width = KFullScreenBtn_HW;
        _fullScreenBtn.height = KFullScreenBtn_HW;
        //_fullScreenBtn.backgroundColor = [UIColor redColor];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"list_btn_fangda"] forState:(UIControlStateNormal)];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"list_btn_suoxiao"] forState:(UIControlStateSelected)];
    }
    return _fullScreenBtn;
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
    [self addSubview:self.currentTiemLB];
    [self addSubview:self.nmSlider];
    [self addSubview:self.totalTimeLB];
    [self addSubview:self.fullScreenBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //当前播放时间label
    self.currentTiemLB.frame = CGRectMake(KMarginWithSuperView, 0, 0, KLabel_Height);
    self.currentTiemLB.centerY = self.height / 2;
    [self.currentTiemLB sizeToFit];
    self.currentTiemLB.adjustsFontSizeToFitWidth = YES;
    
    //全屏button
    self.fullScreenBtn.right = self.width - KMarginWithSuperView;
    self.fullScreenBtn.centerY = self.height / 2;
    
    //总时间label
    self.totalTimeLB.height = KLabel_Height;
    self.totalTimeLB.right = self.fullScreenBtn.left;
    self.totalTimeLB.centerY = self.height / 2;
    [self.totalTimeLB sizeToFit];
    self.totalTimeLB.adjustsFontSizeToFitWidth = YES;
    
    //播放进度条
    self.nmSlider.left = self.currentTiemLB.right + KMarginWithBrotherView;
    self.nmSlider.width = self.width - self.nmSlider.left - (self.width - self.totalTimeLB.left) - KMarginWithBrotherView;
    self.nmSlider.centerY = self.height / 2;
}

- (void)changeToFullScrren:(BOOL)isFullScreen
{
    self.fullScreenBtn.selected = isFullScreen;
}

- (void)setCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime
{
    self.currentTiemLB.text = currentTime;
    self.totalTimeLB.text = totalTime;
}

- (void)setPlayProgress:(CGFloat)playProgress
{
    self.nmSlider.slider.value = playProgress;
}

- (void)setLoadProgress:(CGFloat)loadProgress
{
    self.nmSlider.progressView.progress = loadProgress;
}

@end
