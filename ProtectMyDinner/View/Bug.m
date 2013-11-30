//
//  Bug.m
//  ProtectMyDinner
//
//  Created by Caidie on 11/29/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "Bug.h"

@implementation Bug

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"bug.png"];
        self.image = image;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pangr];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.image drawInRect:self.bounds];
}

- (void)pan: (UIPanGestureRecognizer *)recognizer
{
    if((recognizer.state == UIGestureRecognizerStateChanged) ||
       (recognizer.state == UIGestureRecognizerStateEnded))
    {
        CGPoint translation = [recognizer translationInView:self];
        [self setCenter:CGPointMake(self.center.x+translation.x, self.center.y+translation.y)];
        
        if([self isOutOfBounds])
        {
            [self removeFromSuperview];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

- (BOOL)isOutOfBounds
{
    if(self.frame.origin.x < self.superview.bounds.origin.x || self.frame.origin.x + self.frame.size.width > self.superview.bounds.origin.y + self.superview.bounds.size.width)
    {
        return YES;
    }
    
    if(self.frame.origin.y < self.superview.bounds.origin.y || self.frame.origin.y + self.frame.size.height > self.superview.bounds.origin.y + self.superview.bounds.size.height)
    {
        return YES;
    }
    
    return NO;
}

@end
