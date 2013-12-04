//
//  Bug.h
//  ProtectMyDinner
//
//  Created by Caidie on 11/29/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bug : UIView
@property (nonatomic) BOOL hasEnteredGamePanel;
@property (strong, nonatomic) UIImage *image;

- (void)rotateTowardsCenter: (CGPoint)center;

@end
