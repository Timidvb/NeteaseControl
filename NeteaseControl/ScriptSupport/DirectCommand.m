#import "DirectCommand.h"
#import "NowPlayingHelper.h"


@implementation DirectCommand

- (void)updateSelected {
    NowPlayingItem *latestItem = NowPlayingHelper.sharedHelper.nowPlayingItem;
    if([latestItem.appBundleIdentifier isEqual: _identifier]) {
        _item = latestItem;
    }
}


- (id)performDefaultImplementation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateSelected) name:@"kNowPlayingItemDidChange" object:nil];
    });
    _identifier = [self directParameter];
    NowPlayingItem *latestItem = NowPlayingHelper.sharedHelper.nowPlayingItem;
    if([latestItem.appBundleIdentifier isEqual: _identifier]) {
        _item = latestItem;
    }
    NSString *progress = @"";
    long trueEla = 0;
    long dur = 0;
    if([_item.isPlaying isEqual:@"YES"]) {
        long ela = [[NSString stringWithFormat:@"%@", _item.elapsed] longLongValue];
        dur = [[NSString stringWithFormat:@"%@", _item.duration] longLongValue];
        trueEla = [self getTrueElapsedTime:ela TimeStamp:_item.timeStamp];
        progress = [self getPlayingProgress:trueEla duration:dur];
    }
    NSString *stat = [NSString stringWithFormat:@"%@*-,%@*-,%@*-,%@*-,%@*-,%@*-,%ld*-,%ld", _item.appBundleIdentifier, _item.title, _item.artist, _item.album, _item.isPlaying, progress, trueEla, dur];
	return [NSString stringWithFormat:@"%@", stat];
}

- (NSString *)getPlayingProgress:(long) trueEla duration: (long) duration {
    if(duration == 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@ / %@",[self secondToTime:trueEla], [self secondToTime:duration]];
}

- (long)getTrueElapsedTime:(long) elapsed TimeStamp: (NSDate *)timeStamp {
    NSDate* startDate = timeStamp;
    NSDate* endDate = [[NSDate alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:type fromDate:startDate toDate:endDate options:0];
    long trueEla = elapsed + cmps.second + 1;
    return trueEla;
}

- (NSString *)secondToTime:(long) second {
    long hour = 0, minute = 0;
    while(second >= 3600) {
        second -= 3600;
        hour++;
    }
    while (second >= 60) {
        second -= 60;
        minute++;
    }
    if(hour > 0) {
        return [NSString stringWithFormat:@"%2ld:%2ld:%02ld",hour,minute,second];
    }
    else {
        return [NSString stringWithFormat:@"%2ld:%02ld",minute,second];
    }
}

@end
