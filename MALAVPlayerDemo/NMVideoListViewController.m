//
//  NMVideoListViewController.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/17.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMVideoListViewController.h"
#import "NMVideoListCell.h"
#import "PlayerViewController.h"

#define Url1 @"http://hzv.zhongyewx.com/201508/24659202-5fae-498d-a0f4-9ba76d9538d3/output.m3u8"
#define Url2 @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"
#define Url3 @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4"

#define UrlArray2 @[Url1]

@interface NMVideoListViewController ()<NMVideoListCellDelegate,NMPlayerViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NMPlayerView *nmPlayerView;
@property (nonatomic, weak) NMVideoListCell *currentCell;

@end

@implementation NMVideoListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nmPlayerView.nmPlayerViewDelegate = self;
}

- (NMPlayerView *)nmPlayerView
{
    if (_nmPlayerView == nil)
    {
        _nmPlayerView = [[NMPlayerView alloc] initWithFrame:CGRectMake(0, 0, NMScreenWidth, NMScreenWidth * (9 / 16.0)) topView:nil selfSuperView:nil delegate:self];
    }
    return _nmPlayerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"NMVideoListCell" bundle:nil] forCellReuseIdentifier:NMVideoListCell_Identifier];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NMVideoListCell_CellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NMVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:NMVideoListCell_Identifier];
    [cell setUpCellDataWithIndexPath:indexPath delegate:self];
    return cell;
}

- (void)playBtnClickWithCell:(NMVideoListCell *)cell
{
    self.currentCell = cell;
    [self.nmPlayerView playWithVideoUrlArray:UrlArray2 selfSuperView:cell.playerView];
}

- (void)nm_bottomBtnClick
{
    PlayerViewController *playVC = [[PlayerViewController alloc] init];
    playVC.nmPlayerView = self.nmPlayerView;
    if (self.currentCell)
    {
        [self.nmPlayerView replaceSuperView:nil];
        self.currentCell = nil;
    }
    else
    {
        playVC.videoArray = UrlArray2;
    }
    [playVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:playVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.currentCell)
    {
        return;
    }
    NSArray *nowCellsArray = self.tableView.visibleCells;
    if (![nowCellsArray containsObject:self.currentCell])
    {
        [self nmListVCstopPlay];
    }
}

- (void)loadVideoFinish:(BOOL)isLoadSuccess
{
    if (isLoadSuccess)
    {
        [self.nmPlayerView playVideo];
    }
}

- (CGRect)getHalfScreenFrame
{
    CGRect halfScreenFrame = CGRectZero;
    if (self.currentCell)
    {
       halfScreenFrame = [self.currentCell.playerView convertRect:self.currentCell.playerView.frame toView:self.navigationController.view];
    }
    return halfScreenFrame;
}

- (void)nmListVCstopPlay
{
    [self.nmPlayerView removePlayer];
    self.currentCell = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
