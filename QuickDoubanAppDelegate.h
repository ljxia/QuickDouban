//
//  QuickDoubanAppDelegate.h
//  QuickDouban
//
//  Created by liangjie on 2011-02-16.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSON.h"

@interface QuickDoubanAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

- (void) show:(BOOL)toShow;

@end
