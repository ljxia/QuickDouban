//
//  OverlayView.m
//  QuickDouban
//
//  Created by liangjie on 2011-03-05.
//  Copyright 2011 Feed Our Cats. All rights reserved.
//

#import "OverlayView.h"


@implementation OverlayView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	// Fill in background Color
    CGContextRef context = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBFillColor(context, 0,0,0,0.7);
    CGContextFillRect(context, NSRectToCGRect(dirtyRect));
}

@end
