//
//  QuickDoubanBase.m
//  QuickDouban
//
//  Created by liangjie on 2011-03-04.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//
#import "QuickDoubanBase.h"
#include <mach/mach_time.h>

@implementation QuickDoubanBase

static uint64_t elapsed_time;

+ (void) timer_start {
	elapsed_time = mach_absolute_time();
}

+ (double) timer_milePost {
	static dispatch_once_t justOnce;
	static double scale;
	
	dispatch_once(&justOnce, ^{
		mach_timebase_info_data_t	tbi;
		mach_timebase_info(&tbi);
		scale = tbi.numer;
		scale = scale/tbi.denom;
		//NSLog(@"Scale is %10.4f  Just computed once courtesy of dispatch_once()\n", scale);
	});
	
	uint64_t now = mach_absolute_time()-elapsed_time;
	double	fTotalT = now;
	fTotalT = fTotalT * scale;			// convert this to nanoseconds...
	fTotalT = fTotalT / 1000000000.0;
	return fTotalT;
}

@end