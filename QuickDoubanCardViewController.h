//
//  QuickDoubanCardViewController.h
//  QuickDouban
//
//  Created by liangjie on 2011-02-25.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface QuickDoubanCardViewController : NSViewController {
	IBOutlet NSTextField *title;
	IBOutlet IKImageView *cardImage;
	
	NSArray *url;
}

@property (retain) IBOutlet NSTextField *title;
@property (retain) IBOutlet IKImageView *cardImage;
@property (retain) NSArray *url;

- (void) mouseUp:(NSEvent *)theEvent;

@end
