//
//  BugView.m
//  ProtectMyDinner
//
//  Created by Caidie on 12/3/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "BugView.h"

@implementation BugView

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.image drawInRect:self.bounds];
}

@end
