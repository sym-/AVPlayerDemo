//
//  NMForwardView.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/15.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMForwardView : UIView

@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

+ (NMForwardView *)getNMForwardView;

+ (void)showWithStr:(NSString *)str isForward:(BOOL)isForward inView:(UIView *)inView progress:(CGFloat)progress;

+ (void)hiddenForWardView;

@end
