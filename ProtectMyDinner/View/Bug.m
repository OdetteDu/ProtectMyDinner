//
//  Bug.m
//  ProtectMyDinner
//
//  Created by Caidie on 11/29/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "Bug.h"
#import "BugView.h"

@interface Bug()
@property (strong, nonatomic) BugView *bugView;
@end

@implementation Bug

- (BugView *)bugView
{
    if(!_bugView) _bugView = [[BugView alloc] initWithFrame:self.bounds];
    return _bugView;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.bugView.image = image;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        [self addSubview:self.bugView];
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    [self.image drawInRect:self.bounds];
//}

- (void)rotateTowardsCenter: (CGPoint)center
{
    CGFloat deltaX = self.center.x - center.x;
    CGFloat deltaY = self.center.y - center.y;
    CGFloat hypo = sqrt(pow(deltaX, 2) + pow(deltaY, 2));
    CGFloat angle = asin(deltaX/hypo);
    
    if(deltaY >= 0)
    {
        //below
        angle = -angle;
        self.bugView.transform = CGAffineTransformRotate(self.bugView.transform, angle);
    }
    else
    {
        //up
        angle += M_PI;
        //angle = -angle;
        self.bugView.transform = CGAffineTransformRotate(CGAffineTransformInvert(self.bugView.transform), angle);
    }
}





@end
