//
//  QuickDoubanCardViewController.m
//  QuickDouban
//
//  Created by liangjie on 2011-02-25.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import "QuickDoubanCardViewController.h"
#import "QuickDoubanBase.h"

@implementation QuickDoubanCardViewController

@synthesize entryData;
@synthesize titleField;
@synthesize progressIndicator;

@synthesize url;
//@synthesize cardImage;

- (id) initWithNibName:(NSString *)nibNameOrNil cardData:(NSDictionary *)data {
	
	[QuickDoubanBase timer_start];
	
	[super initWithNibName:nibNameOrNil bundle:nil];
	
	[data retain];

	[self setEntryData:[NSDictionary dictionaryWithDictionary:data]];
	
	url = [entryData objectForKey:@"link"];
	
	[progressIndicator setUsesThreadedAnimation:YES];
	
	
//	
//	NSRect windowRect = NSMakeRect([window frame].size.width / 2, 0, 300, 300);
//	
//	windowRect.origin = [window convertBaseToScreen:windowRect.origin];
//	
//	
//	QuickDoubanCardViewController *cardController = [[QuickDoubanCardViewController alloc] initWithNibName:@"QuickDoubanCardView" bundle:nil];
//	[cardController retain];
//	
//	NSPanel *cardWindow = [[NSPanel alloc] initWithContentRect:windowRect 
//													 styleMask:NSClosableWindowMask | NSHUDWindowMask
//													   backing:NSBackingStoreBuffered 
//														 defer:YES];
//	
//	//NSBorderlessWindowMask | NSClosableWindowMask
//	
//	[cardController setNextResponder:[cardWindow nextResponder]];
//	[cardWindow setNextResponder:cardController];
//	
//	[cardWindow setContentView:[cardController view]];
//	[cardWindow setReleasedWhenClosed:YES];
//	[cardWindow setAlphaValue:0];
//	
//	NSString *imageUrlString = [(NSDictionary *)[url objectAtIndex:2] objectForKey:@"@href"];
//	imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"/spic/" withString:@"/lpic/"];
//	imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"default-small" withString:@"default-medium	"];
//	NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
//	[[cardController cardImage] setImageWithURL:imageUrl];
//	[[cardController cardImage] zoomImageToFit:nil];
//	NSLog(@"%@",imageUrl);
//	[imageUrl release];
//	
	
	
	
	//NSString *titleText = [[entryData objectForKey:@"title"] objectForKey:@"$t"];
	//NSLog(@"%@",titleText);
	//[titleField setStringValue:titleText];
	
//	
	
	NSLog(@"QuickDoubanCardViewController initWithNibName returned in %10.4lf seconds\n",[QuickDoubanBase timer_milePost]);
	return self;
}

- (void) setView:(NSView *)view{
	[QuickDoubanBase timer_start];
	
	[super setView:view];
	
	NSString *titleText = [[entryData objectForKey:@"title"] objectForKey:@"$t"];
	NSLog(@"%@",titleText);
	[titleField setStringValue:titleText];	
	
	[progressIndicator startAnimation:self];
	
	NSLog(@"QuickDoubanCardViewController setView returned in %10.4lf seconds\n",[QuickDoubanBase timer_milePost]);
}

- (void) mouseUp:(NSEvent *)theEvent{
	if ([theEvent clickCount] >= 2) {
		NSString *entryUrl = [(NSDictionary *)[url objectAtIndex:1] objectForKey:@"@href"];
		NSLog(@"%@", entryUrl);
		[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:entryUrl]];
		[entryUrl release];
		
		
	}
}

@end
