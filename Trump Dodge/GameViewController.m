//
//  GameViewController.m
//  Dodge
//
//  Created by Cyrus Behroozi on 2015-05-26.
//  Copyright (c) 2015 Tap App. All rights reserved.


#import "GameViewController.h"
#import "GameScene.h"
@import AVFoundation;
#import "AppDelegate.h"



@implementation SKScene (Unarchive)


+ (instancetype)unarchiveFromFile:(NSString *)file {
  /* Retrieve scene file path from the application bundle */
  NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
  /* Unarchive the file to an SKScene object */
  NSData *data = [NSData dataWithContentsOfFile:nodePath
                                        options:NSDataReadingMappedIfSafe
                                          error:nil];
  NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
  [arch setClass:self forClassName:@"SKScene"];
  SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
  [arch finishDecoding];
  
  
  
  return scene;
}

@end

@implementation GameViewController
//@synthesize bannerIsVisible;
- (void)viewDidLoad
{
  [super viewDidLoad];
  gameRunning = FALSE;
  firstPlay = TRUE;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"hideAd" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showAd" object:nil];
  
  
  
  
  SKView * skView = (SKView *)self.view;
  skView.ignoresSiblingOrder = YES;
  // Create and configure the scene.
  
  GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
  scene.scaleMode = SKSceneScaleModeAspectFill;
  
  // Present the scene.
  [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
  return YES;
}


-(BOOL) prefersStatusBarHidden{
  return YES;
  
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return UIInterfaceOrientationMaskAllButUpsideDown;
  } else {
    return UIInterfaceOrientationMaskAll;
  }
}




- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}


-(void)shareGame{
  
  //NSLog(@"shareGame!");
  NSString *message = @"Check out the new free game Penga Dodge!\n Get the game at: https://itunes.apple.com/us/app/pengadodge/id1012610750?mt=8";
  UIImage *imageToShare = [UIImage imageNamed:@"shareImage"];
  NSArray *postItems = @[message, imageToShare];
  UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                          initWithActivityItems:postItems
                                          applicationActivities:nil];
  [self presentViewController:activityVC animated:YES completion:nil];
}


//---------------------------------------------------------------------------------------------------------
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
  //NSLog(@"an error occured");
  [self hideBanner];
  
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:1];
  [addView setAlpha:1];
  [UIView commitAnimations];
  // NSLog(@"banner add did load");
  
}

- (void)handleNotification:(NSNotification *)notification
{
  if ([notification.name isEqualToString:@"hideAd"]) {
    [self hideBanner];
  }else if ([notification.name isEqualToString:@"showAd"]) {
    [self showBanner];
  }
}

-(void)hideBanner{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:1];
  [addView setAlpha:0];
  [UIView commitAnimations];
  //NSLog(@"banner is being hidden");
}

-(void)showBanner{
  if(firstPlay==TRUE){
    addView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    [addView setFrame:CGRectMake(0, self.view.frame.size.height-32, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:addView];
    [addView setAlpha:0];
    addView.delegate = self;
    firstPlay=FALSE;
    //NSLog(@"banner ad alloc");
  }
  
}


-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseGame" object:nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseMusic" object:nil];
  
  return YES;
}


@end
