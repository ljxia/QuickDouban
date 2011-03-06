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

@interface SearchBarWindowController : NSWindowController <NSWindowDelegate> {
	id <SearchControllerDelegate> delegate;
	IBOutlet NSTextField *searchTextField;
	IBOutlet NSButton *toggleBook;
	IBOutlet NSButton *toggleMusic;
	IBOutlet NSButton *toggleMovie;
	
	IBOutlet NSProgressIndicator *progressIndicator;
	
	QDBEntryType searchType;
	NSMutableDictionary *searchResult;
	NSArray *toggleButtons;
}

@property (nonatomic, assign) IBOutlet NSTextField *searchTextField;
@property (nonatomic, assign) IBOutlet NSButton *toggleBook;
@property (nonatomic, assign) IBOutlet NSButton *toggleMusic;
@property (nonatomic, assign) IBOutlet NSButton *toggleMovie;
@property (retain) NSArray *toggleButtons;

@property (retain) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic, assign) id <SearchControllerDelegate> delegate;
@property (assign) NSMutableDictionary *searchResult;

@property QDBEntryType searchType;

+ (SearchBarWindowController *) sharedSearchBar;

- (IBAction) search:(id)sender;
- (IBAction) toggleSearchType:(id)sender;
- (void) doSearch;

@end

@protocol SearchControllerDelegate

- (void)searchResultDidReturn:(NSArray *)entries ofType:(QDBEntryType)type;
- (void)escapeKeyPressed;
- (void)arrayKeyPressed:(unichar)keyChar;

@end