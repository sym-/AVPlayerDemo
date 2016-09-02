//
//  NMForwardView.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/15.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMForwardView.h"

static NMForwardView *forWard = nil;

@implementation NMForwardView

+ (NMForwardView *)getNMForwardView
{
    NMForwardView *forwardView = [[[NSBundle mainBundle] loadNibNamed:@"NMForwardView" owner:nil options:nil] firstObject];
    forwardView.layer.cornerRadius = 4;
    forwardView.layer.masksToBounds = YES;
    return forwardView;
}

+ (void)showWithStr:(NSString *)str isForward:(BOOL)isForward inView:(UIView *)inView progress:(CGFloat)progress
{
    if (forWard == nil)
    {
        forWard = [self getNMForwardView];
    }
    if (![forWard isDescendantOfView:inView])
    {
        [inView addSubview:forWard];
    }
    forWard.timeLB.attributedText = [self attriStringWithStr:str];
    forWard.progressView.progress = progress;
}

+ (NSMutableAttributedString *)attriStringWithStr:(NSString *)str
{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:str];
    NSInteger strLength = [[[str componentsSeparatedByString:@"/"] firstObject] length];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, strLength)];
    return attriString;
}

+ (void)hiddenForWardView
{
    [forWard removeFromSuperview];
    forWard = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.top = 80;
    self.centerX = self.superview.width / 2;
}

@end
