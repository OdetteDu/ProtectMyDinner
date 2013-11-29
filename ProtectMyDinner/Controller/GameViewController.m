//
//  GameControllerViewController.m
//  ProtectMyDinner
//
//  Created by Caidie on 11/27/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
@property (strong, nonatomic) IBOutlet UIView *gamePanel;
@property (strong, nonatomic) Bug *bug;
@end

@implementation GameViewController

- (Bug *) bug
{
    if(!_bug) _bug = [[Bug alloc] init];
    return _bug;
}

typedef enum
{
    UP = 0,
    DOWN = 1,
    LEFT = 2,
    RIGHT = 3
}DIRECTION;

- (void)setRandomLocationOutsideBoundsForView:(UIView *)view
{
    [view sizeToFit];
    CGRect bugBounds = self.gamePanel.bounds;
    CGFloat x;
    CGFloat y;
    
    int direction = arc4random() % 4;
    switch (direction) {
        case UP:
            x = bugBounds.origin.x + arc4random() % (int)bugBounds.size.width;
            y = bugBounds.origin.y - view.frame.size.height/2;
            break;
        case DOWN:
            x = bugBounds.origin.x + arc4random() % (int)bugBounds.size.width;
            y = bugBounds.origin.y + bugBounds.size.height + view.frame.size.height/2;
            break;
        case LEFT:
            x = bugBounds.origin.x - view.frame.size.width/2;
            y = bugBounds.origin.y + arc4random() % (int)bugBounds.size.height;
            break;
        case RIGHT:
            x = bugBounds.origin.x + bugBounds.size.width + view.frame.size.width/2;
            y = bugBounds.origin.y + arc4random() % (int)bugBounds.size.height;
            break;
            
        default:
            x=0;
            y=0;
            NSLog(@"The direction is not up, down, left, or right.");
            break;
    }
    
    view.center = CGPointMake(x, y);
}

- (void)setLocationToCenterForView: (UIView *)view
{
    [view sizeToFit];
    CGRect gamePanelBounds = self.gamePanel.bounds;
    CGFloat x = gamePanelBounds.origin.x + gamePanelBounds.size.width/2;
    CGFloat y = gamePanelBounds.origin.y + gamePanelBounds.size.height/2;
    view.center = CGPointMake(x, y);
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
	// Do any additional setup after loading the view.
    self.bug.image = [UIImage imageNamed:@"bug.png"];
    [self setRandomLocationOutsideBoundsForView:self.bug];
    [self.gamePanel addSubview:self.bug];
    [UIView animateWithDuration:5.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self setLocationToCenterForView:self.bug];
                     }
                     completion:^(BOOL finished){
                         if(finished)
                         {
                             [self.bug removeFromSuperview];
                         }
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
