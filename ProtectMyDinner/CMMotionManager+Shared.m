//
//  CMMotionManager+Shared.m
//  ProtectMyDinner
//
//  Created by Caidie on 12/1/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "CMMotionManager+Shared.h"

@implementation CMMotionManager (Shared)

+ (CMMotionManager *)sharedMotionManager
{
    static CMMotionManager *shared = nil;
    if (!shared) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{                 // all threads will block here until the block executes
            shared = [[CMMotionManager alloc] init]; // this line of code can only ever happen once
        });
    }
    return shared;
}

@end
