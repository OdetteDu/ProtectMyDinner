//
//  NormalBug.m
//  ProtectMyDinner
//
//  Created by Caidie on 12/1/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "NormalBug.h"

@implementation NormalBug

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"bug.png"];
        self.image = image;
        UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapgr];
    }
    return self;
}

- (void)tap: (UITapGestureRecognizer *)recognizer
{
    if(self.hasEnteredGamePanel)
    {
        if(recognizer.state == UIGestureRecognizerStateEnded)
        {
            [self removeFromSuperview];
        }
    }
}


@end
