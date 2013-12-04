//
//  MusicPlayer.m
//  ProtectMyDinner
//
//  Created by Caidie on 12/3/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "GameBackgroundMusicPlayer.h"


@interface GameBackgroundMusicPlayer()
@property (strong, nonatomic) AVAudioPlayer *player;
@end

@implementation GameBackgroundMusicPlayer

- (AVAudioPlayer *)player
{
    if(!_player)
    {
        NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"mp3"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    return _player;
}

- (void)play
{
    [self.player prepareToPlay];
    [self.player setVolume:1];
    self.player.numberOfLoops = -1;
    [self.player play];
}

- (void) end
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [self.player stop];
    self.player = nil;
}

@end
