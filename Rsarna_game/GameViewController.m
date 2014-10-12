//
//  GameViewController.m
//  Rsarna_game
//
//  Created by Rahul Sarna on 25/03/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import "GameViewController.h"
#import "AppDelegate.h"
#import "ScoreTableViewController.h"

@interface GameViewController (){
    
    BOOL skeletonMovingUp;
    NSTimer *timer;
    long number;
    int sum;
    
    CALayer *backgroundLayer;
    CABasicAnimation *backgroundLayerAnimation;
}

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) backgroundScroll{
    UIImage *backgroundImage = [UIImage imageNamed:@"backgroundGame.png"];
    UIColor *backgroundPattern = [UIColor colorWithPatternImage:backgroundImage];
    backgroundLayer = [CALayer layer];
    backgroundLayer.backgroundColor = backgroundPattern.CGColor;
    
    backgroundLayer.transform = CATransform3DMakeScale(1, -1, 1);
    
    backgroundLayer.anchorPoint = CGPointMake(0, 1);
    
    CGSize viewSize = self.backgroundImageView.bounds.size;
    backgroundLayer.frame = CGRectMake(0, 0, backgroundImage.size.width + viewSize.width, viewSize.height);
    
    [self.backgroundImageView.layer addSublayer:backgroundLayer];
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(-backgroundImage.size.width, 0);
    
    backgroundLayerAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    backgroundLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    backgroundLayerAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    backgroundLayerAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    backgroundLayerAnimation.repeatCount = HUGE_VALF;
    backgroundLayerAnimation.duration = 4.0;
    
    [self applyBackgroundLayerAnimation];
}

-(void) applyBackgroundLayerAnimation{
    
    [backgroundLayer addAnimation:backgroundLayerAnimation forKey:@"position"];
    
}

- (void)viewDidLoad
{
    
    [self backgroundScroll];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //loading audio
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gameMusic" ofType:@"aif"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    [_player prepareToPlay];
    
    //repeat forever!
    _player.numberOfLoops = -1;
    
    srand([[NSDate date] timeIntervalSince1970]);

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(jump)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doubleJump)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    _playerImages = [self loadImagesForFilename:@"walk" type:@"png" count:6];
    _numberImages = [self loadImagesForFilename:@"number" type:@"png" count:10];
    
    sum = 0;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self applyBackgroundLayerAnimation];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    [self playerRun];
    
    [self chooseRandomNumber];
    
    _sumLabel.text = [NSString stringWithFormat:@"%d",25 + rand()%25];

    [_player play];

}

-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [timer invalidate];
    
    [_player stop];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) //Run some code
    {
        [backgroundLayer removeAllAnimations];  //]:backgroundLayerAnimation forKey:@"position"];

        [self dismissViewControllerAnimated:YES completion:^{
            
            MenuViewController *menuViewController = [AppDelegate menuViewController];
            [menuViewController dismissViewControllerAnimated:YES completion:^{
                
                //        ScoreTableViewController *scoresViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreTableViewController"];
                //        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:scoresViewController];
                //        [menuViewController presentViewController:navController animated:YES completion:nil];
            }];

            
        }];

    }
}

-(void) update{
    
    _numberImageView.center = CGPointMake(_numberImageView.center.x - 7, _numberImageView.center.y);
    
    if(_numberImageView.center.x + _numberImageView.frame.size.width/2.0 <= 0) {
        
        int change = rand()%100;
        
        if(_numberImageView.center.y - change > 40)
            _numberImageView.center = CGPointMake(600, _numberImageView.center.y - change);
        else{
            _numberImageView.center = CGPointMake(600, _numberImageView.center.y + change);
        }
        
        [self chooseRandomNumber];
    }
    
    [self checkCollision];
}

-(void) checkCollision{
    
    if(CGRectIntersectsRect(_playerImageView.frame, _numberImageView.frame)){
        
        int change = rand()%100;
        
        if(_numberImageView.center.y - change > 40)
            _numberImageView.center = CGPointMake(600, _numberImageView.center.y - change);
        else{
            _numberImageView.center = CGPointMake(600, _numberImageView.center.y + change);
        }
        
        sum += (number + 1);
        
        _currentSum.text = [NSString stringWithFormat:@"Current Sum: %d",sum];
        
        NSLog(@"Sum= %d", sum);
        
        if([_sumLabel.text intValue] == sum){
            
            [timer invalidate];

            [NSTimer scheduledTimerWithTimeInterval:0.9
                                             target:self
                                           selector:@selector(winMenu)
                                           userInfo:nil repeats:NO];

        }
        else if([_sumLabel.text intValue] < sum){
            
            [timer invalidate];

            [NSTimer scheduledTimerWithTimeInterval:0.9
                                             target:self
                                           selector:@selector(looseMenu)
                                           userInfo:nil repeats:NO];
            
        }
        
        [self chooseRandomNumber];
    }
    
}

- (void) winMenu
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WON" message:@"You got the sum" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];

}

-(void) looseMenu{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try Again" message:@"You got over the sum reach EXACTLY" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];

}




-(void) chooseRandomNumber{
    
    number = rand()%_numberImages.count;
    
    NSLog(@"Number = %lu",number);
    
    [_numberImageView setImage:[_numberImages objectAtIndex:number]];
    
    if(number == 9){
        number = -1;
    }
    
}

-(void) playerRun{
    
    [_playerImageView stopAnimating];
    
    _playerImageView.animationImages = _playerImages;
    
    _playerImageView.animationDuration = .5;
    
    _playerImageView.animationRepeatCount = 0;
    
    [_playerImageView startAnimating];
}

-(void) jump{
    
    
    [_playerImageView stopAnimating];
    
    _playerImageView.image = [_playerImages objectAtIndex:0];
    
    [UIView animateWithDuration:0.35 animations:^{
        _playerImageView.center = CGPointMake(_playerImageView.center.x, _playerImageView.center.y - 80);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            _playerImageView.center = CGPointMake(_playerImageView.center.x, _playerImageView.center.y + 80);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    double delayInSeconds = 0.75;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self playerRun];
    });

    
    
}

-(void) doubleJump{
    
    
    [_playerImageView stopAnimating];
    
    _playerImageView.image = [_playerImages objectAtIndex:0];
    
    [UIView animateWithDuration:0.5 animations:^{
        _playerImageView.center = CGPointMake(_playerImageView.center.x, _playerImageView.center.y - 140);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 animations:^{
            _playerImageView.center = CGPointMake(_playerImageView.center.x, _playerImageView.center.y + 140);
        } completion:^(BOOL finished) {
            //_button.center = CGPointMake(_button.center.x, _button.center.y + 120);
        }];
    }];
    
    double delayInSeconds = 0.75;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self playerRun];
    });
    
    
    
}

-(NSMutableArray*)loadImagesForFilename:(NSString *)filename type:(NSString*)extension count:(int)count {
    NSMutableArray *images = [NSMutableArray array];
    for(int i=1; i<= count; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d.%@", filename, i, extension]];
        if(image != nil)
            [images addObject:image];
    }
    return images;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
