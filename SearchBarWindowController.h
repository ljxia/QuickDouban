//
//  SearchBarWindowController.h
//  QuickDouban
//
//  Created by liangjie on 2011-03-01.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RestService.h"
#import "QuickDoubanBase.h"

@protocol SearchControllerDelegate;

@interface SearchBarWindowController : NSWindowController {
	id <SearchControllerDelegate> delegate;
	IBOutlet NSTextField *searchTextField;
	
	NSMutableDictionary *searchResult;
}

@property (nonatomic, assign) id <SearchControllerDelegate> delegate;
@property (assign) NSMutableDictionary *searchResult;

+ (SearchBarWindowController *) sharedSearchBar;
- (IBAction)search:(id)sender;
- (void) doSearch;

@end

@protocol SearchControllerDelegate

- (void)searchResultDidReturn:(NSArray *)entries ofType:(QDBEntryType)type;
- (void)escapeKeyPressed;

@end