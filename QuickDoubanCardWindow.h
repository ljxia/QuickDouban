//
//  QuickDoubanCardWindowController.h
//  QuickDouban
//
//  Created by liangjie on 2011-03-02.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QuickDoubanCardViewController.h"

@interface QuickDoubanCardWindow : NSPanel <NSWindowDelegate> {
	QuickDoubanCardViewController *cardViewController;
	NSDictionary *entryData;
	
	BOOL active;
	NSArray *adjacentWindows;
}

@property (retain) QuickDoubanCardViewController *cardViewController;
@property (retain) NSDictionary *entryData;
@property (retain) NSArray *adjacentWindows;

@property BOOL active;

- (void) setData:(NSDictionary *)data;
- (void) makeActive:(BOOL) isActive;
- (void) render;
- (void) detachAdjacentWindows;
@end
