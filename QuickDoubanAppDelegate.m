//
//  QuickDoubanAppDelegate.m
//  QuickDouban
//
//  Created by liangjie on 2011-02-16.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import "QuickDoubanAppDelegate.h"
//#import "MAAttachedWindow.h"
#import "QuickDoubanCardViewController.h"

@implementation QuickDoubanAppDelegate

@synthesize window;
@synthesize searchController;

- (void)awakeFromNib{
	NSLog(@"Awake From Nib");
	NSLog(@"Parsed some JSON: %@", [@"[1,2,3,true,false,null]" JSONValue]);

	[window setBackgroundColor:[NSColor colorWithDeviceRed:0.1 green:0.1 blue:0.1 alpha:0.9]];
	[window setDelegate:self];
	[window setAlphaValue:0];
	
	[searchController setDelegate:self];
	
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
	
	
	
	for (int i = 0; i < [entries count]; i++)
	{
		NSDictionary *entry = (NSDictionary *)[entries objectAtIndex:i];
		
		NSString *title = [[entry objectForKey:@"title"] objectForKey:@"$t"];
		NSArray *url = [entry objectForKey:@"link"];
		
		NSLog(@"%@",title);
		
		NSRect windowRect = NSMakeRect(0 + i * 220, -250 ,200,200);
		
		windowRect.origin = [window convertBaseToScreen:windowRect.origin];
		
		
		QuickDoubanCardViewController *cardController = [[QuickDoubanCardViewController alloc] initWithNibName:@"QuickDoubanCardView" bundle:nil];
		[cardController retain];
		
		NSPanel *cardWindow = [[NSPanel alloc] initWithContentRect:windowRect 
														   styleMask:NSHUDWindowMask | NSUtilityWindowMask
															 backing:NSBackingStoreBuffered 
															   defer:YES];
		
		//NSBorderlessWindowMask | NSClosableWindowMask
		
		[cardController setNextResponder:[cardWindow nextResponder]];
		[cardWindow setNextResponder:cardController];
		
		[cardWindow setContentView:[cardController view]];
		[[cardController title] setStringValue:title];
		[cardController setUrl:url];
		 
		[window addChildWindow:cardWindow ordered:NSWindowAbove];
		
		//NSPoint buttonPoint = NSMakePoint(0 + i * 300,0);
		
//        MAAttachedWindow *attachedWindow = [[MAAttachedWindow alloc] initWithView:floatView
//                                                attachedToPoint:buttonPoint 
//                                                       inWindow:window 
//                                                         onSide:MAPositionBottom 
//                                                     atDistance:0];
//		
//		[attachedWindow retain];
//		[attachedWindow setAlphaValue:0.8f];
//        [attachedWindow setBorderColor:[NSColor whiteColor]];
//        [attachedWindow setBackgroundColor:[NSColor blackColor]];
//        [attachedWindow setViewMargin:30];
//        [attachedWindow setBorderWidth:3];
//        [attachedWindow setCornerRadius:14];
//        [attachedWindow setHasArrow:NO];
//        [attachedWindow setDrawsRoundCornerBesideArrow:NO];
//        [attachedWindow setArrowBaseWidth:20];
//        [attachedWindow setArrowHeight:20];
//        
//        [window addChildWindow:attachedWindow ordered:NSWindowAbove];
	}
}

- (void)escapeKeyPressed{
	[self show:NO];
}

@end
