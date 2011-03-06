//
//  QuickDoubanBase.h
//  QuickDouban
//
//  Created by liangjie on 2011-02-24.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSON.h"

typedef enum _QDBEntryType {
    QDBEntryTypeMovie       = 0, 
    QDBEntryTypeBook        = 1, 
    QDBEntryTypeMusic       = 2, 
    QDBEntryTypeMember      = 3, 
    QDBEntryTypeFollowee    = 4,
    QDBEntryTypeFollower    = 5,
    QDBEntryTypeGroup       = 6,
    QDBEntryTypeEvent       = 7,
    QDBEntryTypeAlbum       = 8,
    QDBEntryTypeList        = 9
} QDBEntryType;

typedef enum _QDBWindowRef {
    QDBWindowUp			= 0, 
    QDBWindowDown       = 1, 
    QDBWindowLeft      = 2, 
    QDBWindowRight     = 3
} QDBWindowRef;

@interface QuickDoubanBase : NSObject {
	
}

+ (void) timer_start;
+ (double) timer_milePost;

@end
