//
//  NMLoadVideoModel.h
//  MALAVPlayerDemo
//
//  Created by mal on 16/6/12.
//  Copyright © 2016年 allyData. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMLoadVideoModel : NSObject

@property (nonatomic, assign) NSInteger needLoadVideoNO;
@property (nonatomic, assign) NSInteger loadFinishNO;
@property (nonatomic, assign) NSInteger loadSuccessVideoNO;
@property (nonatomic, assign) double    videoTotalDuration;
@property (nonatomic, copy)   NSString  *videoTotalDurationStr;

@property (nonatomic, assign) double    startTime;

+ (NMLoadVideoModel *)modelWithVideoCount:(NSInteger)count;

@end
