//
//  NMPlayerSlider.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/12.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMPlayerSlider.h"

@implementation NMPlayerSlider

- (UISlider *)slider
{
    if (_slider == nil)
    {
        _slider = [[UISlider alloc] init];
        [_slider setMinimumTrackTintColor:[UIColor colorWithHexString:@"f46f16"]];
        [_slider setMaximumTrackTintColor:[UIColor clearColor]];
        [_slider setThumbImage:[UIImage imageNamed:@"button_progress"] forState:UIControlStateNormal];
        _slider.value = 0.0f;
    }
    return _slider;
}

- (UIProgressView *)progressView
{
    if (_progressView == nil)
    {
        _progressView = [[UIProgressView alloc] init];
        _progressView.tintColor = [UIColor colorWithHexString:@"#999999"];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"#333333"];
        _progressView.progress = 0.0f;
    }
    return _progressView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setSubView];
    }
    return self;
}

- (void)setSubView
{
    //self.backgroundColor = [UIColor redColor];
    [self addSubview:self.progressView];
    [self addSubview:self.slider];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.slider.frame = self.bounds;
    self.slider.centerY = self.height / 2;
    self.progressView.frame = self.bounds;
    self.progressView.centerY = self.height / 2;
}

@end
