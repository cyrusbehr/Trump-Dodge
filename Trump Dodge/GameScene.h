//
//  GameScene.h
//  Dodge
//

//  Copyright (c) 2015 Tap App. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <SpriteKit/SpriteKit.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Joystick.h"
#import <QuartzCore/QuartzCore.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>
{
  long highScore;
  int score;
}


//define global methods here
-(void)resumeGame;
-(void)gameOver;
-(void)pauseGame;
-(void)saveScore;
-(void)loadScore;
-(void)changeScore:(int)Newscore;

@end


