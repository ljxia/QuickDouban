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
	IBOutlet NSTextField *titleField;
	IBOutlet IKImageView *cardImage;
	IBOutlet NSProgressIndicator *progressIndicator;
	
	NSDictionary *entryData;
	NSArray *url;
}

@property (retain) IBOutlet NSTextField *titleField;
@property (retain) IBOutlet IKImageView *cardImage;
@property (retain) IBOutlet NSProgressIndicator *progressIndicator;

@property (retain) NSArray *url;
@property (retain) NSDictionary *entryData;

- (id) initWithNibName:(NSString *)nibNameOrNil cardData:(NSDictionary *)data;
- (void) mouseUp:(NSEvent *)theEvent;

@end
