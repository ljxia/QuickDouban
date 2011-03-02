//
//  BaseDoubanSearcher.h
//  QuickDouban
//
//  Created by liangjie on 2011-02-19.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSON.h"
#import "QuickDoubanBase.h"

@interface BaseDoubanSearcher : NSObject {
	QDBEntryType entryType;
}
@property QDBEntryType entryType;

+ (BaseDoubanSearcher *)initWithType:(QDBEntryType)searchType;
- (NSString *) constructURL: (NSString *) keyword withItems:(int)itemCount startingFrom:(int)startIndex;
- (NSDictionary *) query: (NSString *) keyword withParams: (NSDictionary *)params;

@end
