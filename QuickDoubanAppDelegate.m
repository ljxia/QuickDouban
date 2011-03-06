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
#import "QuickDoubanBase.h"
#include <dispatch/dispatch.h>


@implementation QuickDoubanAppDelegate

@synthesize window;
@synthesize searchController;
@synthesize cardWindows;
@synthesize cardSize;

- (void)awakeFromNib{
	searchController = [SearchBarWindowController sharedSearchBar];
	window = [searchController window];
	[window setBackgroundColor:[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:0.8]];
	[window setDelegate:self];
	[window setAlphaValue:0];
	
	
	[searchController setDelegate:self];
	
	[self determineBestCardSize];
	[searchController setPageSize:(cardNumInRow * cardNumInColumn)];
	[searchController setPageIndex:1];
	//NSLog(@"%d, %d",(int)[window frame].origin.x, (int)[window frame].origin.y);
	
	
	
	cardWindows = [[NSMutableArray alloc] initWithCapacity:100]; 
	
	[[searchController progressIndicator] setUsesThreadedAnimation:YES];
	
	
	
}


- (void)toggle {

	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[window makeKeyWindow];
	
	if ([window alphaValue] < 0.1)
	{
		[self show:YES];
	}
	else {
		[self show:NO];
	}
	
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	NSStatusItem *statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain]; //Create new status item instance
	[statusItem setHighlightMode:YES]; //This does something, I'm sure of it.
	//[statusItem setImage:[[NSImage alloc] initByReferencingFile:@"icon.png"]];
	[statusItem setTitle:@"Db"];
	[statusItem setTarget:self];
	[statusItem setEnabled:YES]; //Self explanatory
	[statusItem setAction:@selector(toggle)];
	
	
//	[NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask 
//										   handler:^(NSEvent *incomingEvent){		
//											   if ([incomingEvent type] == NSKeyDown) {
//												   
//												   //NSLog(@"%d",[incomingEvent keyCode]);
//
//												   if ([[incomingEvent charactersIgnoringModifiers] isEqualTo: @" "] 
//													   && (0 != ([incomingEvent modifierFlags] & (NSCommandKeyMask | NSAlternateKeyMask)))
//													   )
//												   {
//													   [NSApp activateIgnoringOtherApps:YES];
//												   }
//											   }											   
//											   
//										   }];
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
			
			
			for (int i = 0; i < [cardWindows count];i++)
			{
				[(NSWindow *)[cardWindows objectAtIndex:i] setAlphaValue:1];
			}
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
		
		for (int i = 0; i < [cardWindows count];i++)
		{
			[(NSWindow *)[cardWindows objectAtIndex:i] setAlphaValue:0];
		}
	}

}


- (void) applicationDidBecomeActive:(NSNotification *)notification {
	[self show:YES];
}

- (void) applicationDidResignActive:(NSNotification *)notification{
	[self show:NO];
}

- (void)searchResultDidReturn:(NSArray *)entries ofType:(QDBEntryType)type{
	
	[self clearCards];
	
	//dispatch_queue_t myQueue = dispatch_queue_create("myQueue", NULL);
	//dispatch_group_t myGroup = dispatch_group_create();
	
	
	NSLog(@"\n\n Search result returned with %d entries", [entries count]);
	
	for (int i = 0; i < [entries count]; i++)
	{
		
		//dispatch_group_async(myGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
			
			NSDictionary *entry = (NSDictionary *)[entries objectAtIndex:i];
		
			NSRect windowRect = NSMakeRect([window frame].size.width / 2, 0, cardSize.size.width, cardSize.size.width);
			
			windowRect.origin = [window convertBaseToScreen:windowRect.origin];

		    QuickDoubanCardWindow *cardWindow = [[QuickDoubanCardWindow alloc] initWithContentRect:windowRect 
															 styleMask:NSHUDWindowMask | NSUtilityWindowMask | NSBorderlessWindowMask 
															   backing:NSBackingStoreBuffered 
																 defer:YES];
			
			//[cardWindow retain];
		
			//NSLog(@"retain new card window");
		
			[cardWindow setBackgroundColor:[NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:0.6]];
			[cardWindow setAlphaValue:0];
			[cardWindow setAllowsConcurrentViewDrawing:YES];
			[cardWindow setReleasedWhenClosed:YES];
			
			[window addChildWindow:cardWindow ordered:NSWindowBelow];

			NSLog(@"new card window added to child windows\n\n");
			
			[cardWindows addObject:cardWindow];
			NSLog(@"new card window added to cardWindows array");

			NSLog(@"setting data");
			[cardWindow setData:[NSDictionary dictionaryWithDictionary:entry]];
			NSLog(@" --> data set");
		
			//
		
			//[self organizeChildWindows];
			
		//});
	}
	
	//
	
	//dispatch_group_notify( myGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		//NSLog(@"%@", [window childWindows]);
		[self organizeChildWindows];
		[[searchController progressIndicator] stopAnimation:searchController];
	//});
}

