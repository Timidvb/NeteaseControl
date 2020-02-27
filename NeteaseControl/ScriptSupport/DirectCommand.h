

#import <Cocoa/Cocoa.h>
#import "NowPlayingItem.h"


/* This class implements a simple verb that receives a single
string parameter and returns a string value (a copy of the 
parameter enclosed in quotes).  */

@interface DirectCommand : NSScriptCommand {

}

@property (nonatomic, strong) NowPlayingItem* item;

@property (nonatomic, strong) NSString* identifier;

- (id)performDefaultImplementation;

@end
