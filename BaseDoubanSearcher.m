//
//  BaseDoubanSearcher.m
//  QuickDouban
//
//  Created by liangjie on 2011-02-19.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import "BaseDoubanSearcher.h"
#import "RestService.h"

@implementation BaseDoubanSearcher

@synthesize entryType;

+ (BaseDoubanSearcher *)initWithType:(QDBEntryType)searchType{
	BaseDoubanSearcher *searcher = [[BaseDoubanSearcher alloc] init];
	[searcher setEntryType:searchType];
	return searcher;
}
- (NSString *) constructURL: (NSString *) keyword withItems:(int)itemCount startingFrom:(int)startIndex{
	keyword = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	NSString *component;
	switch ([self entryType]) {
		case QDBEntryTypeMovie:
			component = @"movie";
			break;
		case QDBEntryTypeMusic:
			component = @"music";
			break;
		case QDBEntryTypeBook:
			component = @"book";
			break;
		default:
			component = @"";
			break;
	}
	
	NSString *url = [NSString stringWithFormat:@"http://api.douban.com/%@/subjects?q=%@&alt=json&max-results=%d&start-index=%d",component, keyword, itemCount, startIndex];
	return url;
}
- (NSDictionary *) query: (NSString *) keyword withParams: (NSDictionary *)params{
	
	NSString *url = [self constructURL:keyword withItems:21 startingFrom:1];
	RestService *restRequest = [[RestService alloc] init];	
	NSHTTPURLResponse * response = [[NSHTTPURLResponse alloc] init];
	NSString *responseText = [restRequest requestToURL:url response:&response];
	
	NSDictionary *searchResult = [responseText JSONValue];
	return searchResult;
}

@end
