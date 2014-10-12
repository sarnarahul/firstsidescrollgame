//
//  GameViewController.h
//  Rsarna_game
//
//  Created by Rahul Sarna on 25/03/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import <AVFoundation/AVFoundation.h>

@class GameViewController;

@protocol GameViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(GameViewController *)controller;
@end

@interface GameViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) MenuViewController *menuViewController;

@property (strong, nonatomic) IBOutlet UIImageView *playerImageView;

@property (strong, nonatomic) NSMutableArray *playerImages;

@property (strong, nonatomic) NSMutableArray *numberImages;

@property (strong, nonatomic) IBOutlet UIImageView *numberImageView;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) IBOutlet UILabel *sumLabel;

@property (strong, nonatomic) IBOutlet UILabel *currentSum;

@property (weak, nonatomic) id <GameViewControllerDelegate> delegate;

@property (strong, nonatomic) AVAudioPlayer *player;


@end
