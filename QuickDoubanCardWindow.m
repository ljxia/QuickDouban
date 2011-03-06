//
//  QuickDoubanCardWindowController.m
//  QuickDouban
//
//  Created by liangjie on 2011-03-02.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import "QuickDoubanCardWindow.h"
#import "QuickDoubanBase.h"

@implementation QuickDoubanCardWindow

@synthesize cardViewController;
@synthesize entryData;
@synthesize active;
@synthesize adjacentWindows;

- (QuickDoubanCardWindow *) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	NSLog(@"\n\nNew Window: %@\n", self);
	[QuickDoubanBase timer_start];
	
	self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
	
	if (self)
	{
		[self setReleasedWhenClosed:YES];
		
		cardViewController = [[QuickDoubanCardViewController alloc] initWithNibName:@"QuickDoubanCardView" bundle: nil];
		
		[cardViewController setNextResponder:[self nextResponder]];
		[self setNextResponder:cardViewController];
		
		[self setContentView:[cardViewController view]];
	}
	
	[self setDelegate:self];
	
	NSLog(@"QuickDoubanCardWindow initiated in %10.4lf seconds\n",[QuickDoubanBase timer_milePost]);
	
	return self;
}

- (void) setData:(NSDictionary *)data {
	[self setEntryData:data];
	
}

- (void) render {
	if (entryData) {
		[cardViewController setData:entryData];
	}
}

- (BOOL) canBecomeMainWindow {
	return YES;
}

- (BOOL) canBecomeKeyWindow {
	return YES;
}

- (void) makeActive:(BOOL) isActive {
	[self setActive:isActive];
	[cardViewController makeActive:isActive];
}

- (void) windowDidBecomeKey:(NSNotification *)notification {
	[self makeActive:YES];
}

- (void) windowDidResignKey:(NSNotification *)notification {
	[self makeActive:NO];
}

@end
