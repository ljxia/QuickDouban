//
//  SearchBarWindowController.m
//  QuickDouban
//
//  Created by liangjie on 2011-03-01.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import "SearchBarWindowController.h"
#import "BaseDoubanSearcher.h"

@implementation SearchBarWindowController

@synthesize delegate;

@synthesize searchTextField;
@synthesize searchResult;
@synthesize searchType;

@synthesize toggleBook;
@synthesize toggleMovie;
@synthesize toggleMusic;
@synthesize toggleButtons;

+ (SearchBarWindowController *) sharedSearchBar
{
    static SearchBarWindowController *g_searchBar;
	
    if (g_searchBar == nil) {
        g_searchBar = [[SearchBarWindowController alloc]
					   initWithWindowNibName: @"SearchBarWindowController"];
		
        assert (g_searchBar != nil); // or other error handling
		
        [g_searchBar showWindow: self];
		[g_searchBar setToggleButtons:[NSArray arrayWithObjects:[g_searchBar toggleMovie], [g_searchBar toggleBook], [g_searchBar toggleMusic], nil]];
		[g_searchBar setSearchType:QDBEntryTypeMovie];
		//NSLog(@"All Buttons: %@", [g_searchBar toggleButtons]);
    }
	
    return (g_searchBar);	
}

- (void) doSearch{
	NSLog(@"Search %@!", [searchTextField stringValue]);
	NSString *keyword = [searchTextField stringValue];
	BaseDoubanSearcher *searcher = [BaseDoubanSearcher initWithType:[self searchType]];

	dispatch_group_t taskGroup = dispatch_group_create();
	
	dispatch_group_async(taskGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		searchResult = [NSMutableDictionary dictionaryWithDictionary:[searcher query:keyword withParams:nil]];		
	});
	
	dispatch_group_notify(taskGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSArray *entries = [NSMutableArray arrayWithArray:[searchResult objectForKey:@"entry"]];
		
		//if (entries && [entries count])
		{
			[delegate searchResultDidReturn:entries ofType:QDBEntryTypeMovie];
		}
	});
	
	
}

- (IBAction)search:(id)sender {
	[self doSearch];
}

- (IBAction) toggleSearchType:(id)sender {
	
	//NSLog(@"sender: %@, with tag %d",sender, [(NSButton *)sender tag]);
	
	if ([sender isKindOfClass:[NSButton class]] && [toggleButtons indexOfObject:sender] >= 0)
	{
		NSButton *button = (NSButton *)sender;
		
		[self setSearchType:[button tag]];
		
		if ([button state] == NSOffState) {
			[button setState:NSOnState];
		}
		else {
			for	(int i = 0;i < [toggleButtons count];i++)
			{
				NSButton *oneButton = (NSButton *)[toggleButtons objectAtIndex:i];
				if (oneButton != sender && [oneButton state] == NSOnState) {
					[oneButton setState:NSOffState];
				}
			}
		}
		
	}
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
		//[self doSearch];
		int nextType = ((int)[self searchType] + 1) % [toggleButtons count];
		NSLog(@"%d",nextType);
		NSButton *nextButton = (NSButton *)[toggleButtons objectAtIndex:nextType];
		[nextButton setNextState];
		[self toggleSearchType:nextButton];
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
