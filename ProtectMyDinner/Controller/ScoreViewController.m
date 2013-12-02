//
//  ScoreViewController.m
//  ProtectMyDinner
//
//  Created by Caidie on 12/2/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "ScoreViewController.h"

@interface ScoreViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation ScoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"initWithNibName");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scoreLabel.text = [NSString stringWithFormat:@"Your Score: %d", self.score];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