- (void) determineBestCardSize {
	NSRect screenFrame = [[NSScreen mainScreen] frame];
	NSLog(@"\n\nScreen %d, %d", (int)screenFrame.size.width, (int)screenFrame.size.height);
	
	int cardMargin = screenFrame.size.width > 1600 ? 25 : 15;
	int screenMargin = screenFrame.size.width > 1600 ? 40 : 30;
	int cardInRow = screenFrame.size.width > 1600 ? 8 : 6;
	int cardSide = (int)((screenFrame.size.width - screenMargin * 2) / cardInRow) - cardMargin;
	
	cardSize = NSMakeRect(0, 0, cardSide, cardSide);
	
	cardNumInRow = (int)((screenFrame.size.width - screenMargin * 2) / (cardMargin + cardSide));
	cardNumInColumn = (int)(([window frame].origin.y - screenMargin * 2) / (cardMargin + cardSide));
	
	NSLog(@"Card matrix %d x %d",cardNumInRow,cardNumInColumn);
}

- (void) organizeChildWindows
{	
	[QuickDoubanBase timer_start];
	NSRect screenFrame = [[NSScreen mainScreen] frame];
	
	//NSLog(@"\n\nScreen %d, %d", (int)screenFrame.size.width, (int)screenFrame.size.height);
	
	int cardSide = cardSize.size.width;
	int cardMargin = screenFrame.size.width > 1600 ? 25 : 15;
	int maxCardInRow = cardNumInRow;
	int maxCardInColumn = cardNumInColumn;
	
	if ([cardWindows count] < maxCardInRow)
	{
		maxCardInRow = [cardWindows count];
	}
	
	int actualScreenMarginHorizontal = (screenFrame.size.width - maxCardInRow * cardSide - (maxCardInRow - 1) * cardMargin)/2;
	
	NSLog(@"%d card in row, %d card in column", maxCardInRow, maxCardInColumn);
	
	
	
	for (int i = 0; i < [cardWindows count];i++)
	{			
		QuickDoubanCardWindow *cardWindow = (QuickDoubanCardWindow *)[cardWindows objectAtIndex:i];
		
		//NSLog(@"%@", cardWindow);
		NSRect newLocationFrame = NSMakeRect(actualScreenMarginHorizontal + (cardSide + cardMargin) * (int)(i % maxCardInRow), 
											 [window frame].origin.y - 30 - (cardSide + cardMargin) * ((int)(i / maxCardInRow) + 1), 
											 cardSide, 
											 cardSide);
		
		
		[cardWindow setFrameOrigin:newLocationFrame.origin];
		
		
		//[cardWindow setAlphaValue:1.0];

		[[cardWindow contentView] setFrame:NSMakeRect(0, 0, cardSide, cardSide)];
		
		NSWindow *windowIndexes[4];
		
		windowIndexes[QDBWindowUp] = nil;
		windowIndexes[QDBWindowDown] = nil;
		windowIndexes[QDBWindowLeft] = nil;
		windowIndexes[QDBWindowRight] = nil;
		
		
		if (i < maxCardInRow) {
			int j = i;
			while (j < ([cardWindows count] - 1)) {
				j += maxCardInRow;
			}
			if (j > ([cardWindows count] - 1)) {
				j -= maxCardInRow;
			}
			windowIndexes[QDBWindowUp] = (NSWindow *)[cardWindows objectAtIndex:j];
		}
		else {
			windowIndexes[QDBWindowUp] = (NSWindow *)[cardWindows objectAtIndex:(i - maxCardInRow)];
		}
		
		if ((i + maxCardInRow) > ([cardWindows count] - 1)) { 
			//last row 
			windowIndexes[QDBWindowDown] = (NSWindow *)[cardWindows objectAtIndex:(i % maxCardInRow)];
		}
		else {
			windowIndexes[QDBWindowDown] = (NSWindow *)[cardWindows objectAtIndex:(i + maxCardInRow)];
		}
		
		if (i == 0) {
			windowIndexes[QDBWindowLeft] = (NSWindow *)[cardWindows objectAtIndex:([cardWindows count] - 1)];
		}
		else {
			windowIndexes[QDBWindowLeft] = (NSWindow *)[cardWindows objectAtIndex:(i - 1)];
		}
		
		if (i == ([cardWindows count] - 1)) {
			windowIndexes[QDBWindowRight] = (NSWindow *)[cardWindows objectAtIndex:0];
		}
		else {
			windowIndexes[QDBWindowRight] = (NSWindow *)[cardWindows objectAtIndex:(i + 1)];
		}
		
		[cardWindow setAdjacentWindows:[NSArray arrayWithObjects:
											windowIndexes[QDBWindowUp],
											windowIndexes[QDBWindowDown],
											windowIndexes[QDBWindowLeft],
											windowIndexes[QDBWindowRight],nil]];
		
//		NSDictionary *windowResize;
//		windowResize = [NSDictionary dictionaryWithObjectsAndKeys:
//						cardWindow, NSViewAnimationTargetKey,
//						[NSValue valueWithRect: newLocationFrame], NSViewAnimationEndFrameKey,
//						nil];
		
		NSDictionary *windowFade;
		windowFade = [NSDictionary dictionaryWithObjectsAndKeys:
					    cardWindow, NSViewAnimationTargetKey,
						NSViewAnimationFadeInEffect, NSViewAnimationEffectKey,
						nil];
		
		NSViewAnimation *theAnim;
		theAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects: windowFade, nil]];
		
		[theAnim setAnimationBlockingMode: NSAnimationNonblockingThreaded];
		[theAnim setDuration:0.2];
		[theAnim setAnimationCurve:NSAnimationEaseInOut];
		[theAnim startAnimation];
		[theAnim release];	
		
		[cardWindow render];
		
	}
	
	NSLog(@"organizeChildWindows returned in %10.4lf seconds\n",[QuickDoubanBase timer_milePost]);
}

