//
//  NMVideoListCell.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/17.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMPlayerView.h"

#define NMVideoListCell_Identifier @"NMVideoListCell"
#define NMVideoListCell_CellHeight (NMScreenWidth * (9 / 16.0) + 55)
@class NMVideoListCell;
@protocol NMVideoListCellDelegate <NSObject>

- (void)playBtnClickWithCell:(NMVideoListCell *)cell;
- (void)nm_bottomBtnClick;

@end

@interface NMVideoListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoCover_IM;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic, weak) id<NMVideoListCellDelegate> cellDelegate;
@property (nonatomic, weak) NMPlayerView *nmplayerView;

- (void)setUpCellDataWithIndexPath:(NSIndexPath *)indexPath delegate:(id<NMVideoListCellDelegate>)cellDelegate;

@end
