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

- (id) initWithNibName:(NSString *)nibNameOrNil cardData:(NSDictionary *)data {
	
	[QuickDoubanBase timer_start];
	
	[super initWithNibName:nibNameOrNil bundle:nil];
	
	[data retain];

	[self setEntryData:[NSDictionary dictionaryWithDictionary:data]];
	
	url = [entryData objectForKey:@"link"];
	
	[progressIndicator setUsesThreadedAnimation:YES];
	
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
	
	dispatch_queue_t displayQueue = dispatch_queue_create("displayQueue", NULL);
	dispatch_group_t displayGroup = dispatch_group_create();
	
	
	dispatch_group_async(displayGroup, displayQueue, ^{
		
		
		NSString *imageUrlString = [(NSDictionary *)[url objectAtIndex:2] objectForKey:@"@href"];
		imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"/spic/" withString:@"/lpic/"];
		imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"default-small" withString:@"default-medium"];
		NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
		
		cardImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, [view frame].size.width, [view frame].size.height)];
		
		NSLog(@"Starting to load %@",imageUrlString);
		
		cardImage = [[NSImage alloc] initWithContentsOfURL:imageUrl];
		
		if (cardImage) {
			NSLog(@"--- Image loaded %@",cardImage);
			[cardImage setDelegate:self];
			[cardImageView setImage:cardImage];
		}
		
		[imageUrl release];
		
	});
	
	
	dispatch_group_notify( displayGroup, displayQueue, ^{
		
		if (cardImage) {
			[[self view] addSubview:cardImageView positioned:NSWindowBelow relativeTo:titleField];	
			[cardImageView setImageScaling:NSScaleToFit];
			[progressIndicator stopAnimation:self];			
		}
	});
	
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
