//
//  GameControllerViewController.m
//  ProtectMyDinner
//
//  Created by Caidie on 11/27/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//
#import "CMMotionManager+Shared.h"
#import "GameViewController.h"
#import "NormalBug.h"
#import "HardBug.h"
#import "LightBug.h"
#import "FlyingBug.h"
#import "BlowDetector.h"
#import "ScoreViewController.h"


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

@end

@implementation GameViewController

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
                        self.isBlowDetectorOn = NO;
                        [self.blowDetector end];
                        self.blowDetector = nil;
                    }
                    
                }
            }
        }
    }
}

- (void)moveBugTowardsCenter: (Bug *)bug
{
//    CGPoint target = CGPointMake(self.view.center.x - bug.frame.size.width/2, self.view.center.y - bug.frame.size.height/2);
//    CGFloat xIncrement = (target.x - bug.frame.origin.x)/100;
//    CGFloat yIncrement = (target.y - bug.frame.origin.y)/100;
    CGFloat xIncrement = (self.view.center.x - bug.center.x)/100;
    CGFloat yIncrement = (self.view.center.y - bug.center.y)/100;
    
    bug.frame =CGRectMake(bug.frame.origin.x + xIncrement, bug.frame.origin.y + yIncrement, bug.frame.size.width, bug.frame.size.height);
    
    if (CGRectContainsPoint(bug.frame, self.view.center))
    {
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
            bug = [[NormalBug alloc] initWithFrame:CGRectMake(pos.x, pos.y, BugSizeWidth, BugSizeHeight)];
            break;
        case HARD:
            bug = [[HardBug alloc] initWithFrame:CGRectMake(pos.x, pos.y, BugSizeWidth, BugSizeHeight)];
            break;
        case LIGHT:
            bug = [[LightBug alloc] initWithFrame:CGRectMake(pos.x, pos.y, BugSizeWidth, BugSizeHeight)];
            break;
        case FLYING:
            bug = [[FlyingBug alloc] initWithFrame:CGRectMake(pos.x, pos.y, BugSizeWidth, BugSizeHeight)];
            break;
        default:
            bug = nil;
            NSLog(@"The bug type is not normal, hard, light, or flying.");
            break;
    }
    
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
    
    if(self.isBlowDetectorOn)
    {
        if(!self.blowDetector)
        {
            self.blowDetector = [[BlowDetector alloc] init];
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
                        center.x += data.acceleration.x * DRIFT_RATE;
                        center.y -= data.acceleration.y * DRIFT_RATE;
                        view.center = center;
                        if (!CGRectContainsRect(self.view.bounds, view.frame) && !CGRectIntersectsRect(self.view.bounds, view.frame))
                        {
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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopMotionDection];
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
