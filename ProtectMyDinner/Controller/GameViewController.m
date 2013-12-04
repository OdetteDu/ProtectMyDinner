//
//  GameControllerViewController.m
//  ProtectMyDinner
//
//  Created by Caidie on 11/27/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "CMMotionManager+Shared.h"
#import "GameViewController.h"
#import "NormalBug.h"
#import "HardBug.h"
#import "LightBug.h"
#import "FlyingBug.h"
#import "BlowDetector.h"
#import "ScoreViewController.h"
#import "GameBackgroundMusicPlayer.h"
#import "GameSoundPlayer.h"


@interface GameViewController ()
@property (strong, nonatomic) NormalBug *normalBug;
@property (strong, nonatomic) HardBug *hardBug;
@property (strong, nonatomic) LightBug *lightBug;
@property (strong, nonatomic) FlyingBug *flyingBug;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) BlowDetector *blowDetector;
@property (nonatomic) BOOL isBlowDetectorOn;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger life;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lifeLabel;
@property (strong, nonatomic) GameBackgroundMusicPlayer *backgroundMusicPlayer;
@property (strong, nonatomic) GameSoundPlayer *normalBugSoundPlayer;
@property (strong, nonatomic) GameSoundPlayer *hardBugSoundPlayer;
@property (strong, nonatomic) GameSoundPlayer *lightBugSoundPlayer;
@property (strong, nonatomic) GameSoundPlayer *flyingBugSoundPlayer;
@property (strong, nonatomic) GameSoundPlayer *cakeSoundPlayer;
@end

@implementation GameViewController

- (GameBackgroundMusicPlayer *)backgroundMusicPlayer
{
    if(!_backgroundMusicPlayer)
    {
        _backgroundMusicPlayer = [[GameBackgroundMusicPlayer alloc] init];
    }
    return _backgroundMusicPlayer;
}

- (GameSoundPlayer *)cakeSoundPlayer
{
    if(!_cakeSoundPlayer)
    {
        _cakeSoundPlayer = [[GameSoundPlayer alloc] init];
        _cakeSoundPlayer.fileName = [NSString stringWithFormat:@"cake"];
    }
    return _cakeSoundPlayer;
}

- (GameSoundPlayer *)normalBugSoundPlayer
{
    if(!_normalBugSoundPlayer)
    {
        _normalBugSoundPlayer = [[GameSoundPlayer alloc] init];
        _normalBugSoundPlayer.fileName = [NSString stringWithFormat:@"NormalBug"];
    }
    return _normalBugSoundPlayer;
}

- (GameSoundPlayer *)hardBugSoundPlayer
{
    if(!_hardBugSoundPlayer)
    {
        _hardBugSoundPlayer = [[GameSoundPlayer alloc] init];
        _hardBugSoundPlayer.fileName = [NSString stringWithFormat:@"HardBug"];
    }
    return _hardBugSoundPlayer;
}

- (GameSoundPlayer *)lightBugSoundPlayer
{
    if(!_lightBugSoundPlayer)
    {
        _lightBugSoundPlayer = [[GameSoundPlayer alloc] init];
        _lightBugSoundPlayer.fileName = [NSString stringWithFormat:@"LightBug"];
    }
    return _lightBugSoundPlayer;
}

- (GameSoundPlayer *)flyingBugSoundPlayer
{
    if(!_flyingBugSoundPlayer)
    {
        _flyingBugSoundPlayer = [[GameSoundPlayer alloc] init];
        _flyingBugSoundPlayer.fileName = [NSString stringWithFormat:@"FlyingBug"];
    }
    return _flyingBugSoundPlayer;
}

