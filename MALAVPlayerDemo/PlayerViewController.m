//
//  PlayerViewController.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/13.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "PlayerViewController.h"

#define VideoUrl0 @"http://7xt9dm.com2.z0.glb.qiniucdn.com/FjIhV8e8nm2FqEGAxPnK7HO1oYfZ"
#define VideoUrl1   @"http://7xt9dm.com2.z0.glb.qiniucdn.com/lsatIdzmGoCjCMijL4VBbTfHb2N3"
#define VideoUrl2  @"http://7xt9dm.com2.z0.glb.qiniucdn.com/lpNHSVMrVtNOO85mNNJxWGZVbCzR"

#define UrlArray1  @[VideoUrl0,VideoUrl1,VideoUrl2]

#define Url1 @"http://hzv.zhongyewx.com/201508/24659202-5fae-498d-a0f4-9ba76d9538d3/output.m3u8"
#define Url2 @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"
#define Url3 @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4"

#define UrlArray2 @[Url1]


@interface PlayerViewController ()<NMPlayerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *top_center_LB;

@end

@implementation PlayerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.nmPlayerView setTopView:self.topView playerDeleagte:self];
    if (self.videoArray)
    {
        [self.nmPlayerView playWithVideoUrlArray:self.videoArray selfSuperView:self.view];
    }
    else
    {
        [self.nmPlayerView replaceSuperView:self.view];
    }
}

- (IBAction)changePlayContentBtnClick:(UIButton *)sender
{
    static int flag = 0;
    NSArray *playUrlArray;
    NSArray *array1 = UrlArray1;
    NSArray *array2 = UrlArray2;
    if (flag == 0)
    {
        flag = 1;
        playUrlArray = array2;
    }
    else
    {
        flag = 0;
        playUrlArray = array1;
    }
    [self.nmPlayerView playWithVideoUrlArray:playUrlArray selfSuperView:self.view];
}

//MARK: NMPlayerViewDelegate
- (void)updateTopViewFrame:(CGRect)frame
{
    self.top_center_LB.centerX = frame.size.width / 2;
}

- (CGRect)getHalfScreenFrame
{
    return CGRectMake(0, 0, NMScreenWidth, NMScreenWidth * (9 / 16.0));
}

- (void)loadVideoFinish:(BOOL)isLoadSuccess
{
    if (isLoadSuccess)
    {
        [self.nmPlayerView playVideo];
    }
    else
    {
        NSLog(@"加载失败了");
    }
}

- (IBAction)backBtnClick:(UIButton *)sender
{
    if (self.nmPlayerView.isFullScreen)
    {
        [self.nmPlayerView changeToHalfScreen];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc
{
    [self.topView removeFromSuperview];
    [self.nmPlayerView removePlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
