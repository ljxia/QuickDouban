//
//  SearchBarWindowController.m
//  QuickDouban
//
//  Created by liangjie on 2011-03-01.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import "SearchBarWindowController.h"


@implementation SearchBarWindowController
@synthesize delegate;

+ (SearchBarWindowController *) sharedSearchBar
{
    static SearchBarWindowController *g_searchBar;
	
    if (g_searchBar == nil) {
        g_searchBar = [[SearchBarWindowController alloc]
					   initWithWindowNibName: @"SearchBarWindowController"];
		
        assert (g_searchBar != nil); // or other error handling
		
        [g_searchBar showWindow: self];
    }
	
    return (g_searchBar);	
}

- (void) doSearch{
	NSLog(@"Search %@!", [searchTextField stringValue]);
	NSString *keyword = [searchTextField stringValue];
	
	keyword = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *url = [NSString stringWithFormat:@"http://api.douban.com/music/subjects?q=%@&alt=json&max-results=21",keyword];
	RestService *restRequest = [[RestService alloc] init];	
	NSHTTPURLResponse * response = [[NSHTTPURLResponse alloc] init];
	NSString *responseText = [restRequest requestToURL:url response:&response];
	
	NSDictionary *searchResult = [responseText JSONValue];
	
	//NSLog(@"%@", searchResult);
	
	NSArray *entries = (NSArray *)[searchResult objectForKey:@"entry"];
	
	if (entries && [entries count])
	{
		[delegate searchResultDidReturn:entries ofType:QDBEntryTypeMovie];
	}
}

- (IBAction)search:(id)sender {
	[self doSearch];
}


- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;
	
    if (commandSelector == @selector(insertNewline:))
    {
		[self doSearch];
        result = YES;
    }
    else if (commandSelector == @selector(insertTab:))
    {
		[self doSearch];
        result = YES;
    }
	else if (commandSelector == @selector(cancelOperation:))
	{
		// TODO: refactor
		//[(QuickDoubanAppDelegate *)[[NSApplication sharedApplication] delegate] show:NO];
		
		[delegate escapeKeyPressed];
		result = YES;
	}
	
    return result;
}

@end