//
//  GameViewController.h
//  Dodge
//

//  Copyright (c) 2015 Tap App. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "GameScene.h"
#import <iAd/iAd.h>


@interface GameViewController :  UIViewController <ADBannerViewDelegate>
{
  ADBannerView *addView;
  //   BOOL bannerIsVisible;
  BOOL firstPlay;
  BOOL gameRunning;
}

-(void)shareGame;

//@property (nonatomic, assign) BOOL bannerIsVisible;

@end
