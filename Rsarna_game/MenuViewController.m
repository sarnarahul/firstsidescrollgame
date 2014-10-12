//
//  ViewController.m
//  Rsarna_game
//
//  Created by Rahul Sarna on 24/03/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import "MenuViewController.h"
#import "GameViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GameViewController *gameViewController = segue.destinationViewController;
    gameViewController.menuViewController = self;
}

@end
