//
//  NowPlayingHelper.h
//  NeteaseControl
//
//  Created by chen on 2020/2/25.
//  Copyright © 2020 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NowPlayingItem.h"

NS_ASSUME_NONNULL_BEGIN


@interface NowPlayingHelper : NSObject


@property (nonatomic, strong) NowPlayingItem* nowPlayingItem;
@property (nonatomic, strong) NSString* kNowPlayingItemDidChange;

@property (nonatomic, strong) NowPlayingItem* selectedPlayingItem;
@property (nonatomic, strong) NSString* selected;

+ (instancetype)sharedHelper;

@end

NS_ASSUME_NONNULL_END
