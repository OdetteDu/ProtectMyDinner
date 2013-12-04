//
//  MenuViewController.m
//  ProtectMyDinner
//
//  Created by Caidie on 12/2/13.
//  Copyright (c) 2013 Rice. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Easy"])
    {
        NSLog(@"Easy");
    }
    else if([segue.identifier isEqualToString:@"Medium"])
    {
        NSLog(@"Medium");
    }
    else if([segue.identifier isEqualToString:@"Hard"])
    {
        NSLog(@"Hard");
    }
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
