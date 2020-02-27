#import "AllCommand.h"
#import "NowPlayingHelper.h"


@implementation AllCommand


- (id)performDefaultImplementation {
    NowPlayingItem *item = NowPlayingHelper.sharedHelper.nowPlayingItem;
    NSString *progress = @"";
    if([item.isPlaying isEqual:@"YES"]) {
        progress = [self getPlayingProgress:item.elapsed duration:item.duration TimeStamp:item.timeStamp];
    }
    NSString *stat = [NSString stringWithFormat:@"%@*-,%@*-,%@*-,%@*-,%@*-,%@",item.appBundleIdentifier, item.title, item.artist, item.album, item.isPlaying, progress];
	return stat;
}

- (NSString *)getPlayingProgress:(id) elapsed duration: (id) duration TimeStamp: (NSDate *) timeStamp {
    long ela = [[NSString stringWithFormat:@"%@", elapsed] longLongValue];
    long dur = [[NSString stringWithFormat:@"%@", duration] longLongValue];
    if(dur == 0) {
        return @"";
    }
    NSDate* startDate = timeStamp;
    NSDate* endDate = [[NSDate alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:type fromDate:startDate toDate:endDate options:0];
    long trueEla = ela + cmps.second;
    return [NSString stringWithFormat:@"%@ / %@",[self secondToTime:trueEla], [self secondToTime:dur]];
}

- (NSString *)secondToTime:(long) second {
    long hour = 0, minute = 0;
    while(second > 3600) {
        second -= 3600;
        hour++;
    }
    while (second > 60) {
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
