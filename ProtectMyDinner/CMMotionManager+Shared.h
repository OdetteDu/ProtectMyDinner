//
//  CMMotionManager+Shared.h
//  ProtectMyDinner
//
//  Created by Caidie on 12/1/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

@interface CMMotionManager (Shared)

+ (CMMotionManager *)sharedMotionManager;

@end
