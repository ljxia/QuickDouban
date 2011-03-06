//
//  QuickDoubanCardViewController.h
//  QuickDouban
//
//  Created by liangjie on 2011-02-25.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OverlayView.h"
#import "SearchBarWindowController.h"

@interface QuickDoubanCardViewController : NSViewController <NSImageDelegate> {
	IBOutlet NSTextField *titleField;
	IBOutlet NSProgressIndicator *progressIndicator;
	
	IBOutlet OverlayView *overlayView;
	
	NSImageView *cardImageView;
	NSImage *cardImage;
	NSDictionary *entryData;
	NSArray *url;
	
	BOOL active;
}

@property (retain) IBOutlet OverlayView *overlayView;
@property (retain) IBOutlet NSTextField *titleField;
@property (retain) IBOutlet NSProgressIndicator *progressIndicator;
@property (retain) NSImageView *cardImageView;
@property (retain) NSImage *cardImage;


@property (retain) NSArray *url;
@property (retain) NSDictionary *entryData;

@property BOOL active;

- (void) setData:(NSDictionary *)data;
- (void) makeActive:(BOOL) isActive;
- (void) openInBrowser;

#pragma mark delegates
- (void) mouseUp:(NSEvent *)theEvent;

#pragma mark IBAction

@end
