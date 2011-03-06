//
//  QuickDoubanAppDelegate.h
//  QuickDouban
//
//  Created by liangjie on 2011-02-16.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSON.h"
#import "SearchBarWindowController.h"

@interface QuickDoubanAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, SearchControllerDelegate> {
    NSWindow *window;
	SearchBarWindowController *searchController;
//	IBOutlet NSView *floatView;
	NSMutableArray *cardWindows;
}

@property (assign) NSWindow *window;
@property (assign) IBOutlet SearchBarWindowController *searchController;
//
@property (retain) NSMutableArray *cardWindows;

- (void) show:(BOOL)toShow;
- (BOOL) clearCards;
- (void) organizeChildWindows;

@end
