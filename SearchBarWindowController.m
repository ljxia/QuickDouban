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

@synthesize progressIndicator;

@synthesize toggleBook;
@synthesize toggleMovie;
@synthesize toggleMusic;
@synthesize toggleButtons;

@synthesize pageSize;
@synthesize pageIndex;
@synthesize lastQuery;

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
		[g_searchBar setLastQuery:@""];
		//NSLog(@"All Buttons: %@", [g_searchBar toggleButtons]);
    }
	
    return (g_searchBar);	
}

- (void) doSearch{
	NSLog(@"Search %@!", [searchTextField stringValue]);
	NSString *keyword = [searchTextField stringValue];
	
	BaseDoubanSearcher *searcher = [BaseDoubanSearcher initWithType:[self searchType]];
	
	
	[[self progressIndicator] startAnimation:self];
	
	dispatch_group_t taskGroup = dispatch_group_create();

	dispatch_group_async(taskGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		if (![keyword isEqualToString:lastQuery] || searchType != lastQueryType) {
			pageIndex = 1;
		}
		
		
		NSDictionary *searchParam = [NSDictionary dictionaryWithObjectsAndKeys:
									 [NSString stringWithFormat:@"%d", pageSize],@"pageSize",
									 [NSString stringWithFormat:@"%d", pageIndex],@"pageIndex",nil];
		
		[self setLastQuery:keyword];
		lastQueryType = searchType;
		
		searchResult = [NSMutableDictionary dictionaryWithDictionary:[searcher query:keyword withParams:searchParam]];		
	});
	
	dispatch_group_notify(taskGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSArray *entries = [NSArray arrayWithArray:[searchResult objectForKey:@"entry"]];
		
		if (entries/* && [entries count] */)
		{
			[delegate searchResultDidReturn:entries ofType:QDBEntryTypeMovie];
		}
		
		
		int totalResult = [(NSString *)[(NSDictionary *)[searchResult objectForKey:@"opensearch:totalResults"] objectForKey:@"$t"] intValue];
		if (totalResult > pageSize * pageIndex) {
			pageIndex += pageSize;
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

- (void) keyUp:(NSEvent *)theEvent {
	if ([theEvent modifierFlags] & NSNumericPadKeyMask) { // arrow keys have this mask
        NSString *theArrow = [theEvent charactersIgnoringModifiers];
        unichar keyChar = 0;
        if ( [theArrow length] == 0 )
            return;            // reject dead keys
        if ( [theArrow length] == 1 ) {
            keyChar = [theArrow characterAtIndex:0];
            if ( keyChar == NSLeftArrowFunctionKey ) {
				[delegate arrayKeyPressed:keyChar];
                return;
            }
            if ( keyChar == NSRightArrowFunctionKey ) {
				[delegate arrayKeyPressed:keyChar];
                return;
            }
            if ( keyChar == NSUpArrowFunctionKey ) {
				[delegate arrayKeyPressed:keyChar];
                return;
            }
            if ( keyChar == NSDownArrowFunctionKey ) {
				[delegate arrayKeyPressed:keyChar];
                return;
            }
            //[super keyDown:theEvent];
        }
    }
    //[super keyDown:theEvent];
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
		//NSLog(@"%d",nextType);
		NSButton *nextButton = (NSButton *)[toggleButtons objectAtIndex:nextType];
		[nextButton setNextState];
		[self toggleSearchType:nextButton];
        result = YES;
    }
	else if (commandSelector == @selector(cancelOperation:))
	{
		[delegate escapeKeyPressed];
		result = YES;
	}
	
    return result;
}

- (BOOL) canBecomeKeyWindow {
	return YES;
}

@end