- (void) checkBlowDetected
{
    if(self.blowDetector)
    {
        if(self.blowDetector.blowDetected)
        {
            [self.blowDetector end];
            self.blowDetector = nil;
            NSLog(@"Blow Detected");
            for (UIView *view in self.view.subviews) {
                
                if([view isKindOfClass:[FlyingBug class]])
                {
                    FlyingBug *lb = (FlyingBug *)view;
                    [lb removeFromSuperview];
                    
                    if(self.isBlowDetectorOn)
                    {
                        [self.flyingBugSoundPlayer play];
                        self.isBlowDetectorOn = NO;
                        [self.blowDetector end];
                        self.blowDetector = nil;
                        [self.normalBugSoundPlayer setVolumn:10];
                        [self.hardBugSoundPlayer setVolumn:10];
                        [self.flyingBugSoundPlayer setVolumn:5];
                        [self.lightBugSoundPlayer setVolumn:10];
                        [self.cakeSoundPlayer setVolumn:10];
                        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                    }
                    
                }
            }
        }
    }
}

- (void)moveBugTowardsCenter: (Bug *)bug
{
    CGFloat xIncrement = (self.view.center.x - bug.center.x)/100;
    CGFloat yIncrement = (self.view.center.y - bug.center.y)/100;
    
    //NSLog(@"Before: %f, %f", bug.center.x, bug.center.y);
    bug.frame =CGRectMake(bug.frame.origin.x + xIncrement, bug.frame.origin.y + yIncrement, bug.frame.size.width, bug.frame.size.height);
//    [bug setCenter:CGPointMake(bug.frame.origin.x + xIncrement, bug.frame.origin.y + yIncrement)];
//    bug.transform = CGAffineTransformTranslate(bug.transform, xIncrement, yIncrement);
    //NSLog(@"After: %f, %f", bug.center.x, bug.center.y);
    
    if (CGRectContainsPoint(bug.frame, self.view.center))
    {
        [self.cakeSoundPlayer play];
        [bug removeFromSuperview];
        self.life --;
        self.lifeLabel.text = [NSString stringWithFormat:@"Life: %d", self.life];
        if(self.life<=0)
        {
            UIViewController *scoreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"score"];
            if([scoreViewController isKindOfClass:[scoreViewController class]])
            {
                ScoreViewController *svc = (ScoreViewController *)scoreViewController;
                svc.score = self.count;
                [self.navigationController pushViewController:svc animated:YES];
            }
        }
    }
    
    if (CGRectContainsRect(self.view.bounds, bug.frame))
    {
        if(bug.hasEnteredGamePanel == NO && [bug isKindOfClass:[FlyingBug class]])
        {
            self.isBlowDetectorOn = YES;
        }
        bug.hasEnteredGamePanel = YES;
    }
}

#define BugSizeWidth 50
#define BugSizeHeight 50

typedef enum
{
    NORMAL = 0,
    HARD = 1,
    LIGHT = 2,
    FLYING = 3
}BUG_TYPE;

- (void)createBug
{
    CGPoint pos = [self getRandomLocationOutsideBounds:CGSizeMake(BugSizeWidth, BugSizeHeight)];
    Bug *bug;
    
    int type = arc4random() % 4;
    switch (type) {
        case NORMAL:
        {
            bug = [[NormalBug alloc] initWithFrame:CGRectMake(pos.x, pos.y, 100/2, 90/2)];
            NormalBug *nb = (NormalBug *)bug;
            nb.gameSoundPlayer = self.normalBugSoundPlayer;
        }
            break;
        case HARD:
        {
            bug = [[HardBug alloc] initWithFrame:CGRectMake(pos.x, pos.y, 100/2, 70/2)];
            HardBug *hb = (HardBug *)bug;
            hb.gameSoundPlayer = self.hardBugSoundPlayer;
        }
            break;
        case LIGHT:
        {
            bug = [[LightBug alloc] initWithFrame:CGRectMake(pos.x, pos.y, 100/4, 50/4)];
            //[self.lightBugSoundPlayer play];
        }
            break;
        case FLYING:
            bug = [[FlyingBug alloc] initWithFrame:CGRectMake(pos.x, pos.y, 100/4, 80/4)];
            break;
        default:
            bug = nil;
            NSLog(@"The bug type is not normal, hard, light, or flying.");
            break;
    }
    
    [bug rotateTowardsCenter:self.view.center];
    [self.view addSubview:bug];
}

