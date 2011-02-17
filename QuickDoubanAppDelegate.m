//
//  QuickDoubanAppDelegate.m
//  QuickDouban
//
//  Created by liangjie on 2011-02-16.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import "QuickDoubanAppDelegate.h"

@implementation QuickDoubanAppDelegate

@synthesize window;


- (void)awakeFromNib{
	NSLog(@"Awake From Nib");
	NSLog(@"Parsed some JSON: %@", [@"[1,2,3,true,false,null]" JSONValue]);

	[window setBackgroundColor:[NSColor colorWithDeviceRed:0.1 green:0.1 blue:0.1 alpha:0.9]];
	[window setDelegate:self];
	[window setAlphaValue:0];
	

	
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	[NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask 
										   handler:^(NSEvent *incomingEvent){		
											   if ([incomingEvent type] == NSKeyDown) {
												   
												   NSLog(@"%d",[incomingEvent keyCode]);

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

@end
