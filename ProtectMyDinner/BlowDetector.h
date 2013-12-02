//
//  BlowDetector.h
//  Protect My Dinner
//
//  Created by Caidie on 11/7/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlowDetector : NSObject
@property (nonatomic) BOOL blowDetected;
- (void) start;
- (void) end;
@end
