//
//  HardBug.m
//  ProtectMyDinner
//
//  Created by Caidie on 12/1/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "HardBug.h"

@implementation HardBug

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"HardBug.png"];
        self.image = image;
        UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pangr];
    }
    return self;
}

- (void)pan: (UIPanGestureRecognizer *)recognizer
{
    if(self.hasEnteredGamePanel)
    {
        if((recognizer.state == UIGestureRecognizerStateChanged) ||
           (recognizer.state == UIGestureRecognizerStateEnded))
        {
            CGPoint translation = [recognizer translationInView:self];
            [self setCenter:CGPointMake(self.center.x+translation.x, self.center.y+translation.y)];
            
            if (!CGRectContainsRect(self.superview.bounds, self.frame))
            {
                [self.gameSoundPlayer play];
                [self removeFromSuperview];
            }
            
            [recognizer setTranslation:CGPointZero inView:self];
        }
    }
}

@end