- (BOOL) clearCards {
	if ([cardWindows count] > 0) 
	{
		NSLog(@"\n\nCleaning out old window cards");
		for (int i = 0; i < [cardWindows count];i++)
		{
			QuickDoubanCardWindow *cardWindow = (QuickDoubanCardWindow *)[cardWindows objectAtIndex:i];
			[cardWindow detachAdjacentWindows];
			[window removeChildWindow:cardWindow];
			[cardWindow close];
		}
		[cardWindows removeAllObjects];
		return YES;
	}
	return NO;
}

- (void)escapeKeyPressed{
	
	if (![self clearCards])
	{
		[self toggle];
	}
}

- (void)arrayKeyPressed:(unichar)keyChar {
	if ( keyChar == NSLeftArrowFunctionKey ) {
		
		return;
	}
	if ( keyChar == NSRightArrowFunctionKey ) {
		
		return;
	}
	if ( keyChar == NSUpArrowFunctionKey ) {
		
		return;
	}
	if ( keyChar == NSDownArrowFunctionKey ) {
		//NSLog(@"received down array");
		
		if (cardWindows && [cardWindows count]) {
			[(NSWindow *)[cardWindows objectAtIndex:0] makeKeyWindow];
		}
		
		return;
	}
}

- (void) windowDidBecomeKey:(NSNotification *)notification {
	NSLog(@"Search bar became key window");
	[[searchController searchTextField] selectText:self];
}

@end
