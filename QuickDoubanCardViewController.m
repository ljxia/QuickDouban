//
//  QuickDoubanCardViewController.m
//  QuickDouban
//
//  Created by liangjie on 2011-02-25.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import "QuickDoubanCardViewController.h"


@implementation QuickDoubanCardViewController

@synthesize title;
@synthesize url;

- (void) mouseUp:(NSEvent *)theEvent{
	if ([theEvent clickCount] >= 2) {
		NSString *entryUrl = [(NSDictionary *)[url objectAtIndex:1] objectForKey:@"@href"];
		NSLog(@"%@", entryUrl);
		[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:entryUrl]];
	}
}


@end
