//
//  QuickDoubanCardViewController.h
//  QuickDouban
//
//  Created by liangjie on 2011-02-25.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OverlayView.h"

@interface QuickDoubanCardViewController : NSViewController <NSImageDelegate> {
	IBOutlet NSTextField *titleField;
	IBOutlet NSProgressIndicator *progressIndicator;
	
	IBOutlet OverlayView *overlayView;
	
	NSImageView *cardImageView;
	NSImage *cardImage;
	NSDictionary *entryData;
	NSArray *url;
}

@property (retain) IBOutlet OverlayView *overlayView;
@property (retain) IBOutlet NSTextField *titleField;
@property (retain) IBOutlet NSProgressIndicator *progressIndicator;
@property (retain) NSImageView *cardImageView;
@property (retain) NSImage *cardImage;


@property (retain) NSArray *url;
@property (retain) NSDictionary *entryData;

- (void) setData:(NSDictionary *)data;

#pragma mark delegates
- (void) mouseUp:(NSEvent *)theEvent;

@end
