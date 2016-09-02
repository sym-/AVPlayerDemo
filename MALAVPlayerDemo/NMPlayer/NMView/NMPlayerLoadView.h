//
//  NMPlayerLoadView.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/14.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NMPlayerLoadViewDelegate <NSObject>

- (void)reloadVideo;

@end


@interface NMPlayerLoadView : UIControl

@property (nonatomic, weak) id<NMPlayerLoadViewDelegate> nm_loadingDelegate;

/**
 *  gif + 底部文字
 *
 *  @param bottomLBText 底部文字内容
 */
- (void)showLodingViewWithBottomText:(NSString *)bottomLBText;

/**
 *  加载失败
 *
 *  @param text 提示内容
 */
- (void)showLoadErrorText:(NSString *)text;
- (void)hiddenLoadErrorView;

/**
 *  只显示加载gif
 */
- (void)showOnlyLoadingView;

/**
 *  隐藏自己
 */
- (void)hiddenLodingView;


@end
