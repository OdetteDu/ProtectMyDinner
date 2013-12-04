//
//  GameSoundPlayer.h
//  ProtectMyDinner
//
//  Created by Caidie on 12/3/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSoundPlayer : NSObject
@property (nonatomic, strong) NSString *fileName;
- (void)prepareToPlay;
- (void)play;
@end
