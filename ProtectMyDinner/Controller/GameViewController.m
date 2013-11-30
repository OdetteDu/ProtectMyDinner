//
//  GameControllerViewController.m
//  ProtectMyDinner
//
//  Created by Caidie on 11/27/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
@property (strong, nonatomic) Bug *bug;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation GameViewController

- (Bug *) bug
{
    if(!_bug)
    {
        _bug = [[Bug alloc] init];
    }
    return _bug;
}

- (void)moveTowardsCenterForView: (UIView *)view
{
    CGPoint target = CGPointMake(self.view.center.x - view.frame.size.width/2, self.view.center.y - view.frame.size.height/2);
    CGFloat xIncrement = (target.x - view.frame.origin.x)/100;
    CGFloat yIncrement = (target.y - view.frame.origin.y)/100;
    
    view.frame =CGRectMake(view.frame.origin.x + xIncrement, view.frame.origin.y + yIncrement, view.frame.size.width, view.frame.size.height);
}

- (void)update: (NSTimer *)timer
{
    [self moveTowardsCenterForView:self.bug];
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
    UIImage *image = [UIImage imageNamed:@"bug.png"];
    CGPoint pos = [self getRandomLocationOutsideBounds:image.size];
//    self.bug = [[Bug alloc] initWithFrame:CGRectMake(pos.x-image.size.width/2, pos.y-image.size.height/2, image.size.width, image.size.height)];
    self.bug = [[Bug alloc] initWithFrame:CGRectMake(pos.x, pos.y, image.size.width, image.size.height)];
    self.bug.backgroundColor = [UIColor clearColor];
    self.bug.opaque = NO;
    self.bug.image = image;
    self.bug.contentMode = UIViewContentModeRedraw;
    [self.view addSubview:self.bug];
    
    UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self.bug action:@selector(pan:)];
    [self.bug addGestureRecognizer:pangr];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
