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
@synthesize cardImage;
@synthesize cardImageView;

- (void) setData:(NSDictionary *)data {
	
	[self setEntryData:data];
	
	url = [entryData objectForKey:@"link"];
	
	
	[QuickDoubanBase timer_start];
	
	NSString *titleText = [[entryData objectForKey:@"title"] objectForKey:@"$t"];
	[titleField setStringValue:titleText];	
	
	[progressIndicator startAnimation:self];

	dispatch_queue_t displayQueue = dispatch_queue_create("displayQueue", NULL);
	dispatch_group_t displayGroup = dispatch_group_create();
	
	
	dispatch_group_async(displayGroup, displayQueue, ^{
		NSString *imageUrlString = [(NSDictionary *)[url objectAtIndex:2] objectForKey:@"@href"];
		imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"/spic/" withString:@"/lpic/"];
		imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"default-small" withString:@"default-medium"];
		NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
		
		cardImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, [[self view] frame].size.width, [[self view] frame].size.height)];
		
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
	});
	
	
	dispatch_group_notify( displayGroup, displayQueue, ^{
		
		if (cardImage) {
			[[self view] addSubview:cardImageView positioned:NSWindowBelow relativeTo:titleField];	
			[cardImageView setImageScaling:NSScaleToFit];
			[progressIndicator stopAnimation:self];		
		}
	});
	
}

- (void) loadView {
	
	NSLog(@"QuickDoubanCardViewController start to load view");
	
	[super loadView];
	
	NSLog(@"QuickDoubanCardViewController loadView returned in %10.4lf seconds\n",[QuickDoubanBase timer_milePost]);
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
