//
//  NMQueuePlayer.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/12.
//  Copyright © 2016年 allyData. All rights reserved.
//
//通过以下通知可获知缓冲不足暂停了，及缓冲达到可播放程度
//可播放：AVPlayerItemNewAccessLogEntryNotification
//暂停了：AVPlayerItemPlaybackStalledNotification
//http://stackoverflow.com/questions/6880817/ios-avplayer-trigger-streaming-is-out-of-buffer


#import "NMQueuePlayer.h"

static int AAPLPlayerViewControllerKVOContext = 0;

@interface NMQueuePlayer()

/**
 *  保存队列中的AVPlayerItem
 */
@property (nonatomic, strong) NSMutableArray *avPlayerItemsArray;
/**
 *  用于保存AVPlayerItem的字典key为视频url，value为item；用来给分段视频排序
 */
@property (nonatomic, strong) NSMutableDictionary *itemDic;
/**
 *  视频地址数组
 */
@property (nonatomic, strong) NSArray *videoUrlArray;
/**
 *  监控播放当前item播放时间的observer的key
 */
@property (nonatomic, strong) id timeObserVerToken;

/**
 *  记录当前播放时间
 */
@property (nonatomic, assign) double currentPlayTime;

@end

@implementation NMQueuePlayer

//MARK: get
+ (NSArray *)assetKeysRequiredToPlay
{
    return @[@"playable", @"hasProtectedContent"];
}

