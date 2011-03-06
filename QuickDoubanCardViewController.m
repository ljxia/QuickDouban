//
//  QuickDoubanCardViewController.m
//  QuickDouban
//
//  Created by liangjie on 2011-02-25.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import "QuickDoubanCardViewController.h"
#import "QuickDoubanBase.h"
#import "QuickDoubanCardWindow.h"

@implementation QuickDoubanCardViewController

@synthesize entryData;
@synthesize titleField;
@synthesize progressIndicator;

@synthesize url;
@synthesize cardImage;
@synthesize cardImageView;
@synthesize overlayView;

@synthesize active;

- (void) setData:(NSDictionary *)data {
	
	[self setEntryData:data];
	
	url = [entryData objectForKey:@"link"];
	
	[QuickDoubanBase timer_start];
	
	NSString *titleText = [[entryData objectForKey:@"title"] objectForKey:@"$t"];
	[titleField setStringValue:titleText];	

	dispatch_queue_t displayQueue = dispatch_queue_create("displayQueue", NULL);
	dispatch_group_t displayGroup = dispatch_group_create();
	
	
	dispatch_group_async(displayGroup, displayQueue, ^{
		NSString *imageUrlString = [(NSDictionary *)[url objectAtIndex:2] objectForKey:@"@href"];
		imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"/spic/" withString:@"/lpic/"];
		//imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"default-small" withString:@"default-medium"];
		
		NSRange rangeOfPlaceholder = [imageUrlString rangeOfString:@"default-small"];
		if (rangeOfPlaceholder.location == NSNotFound) {
			
			[progressIndicator startAnimation:self];
			
			NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
			
			cardImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, [[self view] frame].size.width + 1, [[self view] frame].size.height + 1)];
			
			NSLog(@"Starting to load %@",imageUrlString);
			
			@try {
				cardImage = [[NSImage alloc] initWithContentsOfURL:imageUrl];
				[cardImage setDelegate:self];
				[cardImageView setImage:cardImage];
			}
			@catch (NSException * e) {
				NSLog(@"Exception %@", e);
			}
			@finally {
				//[imageUrl autorelease];
			}
		}
		else {
			cardImageView = nil;
			cardImage = nil;
			[overlayView setAlphaValue:0.5];
		}


	});
	
	
	dispatch_group_notify( displayGroup, displayQueue, ^{
		
		if (cardImage) {
			float aspectRatio = [cardImage size].width / [cardImage size].height;
			NSRect newImageFrame;
			if (aspectRatio > 1) { 
				//landscape
				float newWidth = [[self view] frame].size.height * aspectRatio;
				newImageFrame = NSMakeRect(-(newWidth - [[self view] frame].size.width)/2, 0, newWidth, [[self view] frame].size.height);
			}
			else {
				//portrait
				float newHeight = [[self view] frame].size.width / aspectRatio;
				newImageFrame = NSMakeRect(0, -(newHeight - [[self view] frame].size.height)/2, [[self view] frame].size.width, newHeight);
			}

			[cardImageView setFrame:newImageFrame];
			[cardImageView setImageScaling:NSScaleToFit];
			[[[self view] animator] addSubview:cardImageView positioned:NSWindowBelow relativeTo:overlayView];
			
			[progressIndicator stopAnimation:self];		
			
			[overlayView setAlphaValue:0];
		}
	});
	
}

- (void) loadView {
	
	NSLog(@"QuickDoubanCardViewController start to load view");
	
	[super loadView];
	[overlayView setFrame:NSMakeRect(0, 0, [[self view] frame].size.width + 1, [[self view] frame].size.height + 1)];
	[overlayView setAlphaValue:0.5];
	
	
	NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:[overlayView frame]
																options:NSTrackingActiveInActiveApp | NSTrackingMouseEnteredAndExited 
																  owner:self 
															   userInfo:nil];
	[[self view] addTrackingArea:trackingArea];
	
	NSLog(@"QuickDoubanCardViewController loadView returned in %10.4lf seconds\n",[QuickDoubanBase timer_milePost]);
}

