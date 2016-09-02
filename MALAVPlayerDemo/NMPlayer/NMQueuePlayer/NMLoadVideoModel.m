//
//  NMLoadVideoModel.m
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/12.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import "NMLoadVideoModel.h"

@implementation NMLoadVideoModel

+ (NMLoadVideoModel *)modelWithVideoCount:(NSInteger)count
{
    NMLoadVideoModel *model = [[NMLoadVideoModel alloc] init];
    model.needLoadVideoNO = count;
    model.videoTotalDuration = 0.0f;
    model.loadFinishNO = 0;
    model.loadSuccessVideoNO = 0;
    model.startTime = 0.0f;
    return model;
}

@end
