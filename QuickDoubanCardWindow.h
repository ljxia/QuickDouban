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
	NSDictionary *entryData;
}
@property (retain) QuickDoubanCardViewController *cardViewController;
@property (retain) NSDictionary *entryData;

- (void) setData:(NSDictionary *)data;
- (void) render;
@end