- (void) mouseUp:(NSEvent *)theEvent{
	if ([theEvent clickCount] >= 2) {
		[self openInBrowser];
	}
	else if ([theEvent clickCount] == 1){
		//[[[self view] window] makeKeyWindow];
		//NSLog(@"Main window: %@", [[NSApplication sharedApplication] keyWindow]);
	}
}

- (void) openInBrowser {
	NSString *entryUrl = [(NSDictionary *)[url objectAtIndex:1] objectForKey:@"@href"];
	NSLog(@"%@", entryUrl);
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:entryUrl]];
	[entryUrl release];
}

- (void) makeActive:(BOOL) isActive {
	[self setActive:isActive];
	
	if (isActive)
	{
		//NSLog(@"Activate View %@", [self view]);
		[[overlayView animator] setAlphaValue:1];
		//[overlayView setAlphaValue:1];
	}
	else {
		//NSLog(@"Deactivate View %@", [self view]);
		if (!cardImage) {
			[[overlayView animator] setAlphaValue:0.5];
			//[overlayView setAlphaValue:0.5];
		}
		else {
			[[overlayView animator] setAlphaValue:0];
			//[overlayView setAlphaValue:0];
		}
	}

}

- (void)mouseEntered:(NSEvent *)theEvent {
	//NSLog(@"mouse entering card");
	[[[self view] window] makeKeyWindow];
}

- (void)mouseExited:(NSEvent *)theEvent {
	//NSLog(@"mouse leaving card");
}

- (void) keyUp:(NSEvent *)theEvent {

	if ([theEvent keyCode] == 53)
	{
		[[[SearchBarWindowController sharedSearchBar] window] makeKeyWindow];
	}
}

- (void) keyDown:(NSEvent *)theEvent {

	if ([theEvent modifierFlags] & NSNumericPadKeyMask) { // arrow keys have this mask
        NSString *theArrow = [theEvent charactersIgnoringModifiers];
        unichar keyChar = 0;
        if ( [theArrow length] == 0 )
            return;            // reject dead keys
        if ( [theArrow length] == 1 ) {
            keyChar = [theArrow characterAtIndex:0];
			
			NSArray *adjacentWindows = [(QuickDoubanCardWindow *)[[self view] window] adjacentWindows];
			
			if (!adjacentWindows || [adjacentWindows count] < 4)
			{
				return;
			}
			
            if ( keyChar == NSLeftArrowFunctionKey ) {
                //NSLog(@"left");
				//[[[self view] window] invalidateCursorRectsForView:self];
				
				QuickDoubanCardWindow *window = (QuickDoubanCardWindow *)[adjacentWindows objectAtIndex:QDBWindowLeft];
				if (window) {
					[window makeKeyWindow];
				}
                return;
            }
            if ( keyChar == NSRightArrowFunctionKey ) {
                //NSLog(@"right");
                //[[[self view] window] invalidateCursorRectsForView:self];
				
				QuickDoubanCardWindow *window = (QuickDoubanCardWindow *)[adjacentWindows objectAtIndex:QDBWindowRight];
				if (window) {
					[window makeKeyWindow];
				}
                return;
            }
            if ( keyChar == NSUpArrowFunctionKey ) {
                //NSLog(@"up");
                //[[[self view] window] invalidateCursorRectsForView:self];
				
				QuickDoubanCardWindow *window = (QuickDoubanCardWindow *)[adjacentWindows objectAtIndex:QDBWindowUp];
				if (window) {
					[window makeKeyWindow];
				}
                return;
            }
            if ( keyChar == NSDownArrowFunctionKey ) {
                //NSLog(@"down");
                //[[[self view] window] invalidateCursorRectsForView:self];
				
				QuickDoubanCardWindow *window = (QuickDoubanCardWindow *)[adjacentWindows objectAtIndex:QDBWindowDown];
				if (window) {
					[window makeKeyWindow];
				}
                return;
            }
            //[super keyDown:theEvent];
        }
    }
	else {
		NSString *keyCode = [theEvent charactersIgnoringModifiers];
		if ([keyCode length] == 1 && [keyCode characterAtIndex:0] == 13) {//ENTER
			[self openInBrowser];
			return;
		}
	}
	
    //[super keyDown:theEvent];
}

@end
