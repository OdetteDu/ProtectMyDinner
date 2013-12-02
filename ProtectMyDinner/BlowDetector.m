//
//  BlowDetector.m
//  Protect My Dinner
//
//  Created by Caidie on 11/7/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "BlowDetector.h"
#import <AVFoundation/AVFoundation.h>

@interface BlowDetector()
@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) NSFileManager *fileManager;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger numOfContinuousBlow;
@property (nonatomic) double average;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation BlowDetector

- (NSFileManager *)fileManager
{
    if(!_fileManager) _fileManager = [[NSFileManager alloc] init];
    return _fileManager;
}

- (AVAudioRecorder *)recorder
{
    if(!_recorder)
    {
        NSArray *urls = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        NSURL *url=[[urls[0] URLByAppendingPathComponent:@"record"] URLByAppendingPathExtension:@".caf"];
        NSDictionary *setting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                                 [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                                 [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                                 [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey, nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
    }
    return _recorder;
}

- (void)update
{
	[self.recorder updateMeters];
    
    self.average = (self.average * self.count + [self.recorder averagePowerForChannel:0])/(self.count+1);
    //NSLog(@"average: %f", self.average);
    self.count ++;
    
    double percent = [self.recorder peakPowerForChannel:0] / self.average;
    //NSLog(@"percent: %f", percent);
    
    if(percent < 0.5)
    {
        self.numOfContinuousBlow++;
        if(self.numOfContinuousBlow > 20)
        {
            //blow detected;
            //NSLog(@"Blow Detected");
            self.blowDetected = true;
        }
    }
    else
    {
        self.numOfContinuousBlow = 0;
    }
	
}

- (void) start
{
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    [self.recorder record];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.05 target: self selector: @selector(update) userInfo: nil repeats: YES];
}

- (void) end
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [self.recorder stop];
    [self.timer invalidate];
    self.timer = nil;
    self.recorder = nil;
}

@end
