//
//  AppDelegate.h
//  Dodge
//
//  Created by Cyrus Behroozi on 2015-05-26.
//  Copyright (c) 2015 Tap App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "GameScene.h"
@import Foundation;





@interface AppDelegate : UIResponder <UIApplicationDelegate>{
  BOOL gameWasRunning;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL gameWasRunning;



@end

