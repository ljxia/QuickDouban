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

- (QuickDoubanCardWindow *) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag data:(NSDictionary *)entryData {
	NSLog(@"New Window:\n");
	[QuickDoubanBase timer_start];
	
	self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
	
	cardViewController = [[QuickDoubanCardViewController alloc] initWithNibName:@"QuickDoubanCardView" cardData:entryData];
	
	[cardViewController setNextResponder:[self nextResponder]];
	[self setNextResponder:cardViewController];
	
	[self setContentView:[cardViewController view]];
	[self setReleasedWhenClosed:YES];
	[self setAlphaValue:0];
	
	
	NSLog(@"QuickDoubanCardWindow initiated in %10.4lf seconds\n",[QuickDoubanBase timer_milePost]);
	
	return self;
}

@end
