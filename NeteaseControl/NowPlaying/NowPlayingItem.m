//
//  NowPlayingItem.m
//  NeteaseControl
//
//  Created by chen on 2020/2/25.
//  Copyright © 2020 chen. All rights reserved.
//

#import "NowPlayingItem.h"
#import "NowPlayingHelper.h"

@implementation NowPlayingItem



- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    NowPlayingItem *item = [[NowPlayingItem allocWithZone:zone] init];
    item.appBundleIdentifier = [self.appBundleIdentifier copy];
    item.title = [self.title copy];
    item.artist = [self.artist copy];
    item.album = [self.album copy];
    item.isPlaying = [self.isPlaying copy];
    item.elapsed = [self.elapsed copy];
    item.duration = [self.duration copy];
    item.timeStamp = [self.timeStamp copy];
    return item;
}

@end
