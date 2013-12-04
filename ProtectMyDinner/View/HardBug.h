//
//  HardBug.h
//  ProtectMyDinner
//
//  Created by Caidie on 12/1/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "Bug.h"
#import "GameSoundPlayer.h"

@interface HardBug : Bug
@property (nonatomic, strong) GameSoundPlayer *gameSoundPlayer;
- (void)pan: (UIPanGestureRecognizer *)recognizer;
@end
