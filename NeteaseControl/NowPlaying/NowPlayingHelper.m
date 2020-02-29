//
//  NowPlayingHelper.m
//  NeteaseControl
//
//  Created by chen on 2020/2/25.
//  Copyright © 2020 chen. All rights reserved.
//

#import "NowPlayingHelper.h"
#import "MRMediaRemote.h"

static NowPlayingHelper *helper = nil;

@implementation NowPlayingHelper

+ (instancetype)sharedHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

- (instancetype)init {
    self = [super init];
    MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_get_global_queue(0, 0));
    _nowPlayingItem = [[NowPlayingItem alloc] init];
    _kNowPlayingItemDidChange = @"kNowPlayingItemDidChange";
    [self registerForNotifications];
    [self updateCurrentPlayingApp];
    [self updateMediaContent];
    [self updateCurrentPlayingState];
    return self;
}

- (void)registerForNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateCurrentPlayingApp) name:@"kMRMediaRemoteNowPlayingApplicationDidChangeNotification" object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateMediaContent) name:@"kMRMediaRemoteNowPlayingApplicationClientStateDidChange" object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateMediaContent) name:@"kMRNowPlayingPlaybackQueueChangedNotification" object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateMediaContent) name:@"kMRPlaybackQueueContentItemsChangedNotification" object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateCurrentPlayingState) name:@"kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification" object:nil];
    
}
   
- (void)updateCurrentPlayingApp {
    MRMediaRemoteGetNowPlayingClient(dispatch_get_global_queue(0, 0), ^(id client) {
        if(client != nil) {
            if(MRNowPlayingClientGetBundleIdentifier(client) != nil) {
                NSString *appBundleIdentifier = MRNowPlayingClientGetBundleIdentifier(client);
                if(appBundleIdentifier != nil) {
                    self.nowPlayingItem.appBundleIdentifier = appBundleIdentifier;
                }
            }
            else if(MRNowPlayingClientGetParentAppBundleIdentifier(client) != nil) {
                NSString *appBundleIdentifier = MRNowPlayingClientGetParentAppBundleIdentifier(client);
                if(appBundleIdentifier != nil) {
                    self.nowPlayingItem.appBundleIdentifier = appBundleIdentifier;
                }
            }
            else {
                self.nowPlayingItem.appBundleIdentifier = @"";
            }
            
        }
        else {
            self.nowPlayingItem.appBundleIdentifier = @"";
            self.nowPlayingItem.isPlaying = @"NO";
            self.nowPlayingItem.album = @"";
            self.nowPlayingItem.artist = @"";
            self.nowPlayingItem.title = @"";
        }
        [NSNotificationCenter.defaultCenter postNotificationName:self.kNowPlayingItemDidChange object:nil];
        [self updateSelectedItem];
    });
}

- (void)updateMediaContent {
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_global_queue(0, 0), ^(NSDictionary* info) {
        if(info[kMRMediaRemoteNowPlayingInfoTitle] != nil) {
            self.nowPlayingItem.title = info[kMRMediaRemoteNowPlayingInfoTitle];
        }
        if(info[kMRMediaRemoteNowPlayingInfoAlbum] != nil) {
            self.nowPlayingItem.album = info[kMRMediaRemoteNowPlayingInfoAlbum];
        }
        if(info[kMRMediaRemoteNowPlayingInfoArtist] != nil) {
            self.nowPlayingItem.artist =info[kMRMediaRemoteNowPlayingInfoArtist];
            if(self.nowPlayingItem.artist.length > 17) {
                self.nowPlayingItem.artist = [NSString stringWithFormat:@"%@...", [self.nowPlayingItem.artist substringToIndex:17]];
            }
        }
        if(info[kMRMediaRemoteNowPlayingInfoDuration] != nil && info[kMRMediaRemoteNowPlayingInfoElapsedTime] != nil && info[kMRMediaRemoteNowPlayingInfoTimestamp] != nil) {
            self.nowPlayingItem.elapsed = [NSString stringWithFormat:@"%@", info[kMRMediaRemoteNowPlayingInfoElapsedTime]];
            self.nowPlayingItem.duration = [NSString stringWithFormat:@"%@", info[kMRMediaRemoteNowPlayingInfoDuration]];
            self.nowPlayingItem.timeStamp = info[kMRMediaRemoteNowPlayingInfoTimestamp];
        }
        if(info == nil) {
            self.nowPlayingItem.isPlaying = @"NO";
        }
        [NSNotificationCenter.defaultCenter postNotificationName:self.kNowPlayingItemDidChange object:nil];
        [self updateSelectedItem];
    });
}
- (void)updateCurrentPlayingState {
    MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_global_queue(0, 0), ^(BOOL isPlaying) {
        if([self.nowPlayingItem.appBundleIdentifier isEqual:@""]) {
            self.nowPlayingItem.isPlaying = @"NO";
        }
        else {
            self.nowPlayingItem.isPlaying = isPlaying?@"YES":@"NO";
        }
        [NSNotificationCenter.defaultCenter postNotificationName:self.kNowPlayingItemDidChange object:nil];
        [self updateSelectedItem];
    });
}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)updateSelectedItem {
    if([self.selected isEqual:self.nowPlayingItem.appBundleIdentifier]) {
        self.selectedPlayingItem = [self.nowPlayingItem copy];
    }
    
    
    
    MRMediaRemoteGetNowPlayingClients(dispatch_get_global_queue(0, 0), ^(NSArray * clients) {
        for(NowPlayingHelper *info in clients) {
            if(info != nil) {
                if(MRNowPlayingClientGetBundleIdentifier(info) != nil) {
                    NSString *appBundleIdentifier = MRNowPlayingClientGetBundleIdentifier(info);
                    if(appBundleIdentifier != nil) {
                        NSLog(@"%@", appBundleIdentifier);
                    }
                }
                else if(MRNowPlayingClientGetParentAppBundleIdentifier(info) != nil) {
                    NSString *appBundleIdentifier = MRNowPlayingClientGetParentAppBundleIdentifier(info);
                    if(appBundleIdentifier != nil) {
                        NSLog(@"%@", appBundleIdentifier);
                    }
                }
                else {
                    NSLog(@"no identifier");
                }
                
            }
        }
        
    });
}


@end
