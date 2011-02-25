//
//  QuickDoubanAppDelegate.h
//  QuickDouban
//
//  Created by liangjie on 2011-02-16.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSON.h"
#import "SearchController.h"

@interface QuickDoubanAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, SearchControllerDelegate> {
    NSWindow *window;
	SearchController *searchController;
	IBOutlet NSView *floatView;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SearchController *searchController;

- (void) show:(BOOL)toShow;

@end
