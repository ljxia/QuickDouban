//
//  QuickDoubanAppDelegate.m
//  QuickDouban
//
//  Created by liangjie on 2011-02-16.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import "QuickDoubanAppDelegate.h"
//#import "MAAttachedWindow.h"
#import "QuickDoubanCardWindow.h"

#include <dispatch/dispatch.h>


@implementation QuickDoubanAppDelegate

@synthesize window;
@synthesize searchController;
@synthesize cardWindows;

- (void)awakeFromNib{
	
	searchController = [SearchBarWindowController sharedSearchBar];
	[searchController setDelegate:self];
	
	
	window = [searchController window];
	
	[window setBackgroundColor:[NSColor colorWithDeviceRed:0.1 green:0.1 blue:0.1 alpha:0.9]];
	[window setDelegate:self];
	[window setAlphaValue:0];
	NSLog(@"%d, %d",(int)[window frame].origin.x, (int)[window frame].origin.y);
	
	
	
	cardWindows = [[NSMutableArray alloc] initWithCapacity:100]; 
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	[NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask 
										   handler:^(NSEvent *incomingEvent){		
											   if ([incomingEvent type] == NSKeyDown) {
												   
												   //NSLog(@"%d",[incomingEvent keyCode]);

												   if ([[incomingEvent charactersIgnoringModifiers] isEqualTo: @" "] 
													   && (0 != ([incomingEvent modifierFlags] & (NSCommandKeyMask | NSAlternateKeyMask)))
													   )
												   {
													   [NSApp activateIgnoringOtherApps:YES];
												   }
											   }											   
											   
										   }];
}

- (void) show:(BOOL)toShow {
	if (toShow)
	{
		if ([window alphaValue] < 0.5)
		{
			NSViewAnimation *theAnim;
			
			NSMutableDictionary* windowAttrDict = [NSMutableDictionary dictionaryWithCapacity:2];
			[windowAttrDict setObject:window forKey:NSViewAnimationTargetKey];
			[windowAttrDict setObject:NSViewAnimationFadeInEffect forKey:NSViewAnimationEffectKey];
			
			theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:windowAttrDict, nil]];
			[theAnim setDuration:0.3];    // One and a half seconds.
			[theAnim setAnimationCurve:NSAnimationEaseInOut];
			[theAnim startAnimation];
			
			
			[theAnim release];		
		}
	}
	else {
		NSViewAnimation *theAnim;
		
		NSMutableDictionary* windowAttrDict = [NSMutableDictionary dictionaryWithCapacity:2];
		[windowAttrDict setObject:window forKey:NSViewAnimationTargetKey];
		[windowAttrDict setObject:NSViewAnimationFadeOutEffect forKey:NSViewAnimationEffectKey];
		
		theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:windowAttrDict, nil]];
		[theAnim setDuration:0.5];    // One and a half seconds.
		[theAnim setAnimationCurve:NSAnimationEaseInOut];
		[theAnim startAnimation];
		
		
		[theAnim release];
	}

}


- (void) applicationDidBecomeActive:(NSNotification *)notification {
	[self show:YES];
}

- (void) applicationDidResignActive:(NSNotification *)notification{
	[self show:NO];
}

- (void)searchResultDidReturn:(NSArray *)entries ofType:(QDBEntryType)type{
	
	if ([entries count] > 0 && [cardWindows count] > 0) 
	{
		for (int i = 0; i < [cardWindows count];i++)
		{			
			[window removeChildWindow:[cardWindows objectAtIndex:i]];
			[(NSPanel *)[cardWindows objectAtIndex:i] close];
		}
		[cardWindows removeAllObjects];
		
	}
	
	//dispatch_queue_t myQueue = dispatch_queue_create("myQueue", NULL);
	dispatch_group_t myGroup = dispatch_group_create();
	
	for (int i = 0; i < [entries count]; i++)
	{
		
		dispatch_group_async(myGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
			
			NSDictionary *entry = (NSDictionary *)[entries objectAtIndex:i];
			
			NSRect windowRect = NSMakeRect([window frame].size.width / 2, 0, 300, 300);
			
			windowRect.origin = [window convertBaseToScreen:windowRect.origin];
			
			QuickDoubanCardWindow *cardWindow = [[QuickDoubanCardWindow alloc] initWithContentRect:windowRect 
															 styleMask:NSUtilityWindowMask | NSTexturedBackgroundWindowMask
															   backing:NSBackingStoreBuffered 
																 defer:NO
																  data:entry];
			[cardWindow setAlphaValue:0];
			[entry autorelease];
			
			[window addChildWindow:cardWindow ordered:NSWindowBelow];
			
			[[self cardWindows] addObject:cardWindow];
			
		});
	}
	
	//
	
	dispatch_group_notify( myGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSLog(@"%@", [window childWindows]);
		[self organizeChildWindows];
	});
	
}

- (void) organizeChildWindows
{	
	NSRect screenFrame = [[NSScreen mainScreen] frame];
	
	NSLog(@"Screen %d, %d", (int)screenFrame.size.width, (int)screenFrame.size.height);
	
	int cardSide = 300;
	int cardMargin = 30;
	int screenMargin = 50;
	int maxCardInRow = (int)((screenFrame.size.width - screenMargin * 2) / (cardMargin + cardSide));
	int maxCardInColumn = (int)(([window frame].origin.y - screenMargin * 2) / (cardMargin + cardSide));
	
	
	if ([cardWindows count] < maxCardInRow)
	{
		maxCardInRow = [cardWindows count];
	}
	
	int actualScreenMarginHorizontal = (screenFrame.size.width - maxCardInRow * cardSide - (maxCardInRow - 1) * cardMargin)/2;
	
	NSLog(@"%d card in row, %d card in column", maxCardInRow, maxCardInColumn);
	
	
	
	for (int i = 0; i < [cardWindows count];i++)
	{			
		QuickDoubanCardWindow *cardWindow = (QuickDoubanCardWindow *)[cardWindows objectAtIndex:i];
		
		NSLog(@"%@", cardWindow);
		NSRect newLocationFrame = NSMakeRect(actualScreenMarginHorizontal + (cardSide + cardMargin) * (int)(i % maxCardInRow), 
											 [window frame].origin.y - 30 - (cardSide + cardMargin) * ((int)(i / maxCardInRow) + 1), 
											 cardSide, 
											 cardSide);
		
		
		[cardWindow setFrameOrigin:newLocationFrame.origin];
		
		
		[cardWindow setAlphaValue:1.0];

		//[[cardWindow contentView] setFrame:NSMakeRect(0, 0, cardSide, cardSide)];
		
//		NSDictionary *windowResize;
//		windowResize = [NSDictionary dictionaryWithObjectsAndKeys:
//						cardWindow, NSViewAnimationTargetKey,
//						[NSValue valueWithRect: newLocationFrame], NSViewAnimationEndFrameKey,
//						nil];
		
//		NSDictionary *windowFade;
//		windowFade = [NSDictionary dictionaryWithObjectsAndKeys:
//					    cardWindow, NSViewAnimationTargetKey,
//						NSViewAnimationFadeInEffect, NSViewAnimationEffectKey,
//						nil];
//		
//		NSViewAnimation *theAnim;
//		theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:windowFade, nil]];
//		
//		[theAnim setAnimationBlockingMode: NSAnimationNonblocking];
//		[theAnim setDuration:0.3];
//		[theAnim setAnimationCurve:NSAnimationEaseInOut];
//		[theAnim startAnimation];
//		[theAnim release];	
		
	}
	
	
}

- (void)escapeKeyPressed{
	[self show:NO];
}

@end
