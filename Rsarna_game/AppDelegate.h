//
//  AppDelegate.h
//  Rsarna_game
//
//  Created by Rahul Sarna on 24/03/14.
//  Copyright (c) 2014 Rahul Sarna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate*)appDelegate;
+(MenuViewController*)menuViewController;


@end