- (void)update: (NSTimer *)timer
{
    if(self.count % 10 == 0)
    {
        [self createBug];
    }
    
    for (UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[Bug class]])
        {
            Bug *bug = (Bug *)view;
            [self moveBugTowardsCenter:bug];
        }
    }
    
    //self.isBlowDetectorOn = NO;
    if(self.isBlowDetectorOn)
    {
        if(!self.blowDetector)
        {
            self.blowDetector = [[BlowDetector alloc] init];

            [self.normalBugSoundPlayer setVolumn:1];
            [self.hardBugSoundPlayer setVolumn:1];
            [self.flyingBugSoundPlayer setVolumn:1];
            [self.lightBugSoundPlayer setVolumn:1];
            [self.cakeSoundPlayer setVolumn:1];
            [self. blowDetector start];
        }
        [self checkBlowDetected];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.count];
    
    self.count++;
}

#define DRIFT_HZ 10
#define DRIFT_RATE 10

- (void)startMotionDetection
{
    CMMotionManager *motionManager = [CMMotionManager sharedMotionManager];
    if ([motionManager isAccelerometerAvailable]) {
        [motionManager setAccelerometerUpdateInterval:1/DRIFT_HZ];
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *data, NSError *error) {
            for (UIView *view in self.view.subviews) {
                
                if([view isKindOfClass:[LightBug class]])
                {
                    LightBug *lb = (LightBug *)view;
                    if(lb.hasEnteredGamePanel)
                    {
                        CGPoint center = view.center;
                        center.x -= data.acceleration.y * DRIFT_RATE;
                        center.y -= data.acceleration.x * DRIFT_RATE;
                        view.center = center;
                        if (!CGRectContainsRect(self.view.bounds, view.frame) && !CGRectIntersectsRect(self.view.bounds, view.frame))
                        {
                            [self.lightBugSoundPlayer play];
                            [view removeFromSuperview];
                        }
                    }
                }
            }
        }];
    }
}

- (void)stopMotionDection
{
    [[CMMotionManager sharedMotionManager] stopAccelerometerUpdates];
}

typedef enum
{
    UP = 0,
    DOWN = 1,
    LEFT = 2,
    RIGHT = 3
}DIRECTION;

- (CGPoint)getRandomLocationOutsideBounds: (CGSize)viewSize
{
    //return CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height);
    
    CGRect bugBounds = self.view.bounds;
    CGFloat x;
    CGFloat y;
    
    int direction = arc4random() % 4;
    switch (direction) {
        case UP:
            x = bugBounds.origin.x + arc4random() % (int)bugBounds.size.width;
            y = bugBounds.origin.y - viewSize.height/2;
            break;
        case DOWN:
            x = bugBounds.origin.x + arc4random() % (int)bugBounds.size.width;
            y = bugBounds.origin.y + bugBounds.size.height + viewSize.height/2;
            break;
        case LEFT:
            x = bugBounds.origin.x - viewSize.width/2;
            y = bugBounds.origin.y + arc4random() % (int)bugBounds.size.height;
            break;
        case RIGHT:
            x = bugBounds.origin.x + bugBounds.size.width + viewSize.width/2;
            y = bugBounds.origin.y + arc4random() % (int)bugBounds.size.height;
            break;
            
        default:
            x=0;
            y=0;
            NSLog(@"The direction is not up, down, left, or right.");
            break;
    }
    
    return CGPointMake(x, y);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.life = 10;
    
    [self startMotionDetection];
    [self.backgroundMusicPlayer play];
    [self.normalBugSoundPlayer prepareToPlay];
    [self.hardBugSoundPlayer prepareToPlay];
    [self.flyingBugSoundPlayer prepareToPlay];
    [self.lightBugSoundPlayer prepareToPlay];
    [self.cakeSoundPlayer prepareToPlay];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopMotionDection];
    [self.timer invalidate];
    [self.normalBugSoundPlayer end];
    [self.hardBugSoundPlayer end];
    [self.flyingBugSoundPlayer end];
    [self.lightBugSoundPlayer end];
    [self.cakeSoundPlayer end];
    [self.backgroundMusicPlayer end];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
