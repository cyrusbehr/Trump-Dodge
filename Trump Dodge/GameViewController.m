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

@import GoogleMobileAds;

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

@interface GameViewController () <GADInterstitialDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;

@end


@implementation GameViewController
//@synthesize bannerIsVisible;
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.interstitial = [self createAndLoadInterstitial];
  
  gameRunning = FALSE;
  firstPlay = TRUE;
  
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
  NSString *message = @"Check out the new free game Trumpa Dodge!\n It's as fun as it is controversial!";
  //UIImage *imageToShare = [UIImage imageNamed:@"shareImage"];
  NSArray *postItems = @[message]; //image to share
  UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                          initWithActivityItems:postItems
                                          applicationActivities:nil];
  [self presentViewController:activityVC animated:YES completion:nil];
}




- (void)handleNotification:(NSNotification *)notification
{
  if ([notification.name isEqualToString:@"showAd"]) {
    [self showAdd];
  }
}

-(void)showAdd{
  if ([self.interstitial isReady]) {
    [self.interstitial presentFromRootViewController:self];
  }
}

- (GADInterstitial *)createAndLoadInterstitial {
  GADInterstitial *interstitial =
  [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3507573369019223/3205305595"];
  interstitial.delegate = self;
  [interstitial loadRequest:[GADRequest request]];
  return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
  self.interstitial = [self createAndLoadInterstitial];
}

@end
