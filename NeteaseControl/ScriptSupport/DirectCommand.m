#import "DirectCommand.h"
#import "NowPlayingHelper.h"


@implementation DirectCommand



- (id)performDefaultImplementation {
    
    NowPlayingHelper.sharedHelper.selected = [self directParameter];
    NowPlayingItem *item = NowPlayingHelper.sharedHelper.selectedPlayingItem;
    
    NSString *progress = @"";
    long trueEla = 0;
    long dur = 0;
    if([item.isPlaying isEqual:@"YES"]) {
        long ela = [[NSString stringWithFormat:@"%@", item.elapsed] longLongValue];
        dur = [[NSString stringWithFormat:@"%@", item.duration] longLongValue];
        trueEla = [self getTrueElapsedTime:ela TimeStamp:item.timeStamp];
        progress = [self getPlayingProgress:trueEla duration:dur];
    }
    NSString *stat = [NSString stringWithFormat:@"%@*-,%@*-,%@*-,%@*-,%@*-,%@*-,%ld*-,%ld", item.appBundleIdentifier, item.title, item.artist, item.album, item.isPlaying, progress, trueEla, dur];
    return [NSString stringWithFormat:@"%@", stat];
    
    return @"abc";
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
