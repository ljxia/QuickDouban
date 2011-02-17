//
//  SearchController.h
//  QuickDouban
//
//  Created by liangjie on 2011-02-16.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SearchController : NSObjectController <NSTextFieldDelegate> {
	IBOutlet NSTextField *searchTextField;
}

- (IBAction)search:(id)sender;

- (void) doSearch;

@end
