//
//  FlyingBug.m
//  ProtectMyDinner
//
//  Created by Caidie on 12/1/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "FlyingBug.h"

@implementation FlyingBug

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"bug.png"];
        self.image = image;
    }
    return self;
}

@end
