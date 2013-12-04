//
//  GameSoundPlayer.m
//  ProtectMyDinner
//
//  Created by Caidie on 12/3/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "GameSoundPlayer.h"

@interface GameSoundPlayer()
@property (strong, nonatomic) AVAudioPlayer *player;
@end

@implementation GameSoundPlayer

- (AVAudioPlayer *)player
{
    if(!_player)
    {
        NSString *musicPath = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"mp3"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
    }
    return _player;
}

- (void)prepareToPlay
{
    [self.player prepareToPlay];
    [self.player setVolume:10];
    self.player.numberOfLoops = 1;
}

- (void)play
{
    [self.player play];
}
@end
