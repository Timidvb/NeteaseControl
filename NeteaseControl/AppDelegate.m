//
//  AppDelegate.m
//  NeteaseControl
//
//  Created by chen on 2020/2/26.
//  Copyright © 2020 chen. All rights reserved.
//

#import "AppDelegate.h"
#import "NowPlayingHelper.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NowPlayingHelper.sharedHelper.nowPlayingItem;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
