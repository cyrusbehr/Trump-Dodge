//
//  AppDelegate.m
//  Dodge
//
//  Created by Cyrus Behroozi on 2015-05-26.
//  Copyright (c) 2015 Tap App. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize gameWasRunning;




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  gameWasRunning = FALSE;
  return YES;
  
}
+ (void)initialize
{
  
}

- (void)applicationWillResignActive:(UIApplication *)application {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseGame" object:nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseMusic" object:nil];
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  gameWasRunning = TRUE;
  
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  //NSLog(@"didBecomeActive");
  [[NSNotificationCenter defaultCenter] postNotificationName:@"playMusic" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"gameOver" object:nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseGame" object:nil];
  
  
}





@end
