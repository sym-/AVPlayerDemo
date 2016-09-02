//
//  NMVideoListCell.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/17.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMVideoListCell.h"

@implementation NMVideoListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.playBtn setImage:[UIImage imageNamed:@"list_btn_play"] forState:(UIControlStateNormal)];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpCellDataWithIndexPath:(NSIndexPath *)indexPath delegate:(id<NMVideoListCellDelegate>)cellDelegate
{
    self.cellDelegate = cellDelegate;
    NSString *imageName = @"001";
    if (indexPath.row % 2 == 0)
    {
        imageName = @"002";
    }
    self.videoCover_IM.image = [UIImage imageNamed:imageName];
}

- (IBAction)playBtnClick:(UIButton *)sender
{
    if([self.cellDelegate respondsToSelector:@selector(playBtnClickWithCell:)])
    {
        [self.cellDelegate playBtnClickWithCell:self];
    }
}

- (IBAction)bottomBtnClick:(UIButton *)sender
{
    if([self.cellDelegate respondsToSelector:@selector(nm_bottomBtnClick)])
    {
        [self.cellDelegate nm_bottomBtnClick];
    }
}

@end
