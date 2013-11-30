//
//  Bug.h
//  ProtectMyDinner
//
//  Created by Caidie on 11/29/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bug : UIView
@property (strong, nonatomic) UIImage *image;
- (void)pan: (UIPanGestureRecognizer *)recognizer;
@end
