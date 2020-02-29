

#import <Cocoa/Cocoa.h>
#import "NowPlayingItem.h"


/* This class implements a simple verb that receives a single
string parameter and returns a string value (a copy of the 
parameter enclosed in quotes).  */

@interface DirectCommand : NSScriptCommand {

}

- (id)performDefaultImplementation;

@end