- (NSMutableArray *)avPlayerItemsArray
{
    if (_avPlayerItemsArray == nil)
    {
        _avPlayerItemsArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _avPlayerItemsArray;
}

- (NSMutableDictionary *)itemDic
{
    if (_itemDic == nil)
    {
        _itemDic = [[NSMutableDictionary alloc] init];
    }
    return _itemDic;
}

- (NMAVPlayerItem *)nmCurrentItem
{
    return (NMAVPlayerItem *)self.currentItem;
}

//MARK: 初始化
- (instancetype)init
{
    if (self = [super init])
    {
        [self setUpPlayer];
    }
    return self;
}

- (void)setUpPlayer
{
    [self registerObserver];
    [self registerNotifation];
}

//MARK: observer
- (void)registerObserver
{
    //当前播放速度
    [self addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    //当前AVPlayerItem记载状况
    [self addObserver:self forKeyPath:@"currentItem.status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    //currentItem发生改变
    [self addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    //加载进度
    [self addObserver:self forKeyPath:@"currentItem.loadedTimeRanges" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:&AAPLPlayerViewControllerKVOContext];
    
    //监控播放进度
    __weak NMQueuePlayer *weakSelf = self;
    self.timeObserVerToken = [self addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        NMAVPlayerItem *item = (NMAVPlayerItem *)weakSelf.currentItem;
        double timeElapsed = CMTimeGetSeconds(time) + item.itemStartTime;
        CGFloat playProgress = timeElapsed / self.model.videoTotalDuration;
        weakSelf.currentPlayTime = timeElapsed;
        if(timeElapsed > weakSelf.model.videoTotalDuration)
        {
            timeElapsed = weakSelf.model.videoTotalDuration;
        }
        if ([weakSelf.nm_delegate respondsToSelector:@selector(nowPlayTime:totalTime:playProgress:)])
        {
            [weakSelf.nm_delegate nowPlayTime:timeElapsed totalTime:weakSelf.model.videoTotalDuration playProgress:playProgress];
        }
    }];
    
    [self addObserver:self forKeyPath:@"currentItem.playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:&AAPLPlayerViewControllerKVOContext];
    [self addObserver:self forKeyPath:@"currentItem.playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:&AAPLPlayerViewControllerKVOContext];
}

- (void)resignObserver
{
    [self removeObserver:self forKeyPath:@"rate" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"currentItem.status" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"currentItem" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"currentItem.loadedTimeRanges" context:&AAPLPlayerViewControllerKVOContext];
    if (self.timeObserVerToken)
    {
        [self removeTimeObserver:self.timeObserVerToken];
        self.timeObserVerToken = nil;
    }
    [self removeObserver:self forKeyPath:@"currentItem.playbackBufferEmpty" context:&AAPLPlayerViewControllerKVOContext];
    [self removeObserver:self forKeyPath:@"currentItem.playbackLikelyToKeepUp" context:&AAPLPlayerViewControllerKVOContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != &AAPLPlayerViewControllerKVOContext)
    {
        // KVO isn't for us.
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if ([keyPath isEqualToString:@"currentItem"])//当前item改变
    {
       
    }
    else if ([keyPath isEqualToString:@"rate"])//当前播放速度
    {
        double newRate = [change[NSKeyValueChangeNewKey] doubleValue];
        if([self.nm_delegate respondsToSelector:@selector(playStatusChange:)])
        {
            _isPlaying = (newRate == 1.0);
            [self.nm_delegate playStatusChange:_isPlaying];
        }
    }
    else if ([keyPath isEqualToString:@"currentItem.status"])//当前item加载状态
    {
        NSNumber *newStatusAsNumber = change[NSKeyValueChangeNewKey];
        AVPlayerItemStatus newStatus = [newStatusAsNumber isKindOfClass:[NSNumber class]] ? newStatusAsNumber.integerValue : AVPlayerItemStatusUnknown;
        
        if (newStatus == AVPlayerItemStatusFailed)
        {
            
        }
    }
    else if ([keyPath isEqualToString:@"currentItem.loadedTimeRanges"])//加载进度
    {
        CGFloat loadProgress = [self getLoadProgress];
        if([self.nm_delegate respondsToSelector:@selector(updateLoadProgress:)])
        {
            [self.nm_delegate updateLoadProgress:loadProgress];
        }
    }
    else if ([keyPath isEqualToString:@"currentItem.playbackBufferEmpty"])//卡顿
    {
        id newValue = [change objectForKey:@"new"];
        if(![newValue isKindOfClass:[NSNull class]])
        {
            if([newValue boolValue])
            {
                //NMAVPlayerItem *ci = [self nmCurrentItem];
                //NSLog(@"第%ld段 卡了",(long)ci.itemPartNO + 1);
                _isBlocked = YES;
                [self playBlocked];
            }
            else
            {
                //NSLog(@"可能不卡了");
            }
        }
    }
    else if ([keyPath isEqualToString:@"currentItem.playbackLikelyToKeepUp"])//不卡了
    {
        id newValue = [change objectForKey:@"new"];
        if(![newValue isKindOfClass:[NSNull class]])
        {
            if([newValue boolValue])
            {
                _isBlocked = NO;
                //NMAVPlayerItem *ci = [self nmCurrentItem];
                //NSLog(@"第%ld段 不卡了",(long)ci.itemPartNO + 1);
                if(self.isPlaying)
                {
                    [self play];
                }
                [self blockEnd];
            }
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//MARK: Notifation
- (void)registerNotifation
{
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //播放失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemPlayFailed) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
}

- (void)resignNotifation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
}

//播放完成
- (void)itemPlayEnd
{
   if(self.currentPlayTime + 0.0001 > self.model.videoTotalDuration)
   {
       if ([self.nm_delegate respondsToSelector:@selector(playEnd)])
       {
           [self.nm_delegate playEnd];
       }
   }
}

//播放失败
- (void)itemPlayFailed
{
    if ([self.nm_delegate respondsToSelector:@selector(nmPlayFailed)])
    {
        [self.nm_delegate nmPlayFailed];
    }
}

//播放堵塞了
- (void)playBlocked
{
    if ([self.nm_delegate respondsToSelector:@selector(nmplayBlocked)])
    {
        [self.nm_delegate nmplayBlocked];
    }
}

//阻塞停止
- (void)blockEnd
{
    if ([self.nm_delegate respondsToSelector:@selector(nmBlockEnd)])
    {
        [self.nm_delegate nmBlockEnd];
    }
}

//MARK: help
/**
 *  获取视频加载进度
 *
 *  @return CGFloat
 */
- (CGFloat)getLoadProgress
{
    CGFloat progress = 0.0f;
    NMAVPlayerItem *item = (NMAVPlayerItem *)self.currentItem;
    double videoTotalDuration = self.model.videoTotalDuration;
    if(item && videoTotalDuration > 0)
    {
        item.itemLoadTime = [self availableDuration];
        double loadTime = item.itemLoadTime + item.itemStartTime;
        progress = loadTime / videoTotalDuration;
        BOOL allVideoLoadFinish = YES;
        for (NMAVPlayerItem *item in self.avPlayerItemsArray)
        {
            if(item.loadFinish == NO)
            {
                allVideoLoadFinish = NO;
                break;
            }
        }
        if(allVideoLoadFinish)
        {
            progress = 1.0f;
        }
    }
    return progress;
}

/**
 *  获取当前item缓存时长
 *
 *  @return double
 */
- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [[self currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

/**
 *  根据当前时间判断播放到第几段视频
 *
 *  @param time 当前时间
 *
 *  @return video段落号
 */
- (NSInteger)getVideoPartNOWithTime:(double)time
{
    NSInteger videoPartNO = NSNotFound;
    for (NMAVPlayerItem *item in self.avPlayerItemsArray)
    {
        if ([item timeIsINItem:time])
        {
            videoPartNO = [self.avPlayerItemsArray indexOfObject:item];
            break;
        }
    }
    return videoPartNO;
}

/**
 *  是否处理observer
 *
 *  @return 切换item时可能响应的是上个item的observer
 */
- (BOOL)isHandleObserVer
{
    NMAVPlayerItem *nmItem = [self nmCurrentItem];
    return [nmItem timeIsINItem:self.currentPlayTime];
}

#pragma mark - 播放控制
//MARK: 预加载视频
- (void)preparePlayWithVideoUrlArray:(NSArray *)videoUrlArray finishBlcok:(void (^)(BOOL))finishBlock
{
    self.model = [NMLoadVideoModel modelWithVideoCount:videoUrlArray.count];
    self.videoUrlArray = videoUrlArray;
    for (NSString *videoUrl in videoUrlArray)
    {
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoUrl] options:nil];
        [asset loadValuesAsynchronouslyForKeys:NMQueuePlayer.assetKeysRequiredToPlay completionHandler:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self checkAndInsertAsset:asset videoUrl:videoUrl];
                if (self.model.loadFinishNO == self.model.needLoadVideoNO)
                {
                    self.model.videoTotalDurationStr = [NMHelp createTimeString:self.model.videoTotalDuration];
                    BOOL loadSuccess = (self.model.loadSuccessVideoNO > 0);
                    if (loadSuccess)
                    {
                        [self addItems];
                    }
                    if (finishBlock)
                    {
                        finishBlock(loadSuccess);
                    }
                }
            });
        }];
    }
}

//检查asset是否加载成功，如果加载成功保存起来
- (BOOL)checkAndInsertAsset:(AVURLAsset *)asset videoUrl:(NSString *)videoUrl
{
    BOOL loadSuccess = YES;
    self.model.loadFinishNO++;
    for (NSString *key in self.class.assetKeysRequiredToPlay)
    {
        NSError *error = nil;
        if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed)
        {
            loadSuccess = NO;
        }
    }
    if (!asset.playable || asset.hasProtectedContent)
    {
        loadSuccess = NO;
    }
    if (loadSuccess)
    {
        self.model.loadSuccessVideoNO++;
        [self.itemDic setObject:asset forKey:videoUrl];
    }
    return loadSuccess;
}

//视频信息获取结束后；生成AVPlayerItem排序并加入播放队列;
- (void)addItems
{
    NMAVPlayerItem *afterItem = nil;
    if (self.avPlayerItemsArray.count > 0)
    {
        [self.avPlayerItemsArray removeAllObjects];
    }
    int videoPartNO = 0;
    for (NSString *videoUrl in self.videoUrlArray)
    {
        AVURLAsset *asset = [self.itemDic objectForKey:videoUrl];
        if (asset)
        {
            NMAVPlayerItem *item = [NMAVPlayerItem itemWithAsset:asset startTiem:self.model.startTime partNO:videoPartNO];
            if([self canInsertItem:item afterItem:afterItem] && item.itemDuration > 0)
            {
                [self insertItem:item afterItem:afterItem];
                [self.avPlayerItemsArray addObject:item];
                videoPartNO++;
                afterItem = item;
                self.model.startTime = item.itemEndTime;
                self.model.videoTotalDuration += item.itemDuration;
            }
        }
    }
    self.model.videoTotalDurationStr = [NMHelp createTimeString:self.model.videoTotalDuration];
    [self.itemDic removeAllObjects];
}

//MARK: seek
- (void)seekWithProgress:(CGFloat)progress withcompletion:(void (^)(void))completion
{
    double seekToSeconds = self.model.videoTotalDuration * progress;
    NSInteger videoPartNO = [self getVideoPartNOWithTime:seekToSeconds];
    NMAVPlayerItem *currentItem = (NMAVPlayerItem *)self.currentItem;
    BOOL isOnlyHaveOnePart = (self.avPlayerItemsArray.count == 1 && progress == 0);
    if ((currentItem.itemPartNO == videoPartNO) && (self.items.count > 0) && (!isOnlyHaveOnePart))
    {
        
        
    }
    else
    {
        [self removeAllItems];
        NMAVPlayerItem *afterItem = nil;
        for (NSInteger i = videoPartNO; i < self.avPlayerItemsArray.count; i++)
        {
            NMAVPlayerItem *insertItem = self.avPlayerItemsArray[i];
            if([self canInsertItem:insertItem afterItem:afterItem])
            {
                [insertItem seekToTime:kCMTimeZero];
                [self insertItem:insertItem afterItem:afterItem];
                afterItem = insertItem;
            }
        }
        currentItem = (NMAVPlayerItem *)[self.items firstObject];
    }
    double seekTime = seekToSeconds - currentItem.itemStartTime;
    if (seekTime >= currentItem.itemDuration)
    {
        seekTime = currentItem.itemDuration - 1.0;
    }
    [self seekToTime:CMTimeMakeWithSeconds(seekTime, 1000) completionHandler:^(BOOL finished) {
        
        if (completion)
        {
            completion();
        }
    }];
}

//MARK: dealloc
/**
 *  释放资源
 */
- (void)releaseResource
{
    [self pause];
    [self.currentItem cancelPendingSeeks];
    [self.currentItem.asset cancelLoading];
    [self cancelPendingPrerolls];
    [self resignObserver];
    [self resignNotifation];
    self.nm_delegate = nil;
    [self.avPlayerItemsArray removeAllObjects];
    [self removeAllItems];
}

- (void)dealloc
{
    NSLog(@"NMQueuePlayer dealloc!!!");
}


@end
