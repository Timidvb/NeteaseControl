//
//  NowPlayingItem.h
//  NeteaseControl
//
//  Created by chen on 2020/2/25.
//  Copyright © 2020 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NowPlayingItem : NSObject <NSCopying>

@property (nonatomic, strong) NSString *appBundleIdentifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *isPlaying;
@property (nonatomic, strong) NSString *elapsed;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSDate *timeStamp;

@end

NS_ASSUME_NONNULL_END
