//
//  QuickDoubanCardWindowController.h
//  QuickDouban
//
//  Created by liangjie on 2011-03-02.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "QuickDoubanCardViewController.h"

@interface QuickDoubanCardWindow : NSPanel {
	QuickDoubanCardViewController *cardViewController;
}
@property (retain) QuickDoubanCardViewController *cardViewController;

- (QuickDoubanCardWindow *) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag data:(NSDictionary *)entryData;

@end
