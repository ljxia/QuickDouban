//
//  SearchController.m
//  QuickDouban
//
//  Created by liangjie on 2011-02-16.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import "SearchController.h"
#import "QuickDoubanAppDelegate.h"

@implementation SearchController

- (void) doSearch{
	NSLog(@"Search %@!", [searchTextField stringValue]);
}

- (IBAction)search:(id)sender {
	[self doSearch];
}


- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;
	
    if (commandSelector == @selector(insertNewline:))
    {
		[self doSearch];
        result = NO;
    }
    else if (commandSelector == @selector(insertTab:))
    {
		[self doSearch];
        result = YES;
    }
	else if (commandSelector == @selector(cancelOperation:))
	{
		// TODO: refactor
		[(QuickDoubanAppDelegate *)[[NSApplication sharedApplication] delegate] show:NO];
		result = YES;
	}
	
    return result;
}

@end
