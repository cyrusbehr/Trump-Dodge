
//  Created by Cyrus Behroozi on 2015-05-26.
//  Copyright (c) 2015 Cyrus Behroozi. All rights reserved.
//


//TODO: create start powerup which has a SKemiiter generating starts and makes player invinsible
//and plays music and allows player to kill enemies by touching them and rewards points for each killed enemy

//TODO: Make game harder!


#import "GameScene.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GameViewController.h"
#import "AppDelegate.h"

@import Foundation;

static const uint32_t heroCategory     =  0x1 << 0;
static const uint32_t enemyCategory    =  0x1 << 1;
static const uint32_t fishCategory    =  0x1 << 2;
static const uint32_t powerUpCategory=  0x1 << 3;
static const uint32_t noCategory =      0X1 <<4;


int dx;
int dy;
int clockTime;
double initialdelayTime = 0.7;//
double delayTimeMin = 0.2;
double delayTime = 0.9;//start at 0.9
int speedTime = 70;//70 start
double timeConstant = 0.0035;//Absolute min time for travel (increase to slow down)(0.0045)
int rotMax = 100;
int maxRot = 300;
int speedTimeMax  = 20;
double timeConstantMin = 0.002;
double initialTimeConstant = 0.0045;
int initialspeedTime = 70;
int initialrotMax = 100;
int lives = 0;

BOOL gunIsOnScreen;
BOOL musicTransitionBool = TRUE;
BOOL hasBegan = FALSE;
BOOL pauseGame = FALSE;
BOOL gameOverBool = FALSE;
BOOL powerUpTimeBool  = TRUE;
BOOL delayTimeBool = TRUE;
BOOL rotLab = TRUE;
BOOL isPaused = FALSE;
BOOL speedTimeBOOL = TRUE;
BOOL timeConstantBool = TRUE;
BOOL testing = TRUE;
BOOL fishSpawnBool = TRUE;
BOOL fishDelayTimeBool = TRUE;
BOOL collideBool = TRUE;
BOOL powerUpDelayTime = TRUE;
BOOL isSausage;
BOOL soundEnabled = TRUE;
BOOL genteMusicIsPlaying = TRUE;
BOOL isMute = FALSE;
BOOL movingUp;
BOOL canGetFirstLife = TRUE;


@implementation GameScene{
  
  AVAudioPlayer *mooseSound;
  AVAudioPlayer *beeSound;
  AVAudioPlayer *splashSound;
  AVAudioPlayer *sheepSound;
  AVAudioPlayer *pigSound;
  NSTimer *updateMusicTransitionBoolTimer;
  UIButton *owlButton;
  UIButton *sheepButton;
  UIButton *goldPenguinButton;
  UIButton *giraffeButton;
  UIButton *beaverButton;
  UIButton *elephantButton;
  UIButton *beeButton;
  UIButton *mooseButton;
  UIButton *goatButton;
  UIButton *hippoButton;
  UIButton *penguinButton;
  UILabel *characterSelected;
  UILabel *characterTitle;
  UIButton *pigButton;
  NSTimer *adDelayTime;
  AVAudioPlayer *goldClink;
  AVAudioPlayer *elephantSound;
  AVAudioPlayer *popSound;
  AVAudioPlayer *backgroundMusicGentle;
  AVAudioPlayer *backgroundMusicIntense;
  AVAudioPlayer *explosionSound;
  AVAudioPlayer *splatSound;
  AVAudioPlayer *poofSound;
  NSTimer *powerUpdelayTimer;
  NSTimer *powerUpBoolTimer;
  SKSpriteNode *fish;
  UILabel *bestScore;
  UIButton *shareButton;
  NSTimer *mainTimer;
  UILabel *mainTimerLabel;
  SKAction *rotate;
  UIButton *pause;
  UIButton *start;
  SKNode *mainLayer;
  SKSpriteNode *hero;
  SKSpriteNode *enemy;
  CGPoint *spawnLoc;
  CGVector enemyDirection;
  NSTimer *enemyTime;
  NSMutableArray *enemyList;
  CABasicAnimation *theAnimation;
  SKAction *move;
  UIButton *resume;
  UIView *pauseScreen;
  UIButton *menuBut;
  UIButton *restartBut;
  NSTimer *delayForRotLab;
  UIButton *rotationLabel;
  NSTimer *rotationLabelTimer;
  NSTimer *delayForSpeedTimer;
  NSTimer *speedTimeBOOLTimer;
  UIButton *speedTimeLabel;
  NSTimer * timeConstantBoolTimer;
  NSTimer *delayTimeBBoolTimer;
  UIButton *delayTimeLabel;
  NSTimer *delayTimeLabelTimer;
  UIButton *plus1lifeButton;
  NSTimer *plus1lifebuttonTimer;
  NSTimer *gameTimer;
  NSTimer *gameOverDelay;
  NSTimer *fishSpawnBoolTimer;
  NSTimer *fishDelayTimer;
  UIButton *plus100Button;
  NSTimer *plus100ButtonFadeTimer;
  SKSpriteNode *star;
  SKSpriteNode *powerUp;
  SKAction *pulseFade;
  UILabel *gameTitleLabel;
  SKSpriteNode *fishBone;
  SKAction *fadeOut;
  SKSpriteNode *bloodSplatter;
  UILabel *tauntLabel;
  UIButton *helpScreenImage;
  UIButton *soundButton;
  NSString *characterName;
  UIButton *backButton;
  SKAction *instructionAnimation;
  SKNode *finger;
  UIButton *moreButton;
  UIButton *lessButton;
  SKSpriteNode *bulletNode;
  NSTimer *bulletSpawnDelayTimer;
  CGPoint *gunPosition;
  SKSpriteNode *gun;
  NSTimer *gunSpawnTimer;
  SKSpriteNode *gunTestingPoint;
  SKSpriteNode *angelPenguin;
  NSTimer *updateCollideBoolTimer;
  AVAudioPlayer *woodSound;
  AVAudioPlayer *leaveSound;
}



static inline CGVector degreesToVector(CGFloat degrees){
  //use this method for converting from degrees to vector form
  CGVector vector;
  CGFloat radians = degrees/180*3.1415;
  vector.dx = cosf(radians);
  vector.dy = sinf(radians);
  return vector;
  
}
static inline CGVector radiansToVector(CGFloat radians){
  //use this method for converting from degrees to vector form
  CGVector vector;
  vector.dx = cosf(radians);
  vector.dy = sinf(radians);
  return vector;
}


-(void)didMoveToView:(SKView *)view {
  
  //sound initialization
  
  
  
  NSString *path = [NSString stringWithFormat:@"%@/poof.mp3", [[NSBundle mainBundle] resourcePath]];
  NSURL *soundUrl = [NSURL fileURLWithPath:path];
  poofSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
  poofSound.volume = 1.2;
  
  NSString *path2 = [NSString stringWithFormat:@"%@/splat.mp3", [[NSBundle mainBundle] resourcePath]];
  NSURL *soundUrl2 = [NSURL fileURLWithPath:path2];
  splatSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl2 error:nil];
  //[splatSound setVolume:0.1]; to adjust volume
  
  NSString *path3 = [NSString stringWithFormat:@"%@/explosion.mp3", [[NSBundle mainBundle] resourcePath]];
  NSURL *soundUrl3 = [NSURL fileURLWithPath:path3];
  explosionSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl3 error:nil];
  [explosionSound setVolume:1.5];
  
  NSString *path4 = [NSString stringWithFormat:@"%@/menuSong.mp3", [[NSBundle mainBundle] resourcePath]];
  NSURL *soundUrl4 = [NSURL fileURLWithPath:path4];
  backgroundMusicGentle = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl4 error:nil];
  [backgroundMusicGentle setNumberOfLoops:-1];
  [backgroundMusicGentle play];
  [backgroundMusicGentle setVolume:0.4];
  
//  NSString *path5 = [NSString stringWithFormat:@"%@/intenseSong.mp3", [[NSBundle mainBundle] resourcePath]];
//  NSURL *soundUrl5 = [NSURL fileURLWithPath:path5];
//  backgroundMusicIntense = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl5 error:nil];
//  [backgroundMusicIntense setNumberOfLoops:-1];
//  [backgroundMusicIntense setVolume:1];
  
  NSString *path7 = [NSString stringWithFormat:@"%@/cash.mp3", [[NSBundle mainBundle] resourcePath]];
  NSURL *soundUrl7 = [NSURL fileURLWithPath:path7];
  popSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl7 error:nil];
  [popSound setVolume:1.5];
  
//  
//  NSString *path10 = [NSString stringWithFormat:@"%@/pigSound.mp3", [[NSBundle mainBundle] resourcePath]];
//  NSURL *soundUrl10 = [NSURL fileURLWithPath:path10];
//  pigSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl10 error:nil];
//  [pigSound setVolume:1.2];
//  
//  
//  NSString *path11 = [NSString stringWithFormat:@"%@/sheepSound.mp3", [[NSBundle mainBundle] resourcePath]];
//  NSURL *soundUrl11 = [NSURL fileURLWithPath:path11];
////  sheepSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl11 error:nil];
////  [sheepSound setVolume:1.2];
//  
//  NSString *path12 = [NSString stringWithFormat:@"%@/splash.mp3", [[NSBundle mainBundle] resourcePath]];
//  NSURL *soundUrl12 = [NSURL fileURLWithPath:path12];
//  splashSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl12 error:nil];
////  [splashSound setVolume:1.2];
//  
//  NSString *path15 = [NSString stringWithFormat:@"%@/elephantSound.mp3", [[NSBundle mainBundle] resourcePath]];
//  NSURL *soundUrl15 = [NSURL fileURLWithPath:path15];
//  elephantSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl15 error:nil];
//  [elephantSound setVolume:1.2];
//  NSString *path16 = [NSString stringWithFormat:@"%@/goldClink.mp3", [[NSBundle mainBundle] resourcePath]];
//  NSURL *soundUrl16 = [NSURL fileURLWithPath:path16];
//  goldClink = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl16 error:nil];
//  [goldClink setVolume:2];
//  NSString *path17 = [NSString stringWithFormat:@"%@/beeSound.mp3", [[NSBundle mainBundle] resourcePath]];
//  NSURL *soundUrl17 = [NSURL fileURLWithPath:path17];
//  beeSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl17 error:nil];
//  [beeSound setVolume:2];
//  NSString *path20 = [NSString stringWithFormat:@"%@/mooseSound.mp3", [[NSBundle mainBundle] resourcePath]];
//  NSURL *soundUrl20 = [NSURL fileURLWithPath:path20];
//  mooseSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl20 error:nil];
//  [mooseSound setVolume:2];
//  NSString *path21 = [NSString stringWithFormat:@"%@/wood.mp3", [[NSBundle mainBundle] resourcePath]];
//  NSURL *soundUrl21 = [NSURL fileURLWithPath:path21];
//  woodSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl21 error:nil];
//  [woodSound setVolume:1.5];
//  NSString *path22 = [NSString stringWithFormat:@"%@/leaves.mp3", [[NSBundle mainBundle] resourcePath]];
//  NSURL *soundUrl22 = [NSURL fileURLWithPath:path22];
//  leaveSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl22 error:nil];
//  [leaveSound setVolume:3];
  
  
  
  
  isSausage = FALSE;
  
  //NSLog(@"scene moved to view");
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"pauseGame" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"gameOver" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"pauseMusic" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"playMusic" object:nil];
  //sound button
  soundButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.03, self.view.frame.size.height*0.03, 50, 40)];
  
  [soundButton setAlpha:0.8];
  [soundButton setBackgroundImage:[UIImage imageNamed:@"musicNoteFix@2x"]
                         forState:UIControlStateNormal];
  [soundButton setBackgroundColor:[UIColor clearColor]];
  [soundButton addTarget:self action:@selector(toggleSound) forControlEvents:UIControlEventTouchUpInside];
  
  //instructions annimation
  
  //pulseFade action
  pulseFade = [SKAction sequence:@[   [SKAction fadeAlphaTo:0.7 duration:0.55],
                                      [SKAction waitForDuration:0.1],
                                      [SKAction fadeAlphaTo:1 duration:0.55],
                                      [SKAction waitForDuration:0.1],
                                      [SKAction fadeAlphaTo:0.7 duration:0.55],
                                      [SKAction waitForDuration:0.1],
                                      [SKAction fadeAlphaTo:1 duration:0.55],
                                      [SKAction waitForDuration:0.1],
                                      [SKAction fadeAlphaTo:0.7 duration:0.55],
                                      [SKAction waitForDuration:0.1],
                                      [SKAction fadeAlphaTo:1 duration:0.55],
                                      [SKAction fadeOutWithDuration:0.2]]];
  
  
  
  //add buttons and views
  pauseScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  [pauseScreen setAlpha:0.75];
  [pauseScreen setBackgroundColor:[UIColor blackColor]];
  restartBut = [[UIButton alloc]init];
  [restartBut setBackgroundImage:[UIImage imageNamed:@"turqois"] forState:UIControlStateNormal];
  [restartBut setTitle:@"Restart" forState:UIControlStateNormal];
  [restartBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  restartBut.titleLabel.font = [UIFont systemFontOfSize:25];
  [restartBut addTarget:self action:@selector(restartGame) forControlEvents:UIControlEventTouchUpInside];
  helpScreenImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-32)];
  [helpScreenImage addTarget:self action:@selector(helpPage) forControlEvents:UIControlEventTouchUpInside];
  [helpScreenImage setBackgroundImage:[UIImage imageNamed:@"InformationPageUpdate@2x"] forState:UIControlStateNormal];
  helpScreenImage.alpha = 0;
  helpScreenImage.titleLabel.font = [UIFont systemFontOfSize:25];
  [helpScreenImage addTarget:self action:@selector(removeHelpPage) forControlEvents:UIControlEventTouchUpInside];
  helpScreenImage.enabled = TRUE;
  menuBut = [[UIButton alloc]init];
  [menuBut setTitle:@"Help" forState:UIControlStateNormal];
  [menuBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  menuBut.titleLabel.font = [UIFont systemFontOfSize:25];
  [menuBut addTarget:self action:@selector(helpPage) forControlEvents:UIControlEventTouchUpInside];
  [menuBut setExclusiveTouch:YES];
  
  shareButton = [[UIButton alloc]init];
  [shareButton setTitle:@"Share" forState:UIControlStateNormal];
  [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  shareButton.titleLabel.font = [UIFont systemFontOfSize:25];
  [shareButton setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
  [shareButton addTarget:self action:@selector(runShareGame:) forControlEvents:UIControlEventTouchUpInside];
  [shareButton setExclusiveTouch:YES];
  
  backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.9, 50)];
  [backButton setTitle:@"Back" forState:UIControlStateNormal];
  [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  backButton.titleLabel.font = [UIFont systemFontOfSize:30];
  [backButton setBackgroundImage:[UIImage imageNamed:@"turqois"] forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
  [backButton setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.81)];
  [backButton setAlpha:0];
  [backButton setExclusiveTouch:YES];
  
  moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
  [moreButton setTitle:@"More" forState:UIControlStateNormal];
  [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  moreButton.titleLabel.font = [UIFont systemFontOfSize:30];
  [moreButton setBackgroundImage:[UIImage imageNamed:@"organe"] forState:UIControlStateNormal];
  [moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [moreButton setCenter:CGPointMake(self.view.frame.size.width*0.9-10, self.view.frame.size.height*0.1)];
  [moreButton setAlpha:0];
  [moreButton setExclusiveTouch:YES];
  
  lessButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
  [lessButton setTitle:@"Less" forState:UIControlStateNormal];
  [lessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  lessButton.titleLabel.font = [UIFont systemFontOfSize:30];
  [lessButton setBackgroundImage:[UIImage imageNamed:@"organe"] forState:UIControlStateNormal];
  [lessButton addTarget:self action:@selector(lessButtonAction) forControlEvents:UIControlEventTouchUpInside];
  [lessButton setCenter:CGPointMake(self.view.frame.size.width*0.9-10, self.view.frame.size.height*0.1)];
  [lessButton setAlpha:0];
  [lessButton setExclusiveTouch:YES];
  
  
  //animal buttons
  sheepButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 72)];
  [sheepButton setTitle:@"2000" forState:UIControlStateNormal];
  [sheepButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  sheepButton.titleLabel.font = [UIFont systemFontOfSize:20];
  [sheepButton setBackgroundImage:[UIImage imageNamed:@"largeSheep"] forState:UIControlStateNormal];
  [sheepButton setBackgroundImage:[UIImage imageNamed:@"whiteSheepFix@2x"] forState:UIControlStateDisabled];
  [sheepButton addTarget:self action:@selector(selectSheep) forControlEvents:UIControlEventTouchUpInside];
  [sheepButton setCenter:CGPointMake(self.view.frame.size.width*0.285714, self.view.frame.size.height*0.5)];
  [sheepButton setAlpha:0];
  sheepButton.enabled = FALSE;
  
  penguinButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
  [penguinButton setBackgroundImage:[UIImage imageNamed:@"largePenguin"] forState:UIControlStateNormal];
  [penguinButton addTarget:self action:@selector(selectPenguin) forControlEvents:UIControlEventTouchUpInside];
  [penguinButton setCenter:CGPointMake(self.view.frame.size.width*0.142857, self.view.frame.size.height*0.5)];
  [penguinButton setAlpha:0];
  
  mooseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 70)];
  [mooseButton setTitle:@"6000" forState:UIControlStateNormal];
  [mooseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  mooseButton.titleLabel.font = [UIFont systemFontOfSize:20];
  [mooseButton setBackgroundImage:[UIImage imageNamed:@"largeMoose"] forState:UIControlStateNormal];
  [mooseButton setBackgroundImage:[UIImage imageNamed:@"whiteMooseFix6@2x"] forState:UIControlStateDisabled];
  [mooseButton addTarget:self action:@selector(selectMoose) forControlEvents:UIControlEventTouchUpInside];
  [mooseButton setCenter:CGPointMake(self.view.frame.size.width*0.142857, self.view.frame.size.height*0.5)];
  [mooseButton setAlpha:0];
  mooseButton.enabled = FALSE;
  
  goatButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 73)];
  [goatButton setTitle:@"4000 " forState:UIControlStateNormal];
  [goatButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  goatButton.titleLabel.font = [UIFont systemFontOfSize:20];
  [goatButton setBackgroundImage:[UIImage imageNamed:@"largeGoatFix"] forState:UIControlStateNormal];
  [goatButton setBackgroundImage:[UIImage imageNamed:@"whiteGoatFix@2x"] forState:UIControlStateDisabled];
  [goatButton addTarget:self action:@selector(selectgoat) forControlEvents:UIControlEventTouchUpInside];
  [goatButton setCenter:CGPointMake(self.view.frame.size.width*0.571428, self.view.frame.size.height*0.5)];
  [goatButton setAlpha:0];
  goatButton.enabled = FALSE;
  
  beeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 73)];
  [beeButton setTitle:@"6500" forState:UIControlStateNormal];
  [beeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  beeButton.titleLabel.font = [UIFont systemFontOfSize:20];
  [beeButton setBackgroundImage:[UIImage imageNamed:@"largeBee"] forState:UIControlStateNormal];
  [beeButton setBackgroundImage:[UIImage imageNamed:@"whiteBee"] forState:UIControlStateDisabled];
  [beeButton addTarget:self action:@selector(selectBee) forControlEvents:UIControlEventTouchUpInside];
  [beeButton setCenter:CGPointMake(self.view.frame.size.width*0.285714, self.view.frame.size.height*0.5)];
  [beeButton setAlpha:0];
  beeButton.enabled = FALSE;
  
  
  beaverButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 68, 75)];
  [beaverButton setTitle:@" 7500" forState:UIControlStateNormal];
  [beaverButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  beaverButton.titleLabel.font = [UIFont systemFontOfSize:20];
  [beaverButton setBackgroundImage:[UIImage imageNamed:@"largeBeaver"] forState:UIControlStateNormal];
  [beaverButton setBackgroundImage:[UIImage imageNamed:@"whiteBeaver"] forState:UIControlStateDisabled];
  [beaverButton addTarget:self action:@selector(selectBeaver) forControlEvents:UIControlEventTouchUpInside];
  [beaverButton setCenter:CGPointMake(self.view.frame.size.width*0.571428, self.view.frame.size.height*0.5)];
  [beaverButton setAlpha:0];
  beaverButton.enabled = FALSE;
  
  goldPenguinButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 68, 73)];
  [goldPenguinButton setTitle:@"10000" forState:UIControlStateNormal];
  [goldPenguinButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  goldPenguinButton.titleLabel.font = [UIFont systemFontOfSize:20];
  [goldPenguinButton setBackgroundImage:[UIImage imageNamed:@"largeGoldPenguin"] forState:UIControlStateNormal];
  [goldPenguinButton setBackgroundImage:[UIImage imageNamed:@"whiteGoldPenguin"] forState:UIControlStateDisabled];
  [goldPenguinButton addTarget:self action:@selector(selectGoldPenguin) forControlEvents:UIControlEventTouchUpInside];
  [goldPenguinButton setCenter:CGPointMake(self.view.frame.size.width*0.85714, self.view.frame.size.height*0.5)];
  [goldPenguinButton setAlpha:0];
  goldPenguinButton.enabled = FALSE;
  
  pigButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 68, 73)];
  [pigButton setTitle:@"3000  " forState:UIControlStateNormal];
  [pigButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  pigButton.titleLabel.font = [UIFont systemFontOfSize:20];
  [pigButton setBackgroundImage:[UIImage imageNamed:@"largePig"] forState:UIControlStateNormal];
  [pigButton setBackgroundImage:[UIImage imageNamed:@"whitePigFix@2x"] forState:UIControlStateDisabled];
  [pigButton addTarget:self action:@selector(selectPig) forControlEvents:UIControlEventTouchUpInside];
  [pigButton setCenter:CGPointMake(self.view.frame.size.width*0.43857, self.view.frame.size.height*0.5)];
  [pigButton setAlpha:0];
  pigButton.enabled = FALSE;
  
  
  elephantButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
  [elephantButton setTitle:@"7000" forState:UIControlStateNormal];
  [elephantButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  elephantButton.titleLabel.font = [UIFont systemFontOfSize:20];
  [elephantButton setBackgroundImage:[UIImage imageNamed:@"largeElephant"] forState:UIControlStateNormal];
  [elephantButton setBackgroundImage:[UIImage imageNamed:@"whiteElephant1"] forState:UIControlStateDisabled];
  [elephantButton addTarget:self action:@selector(selectElephant) forControlEvents:UIControlEventTouchUpInside];
  [elephantButton setCenter:CGPointMake(self.view.frame.size.width*0.43857, self.view.frame.size.height*0.5)];
  [elephantButton setAlpha:0];
  elephantButton.enabled = FALSE;
  
  
  owlButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 68.5)];
  [owlButton setTitle:@"5000" forState:UIControlStateNormal];
  [owlButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  owlButton.titleLabel.font = [UIFont systemFontOfSize:20];
  [owlButton setBackgroundImage:[UIImage imageNamed:@"largeOwl"] forState:UIControlStateNormal];
  [owlButton setBackgroundImage:[UIImage imageNamed:@"whiteOwlFix3@2x"] forState:UIControlStateDisabled];
  [owlButton addTarget:self action:@selector(selectOwl) forControlEvents:UIControlEventTouchUpInside];
  [owlButton setCenter:CGPointMake(self.view.frame.size.width*0.714285, self.view.frame.size.height*0.5)];
  [owlButton setAlpha:0];
  owlButton.enabled = FALSE;
  
  giraffeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 86)];
  [giraffeButton setTitle:@"8000" forState:UIControlStateNormal];
  [giraffeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  giraffeButton.titleLabel.font = [UIFont systemFontOfSize:20];
  [giraffeButton setBackgroundImage:[UIImage imageNamed:@"largeGiraffe"] forState:UIControlStateNormal];
  [giraffeButton setBackgroundImage:[UIImage imageNamed:@"whiteGiraffeFix@2x"] forState:UIControlStateDisabled];
  [giraffeButton addTarget:self action:@selector(selectGiraffe) forControlEvents:UIControlEventTouchUpInside];
  [giraffeButton setCenter:CGPointMake(self.view.frame.size.width*0.714285, self.view.frame.size.height*0.5)];
  [giraffeButton setAlpha:0];
  giraffeButton.enabled = FALSE;
  
  
  hippoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 75)];
  [hippoButton setTitle:@"5500" forState:UIControlStateNormal];
  [hippoButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  hippoButton.titleLabel.font = [UIFont systemFontOfSize:20];
  [hippoButton setBackgroundImage:[UIImage imageNamed:@"largeHippo"] forState:UIControlStateNormal];
  [hippoButton setBackgroundImage:[UIImage imageNamed:@"whiteHippoFix@2x"] forState:UIControlStateDisabled];
  [hippoButton addTarget:self action:@selector(selectHippo) forControlEvents:UIControlEventTouchUpInside];
  [hippoButton setCenter:CGPointMake(self.view.frame.size.width*0.85714, self.view.frame.size.height*0.5)];
  [hippoButton setAlpha:0];
  hippoButton.enabled = FALSE;
  
  characterSelected = [[UILabel alloc]init];
  characterSelected.textColor = [UIColor whiteColor];
  characterSelected.font = [UIFont systemFontOfSize:25];
  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
  [characterSelected sizeToFit];
  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
  [characterSelected setAlpha:0];
  
  characterTitle = [[UILabel alloc]init];
  characterTitle.textColor = [UIColor yellowColor];
  characterTitle.font = [UIFont systemFontOfSize:25];
  characterTitle.text = [NSString stringWithFormat:@"Achieve shown score to unlock:"];
  [characterTitle sizeToFit];
  [characterTitle setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.28)];
  [characterTitle setAlpha:0];
  
  [self.view addSubview:pauseScreen];
  [self.view addSubview:menuBut ];
  [self.view addSubview:restartBut ];
  [self.view addSubview:shareButton];
  [self.view addSubview:backButton];
  [self.view addSubview:sheepButton];
  [self.view addSubview:owlButton];
  [self.view addSubview:hippoButton];
  [self.view addSubview:goatButton];
  [self.view addSubview:pigButton];
  [self.view addSubview:penguinButton];
  [self.view addSubview:characterSelected];
  [self.view addSubview:characterTitle];
  [self.view addSubview:moreButton];
  [self.view addSubview:lessButton];
  [self.view addSubview:goldPenguinButton];
  [self.view addSubview:giraffeButton];
  [self.view addSubview:beaverButton];
  [self.view addSubview:elephantButton];
  [self.view addSubview:beeButton];
  [self.view addSubview:mooseButton];
  
  
  [shareButton setAlpha:0];
  [pauseScreen setAlpha:0];
  [restartBut setAlpha:0];
  [menuBut setAlpha:0];
  [pause setAlpha:0];
  
  //initial physics
  clockTime = 0;
  self.physicsWorld.gravity = CGVectorMake(0, 0);
  self.physicsWorld.contactDelegate = self;
  
  //MutableArray ---> instert enemy image name in this array
  enemyList = [NSMutableArray arrayWithObjects:@"sombrero",@"taco",@"burritoTest",@"maracas",@"poncho",@"moustache",@"chanclas",@"mexicanScaled@2x",@"cactus", nil];
  
  //delayTimeLabel
  delayTimeLabel = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5-100, self.view.frame.size.height*0.5, 200, 50)];
  [delayTimeLabel setBackgroundColor:[UIColor clearColor]];
  [delayTimeLabel setTitle:@"+1 DIFFICULTY" forState:UIControlStateNormal];
  [delayTimeLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  delayTimeLabel.titleLabel.font = [UIFont systemFontOfSize:20];
  [self.view addSubview:delayTimeLabel ];
  [delayTimeLabel setAlpha:0];
  delayTimeLabel.enabled = NO;
  
  plus1lifeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 800, 200)];
  [plus1lifeButton setBackgroundColor:[UIColor clearColor]];
  [plus1lifeButton setTitle:@"EXTRA LIFE" forState:UIControlStateNormal];
  [plus1lifeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  plus1lifeButton.titleLabel.font = [UIFont systemFontOfSize:40];
  [plus1lifeButton setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.3)];
  [self.view addSubview:plus1lifeButton ];
  [plus1lifeButton setAlpha:0];
  plus1lifeButton.enabled = NO;
  
  
  
  
  
  //rotationLabel & speedTimeLabel & plus100 Button
  rotationLabel = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5-100, self.view.frame.size.height*0.5-25, 200, 50)];
  [rotationLabel setBackgroundColor:[UIColor clearColor]];
  [rotationLabel setTitle:@"+1 ENEMY ROTATION" forState:UIControlStateNormal];
  [rotationLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  rotationLabel.titleLabel.font = [UIFont systemFontOfSize:20];
  [self.view addSubview:rotationLabel ];
  [rotationLabel setAlpha:0];
  rotationLabel.enabled = NO;
  
  plus100Button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5+32, self.view.frame.size.height*0.03-5, 200, 50)];
  [plus100Button setBackgroundColor:[UIColor clearColor]];
  [plus100Button setTitle:@"+175" forState:UIControlStateNormal];
  [plus100Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  plus100Button.titleLabel.font = [UIFont systemFontOfSize:25];
  [self.view addSubview:plus100Button];
  [plus100Button setAlpha:0];
  plus100Button.enabled = NO;
  
  speedTimeLabel = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5-100, self.view.frame.size.height*0.5-50, 200, 50)];
  [speedTimeLabel setBackgroundColor:[UIColor clearColor]];
  [speedTimeLabel setTitle:@"+1 SPEED" forState:UIControlStateNormal];
  [speedTimeLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  speedTimeLabel.titleLabel.font = [UIFont systemFontOfSize:20];
  [self.view addSubview:speedTimeLabel ];
  [speedTimeLabel setAlpha:0];
  speedTimeLabel.enabled = NO;
  
  
  //background initilization
  SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"desert_night"]; //desert_day
  background.zPosition = -1.0;
  background.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height*0.5);
  background.xScale =((self.frame.size.width / background.size.width));
  if ((int)[[UIScreen mainScreen] bounds].size.width == 480){
    background.yScale = ((self.frame.size.height/ background.size.height));
  }else{
    background.yScale = ((self.frame.size.height/ background.size.height)/1.33333);
    
  }
  background.blendMode = SKBlendModeReplace;
  
  [self addChild:background];
  
  
  //start button
  start  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*1.2)];
  [start setTitle:@"Tap Screen To Start" forState:(UIControlStateNormal)];
  [start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [start addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
  start.titleLabel.font = [UIFont systemFontOfSize:30];
  [self.view addSubview:start];
  
  //tauntLabel
  tauntLabel = [[UILabel alloc]init];
  tauntLabel.text = [NSString stringWithFormat:@"Score above 200 to play as Trump!"];
  tauntLabel.textColor = [UIColor yellowColor];
  tauntLabel.font = [UIFont systemFontOfSize:20];
  [tauntLabel sizeToFit];
  [tauntLabel setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.3)];
  [tauntLabel setAlpha:0];
  [self.view addSubview:tauntLabel];
  
  AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  
  if(appDelegate.gameWasRunning==FALSE){
    
    //mainTimerLabel & bestScore Label
    mainTimerLabel = [[UILabel alloc]init];
    mainTimerLabel.text = [NSString stringWithFormat:@"Score: %d",score];
    mainTimerLabel.textColor = [UIColor whiteColor];
    mainTimerLabel.font = [UIFont systemFontOfSize:30];
    [mainTimerLabel sizeToFit];
    [mainTimerLabel setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.08)];
    
    //Flashing start game button animation
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=1.0;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.1];
    [start.layer addAnimation:theAnimation forKey:@"animateOpacity"];
  }
  
  
  
  bestScore= [[UILabel alloc]init];
  bestScore.text = [NSString stringWithFormat:@"Best: %ld",highScore];
  bestScore.textColor = [UIColor whiteColor];
  bestScore.font = [UIFont systemFontOfSize:30];
  [bestScore sizeToFit];
  [bestScore setAlpha:0];
  [bestScore setCenter:CGPointMake(self.view.frame.size.width*0.5-10, self.view.frame.size.height*0.19)];
  [self.view addSubview:bestScore];
  score = 0;
  
  //add main layer (use for holding other nodes)
  mainLayer = [[SKNode alloc] init];
  
  //hero node
  [self addChild:mainLayer];
  
  
  //testing
  
  characterName = @"trumpFace";
  hero = [SKSpriteNode spriteNodeWithImageNamed:characterName];
  hero.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
  hero.physicsBody = [SKPhysicsBody bodyWithTexture:hero.texture size:hero.texture.size];
  hero.physicsBody.dynamic=YES;
  hero.physicsBody.friction=NO;
  hero.physicsBody.allowsRotation=NO;
  hero.physicsBody.categoryBitMask = heroCategory;
  hero.physicsBody.contactTestBitMask = enemyCategory;
  hero.physicsBody.collisionBitMask = 0;
  hero.physicsBody.usesPreciseCollisionDetection = YES;
  [mainLayer addChild:hero];
  
  
  
  finger = [SKSpriteNode spriteNodeWithImageNamed:@"finger"];
  finger.position = CGPointMake(self.frame.size.width*0.5+150, self.frame.size.height*0.5-150);
  finger.xScale = 0.3;
  finger.yScale = 0.3;
  [mainLayer addChild:finger];
  
  
  angelPenguin = [SKSpriteNode spriteNodeWithImageNamed:@"TrumpwithWings@2x"];
  [mainLayer addChild:angelPenguin];
  //angelPenguin.xScale = 0.25;
  //angelPenguin.yScale = 0.25;
  angelPenguin.alpha = 0;
  
  
  
  //fish node
  
  fish = [SKSpriteNode spriteNodeWithImageNamed:@"money"];
  fish.physicsBody = [SKPhysicsBody bodyWithTexture:fish.texture size:fish.texture.size];
  fish.physicsBody.dynamic=YES;
  fish.physicsBody.friction=NO;
  fish.physicsBody.allowsRotation=NO;
  fish.physicsBody.categoryBitMask = fishCategory;
  fish.physicsBody.contactTestBitMask = heroCategory;
  fish.physicsBody.collisionBitMask = 0;
  fish.physicsBody.usesPreciseCollisionDetection = YES;
  
  //fishBone and blood splatter
  fishBone = [SKSpriteNode spriteNodeWithImageNamed:@"coins"];
  fadeOut = [SKAction fadeOutWithDuration:3];
  bloodSplatter= [SKSpriteNode spriteNodeWithImageNamed:@"bloodSplat"];
  
  //powerUp node
  powerUp = [SKSpriteNode spriteNodeWithImageNamed:@"brick wall"];
  powerUp.physicsBody = [SKPhysicsBody bodyWithTexture:powerUp.texture size:powerUp.texture.size];
  powerUp.physicsBody.dynamic=YES;
  powerUp.physicsBody.friction=NO;
  powerUp.physicsBody.allowsRotation=NO;
  powerUp.physicsBody.categoryBitMask = powerUpCategory;
  powerUp.physicsBody.contactTestBitMask = heroCategory;
  powerUp.physicsBody.collisionBitMask = 0;
  powerUp.physicsBody.usesPreciseCollisionDetection = YES;
  
  
  //title label
  
  gameTitleLabel = [[UILabel alloc]init];
  gameTitleLabel.text = [NSString stringWithFormat:@"Trumpa Dodge"];
  gameTitleLabel.textColor = [UIColor whiteColor];
  gameTitleLabel.font = [UIFont systemFontOfSize:55];
  [gameTitleLabel setShadowColor:[UIColor blackColor]];
  [gameTitleLabel setShadowOffset:CGSizeMake(2, 2)];
  [gameTitleLabel sizeToFit];
  [gameTitleLabel setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.center.y*0.5)];
  
  [self.view addSubview:gameTitleLabel];
  
  [self.view addSubview:helpScreenImage];
  
  [self.view addSubview:soundButton];
  
  
  instructionAnimation = [SKAction sequence:@[    [SKAction moveTo:CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5) duration:0], [SKAction fadeAlphaTo:1 duration:0.5],
                                                  [SKAction moveTo:CGPointMake(self.frame.size.width*0.25, self.frame.size.height*0.6) duration:3],
                                                  [SKAction waitForDuration:0.5], [SKAction fadeAlphaTo:0 duration:(0.5)]
                                                  ]];
  SKAction *repeat = [SKAction repeatActionForever:instructionAnimation];
  [hero runAction:repeat];
  
  SKAction *fingerAction = [SKAction sequence:@[   [SKAction moveTo:CGPointMake(self.frame.size.width*0.5+150, self.frame.size.height*0.5-150) duration:0],[SKAction fadeAlphaTo:1 duration:0.5],
                                                   [SKAction moveTo:CGPointMake(self.frame.size.width*0.25+150, self.frame.size.height*0.6-150) duration:3],
                                                   [SKAction waitForDuration:0.5], [SKAction fadeAlphaTo:0 duration:(0.5)]
                                                   ]];
  SKAction *repeat2 = [SKAction repeatActionForever:fingerAction];
  [finger runAction:repeat2];
  
  
  
}//didMoveToView-----------------------------------------------------------------------------------------------------------

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
  
  for (UITouch *touch in touches) {
    if(mainLayer.speed>0){
      CGPoint location = [touch locationInNode:self];
      int deltax = location.x+dx;
      int deltay = location.y+dy;
      
      
      hero.position = CGPointMake(deltax,deltay);
      
    }
  }
  
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
  for (UITouch *touch in touches) {
    if(mainLayer.speed>0){
      CGPoint location = [touch locationInNode:self];
      dx=hero.position.x-location.x;
      dy=hero.position.y-location.y;
      
    }
  }
}//touchesBegan-----------------------------------------------------------------------------------------------------------

-(int)getRanNum: (int) boundary{
  
  return (arc4random()%boundary);
}//getRanNum-----------------------------------------------------------------------------------------------------------


-(void)spawnEnemies{
  
  int num = [self getRanNum:(int)[enemyList count]];
  NSString *name = [enemyList objectAtIndex:num];
  enemy = [SKSpriteNode spriteNodeWithImageNamed:name];
  enemy.physicsBody = [SKPhysicsBody bodyWithTexture:enemy.texture size:(enemy.texture.size)];
  enemy.physicsBody.dynamic = YES;
  enemy.physicsBody.friction=NO;
  enemy.physicsBody.categoryBitMask = enemyCategory;
  enemy.physicsBody.contactTestBitMask = heroCategory;
  enemy.physicsBody.collisionBitMask = 0;
  
  enemy.name = @"enemy";
  
  int sideNum = [self getRanNum:10];
  int directionDeg;
  
  
  //deals with the placement of enemies
  if(sideNum<3){
    enemy.position = CGPointMake([self getRanNum:(self.frame.size.width)], (self.frame.size.height)+20);
    directionDeg = [self getRanNum:180]+180;
    
    
    
    
  }else if(sideNum<6){
    enemy.position = CGPointMake([self getRanNum:self.frame.size.width], -10);
    directionDeg = [self getRanNum:180];
    
    
  }else if(sideNum==6){
    enemy.position = CGPointMake(self.frame.size.width+15, [self getRanNum:self.frame.size.height]);
    directionDeg = [self getRanNum:180]+90;
    
  }else if (sideNum ==7){
    enemy.position = CGPointMake(-15, [self getRanNum:self.frame.size.height]);
    directionDeg = [self getRanNum:180]+270;
  }else if(sideNum ==8){
    enemy.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height+10);
    directionDeg = [self getRanNum:180]+180;
    
  }else{
    enemy.position = CGPointMake(self.frame.size.width*0.5, -10);
    directionDeg = (70+[self getRanNum:40]);
    
  }
  
  enemyDirection = degreesToVector(directionDeg);
  
  [mainLayer addChild:enemy];
  
  double rotAngle = (double)[self getRanNum:rotMax]/100;
  
  rotate = [SKAction rotateByAngle:(M_PI)*rotAngle duration:1];
  
  [enemy runAction:[SKAction repeatActionForever:rotate]];
  move = [SKAction moveBy:enemyDirection duration:((double)[self getRanNum:speedTime]/10000)+timeConstant];//0.005
  [enemy runAction:[SKAction repeatActionForever:move]];
  enemy.name = @"enemy";
  
  
}//spawnEnemies-----------------------------------------------------------------------------------------------------------


-(IBAction)startGame:(id)sender{
  //NSLog(@"start game");
  [hero removeAllActions];
  hero.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
  [finger removeAllActions];
  [finger removeFromParent];
  hero.alpha = 1;
  
  
  adDelayTime = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(triggerAd) userInfo:nil repeats:NO];
  
  
  hasBegan = TRUE;
  [UIView animateWithDuration:2.5 animations:^{
    gameTitleLabel.alpha = 0;
  }];;
  
  
  
  tauntLabel.alpha = 0;
  
  [self loadScore];
  clockTime = 0;
  mainTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addToScore) userInfo:nil repeats:YES];
  gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
  
  [self.view addSubview:mainTimerLabel];
  mainLayer.speed = 1;
  enemyTime = [NSTimer scheduledTimerWithTimeInterval:delayTime
                                               target:self selector:@selector(spawnEnemies)
                                             userInfo:nil
                                              repeats:YES];
  [enemyTime setTolerance:0.1];
  
  gunSpawnTimer = [NSTimer scheduledTimerWithTimeInterval:12 target:self selector:@selector(spawnGun) userInfo:nil repeats:YES];
  
  [start.layer removeAllAnimations];
  
  [start setAlpha:0.0];
  pause = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-75, self.view.frame.size.height*0.03, 60, 30)];
  
  [pause setAlpha:0.8];
  [pause setBackgroundImage:[UIImage imageNamed:@"pauseButton"]
                   forState:UIControlStateNormal];
  
  [pause addTarget:self action:@selector(pauseGame) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:pause];
  [pause setExclusiveTouch:YES];
  
}//startGame-----------------------------------------------------------------------------------------------------------


-(void)update:(CFTimeInterval)currentTime {
  
  if(hero.position.x<-3){
    hero.position = CGPointMake(0, hero.position.y);
  }
  
  
  if ((int)[[UIScreen mainScreen] bounds].size.width == 480){
    if(hero.position.y<self.frame.size.height*0.04){
      hero.position = CGPointMake(hero.position.x, self.frame.size.height*0.05);
    }
  }else{
    if(hero.position.y<self.frame.size.height*0.11){
      hero.position = CGPointMake(hero.position.x, self.frame.size.height*0.12);
    }
  }
  
  if(hero.position.x > self.frame.size.width+3){
    hero.position = CGPointMake(self.frame.size.width, hero.position.y);
  }
  
  if ((int)[[UIScreen mainScreen] bounds].size.width == 480){
    if(hero.position.y > self.frame.size.height*0.96){
      hero.position = CGPointMake(hero.position.x,self.frame.size.height*0.95);
    }
    
  }else{
    
    if(hero.position.y > self.frame.size.height*0.89){
      hero.position = CGPointMake(hero.position.x,self.frame.size.height*0.88);
    }
  }
  
}//updateTime-----------------------------------------------------------------------------------------------------------

-(void)pauseGame{
  //[[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
  if(score > highScore){
    [self changeScore:score];
    
  }
  
  bulletNode.physicsBody.velocity = CGVectorMake(0, 0);
  gunTestingPoint.physicsBody.velocity = CGVectorMake(0, 0);
  
//  if(!isMute){
//    if(genteMusicIsPlaying==FALSE){
//      [backgroundMusicIntense pause];
//    }
//    [backgroundMusicGentle play];
//  }
  
  isPaused = TRUE;
  restartBut.frame = CGRectMake(self.view.frame.size.width*0.51, self.view.frame.size.height*0.5, self.view.frame.size.width*0.44, 75);
  menuBut.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.5, self.view.frame.size.width*0.44-10, 75);
  [menuBut setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
  pauseGame = TRUE;
  [menuBut setAlpha:1];
  [pauseScreen setAlpha:0.75];
  [restartBut setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
  [restartBut setExclusiveTouch:YES];
  
  [enemyTime invalidate];
  [gameTimer invalidate];
  [mainTimer invalidate];
  [gunSpawnTimer invalidate];
  
  mainLayer.speed = 0;
  
  resume = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.5-100, self.view.frame.size.width*0.9, 75)];
  [resume setBackgroundImage:[UIImage imageNamed:@"turqois"] forState:UIControlStateNormal];
  [resume setTitle:@"Continue" forState:UIControlStateNormal];
  [resume setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [resume addTarget:self action:@selector(resumeGame) forControlEvents:UIControlEventTouchUpInside];
  resume.titleLabel.font = [UIFont systemFontOfSize:25];
  [pause setAlpha:0];
  [resume setExclusiveTouch:YES];
  
  
  [self.view addSubview:resume ];
  
  [restartBut setAlpha:1];
  
}//pauseGame-----------------------------------------------------------------------------------------------------------

-(void)resumeGame{
  if(!isMute){
    //if(genteMusicIsPlaying==FALSE){
//      [backgroundMusicIntense play];
//      [backgroundMusicGentle pause];
    //}
  }
  CGVector rotationVector;
  rotationVector = radiansToVector(gun.zRotation);
  bulletNode.physicsBody.velocity = CGVectorMake(rotationVector.dx*270, rotationVector.dy*270);
  gunTestingPoint.physicsBody.velocity = CGVectorMake(rotationVector.dx*270, rotationVector.dy*270);
  
  
  //[[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil]; //Sends message to viewcontroller to show ad.
  isPaused = FALSE;
  [pauseScreen setAlpha:0];
  [resume setAlpha:0];
  mainLayer.speed = 1;
  [pause setAlpha:0.8];
  enemyTime =[NSTimer scheduledTimerWithTimeInterval:delayTime
                                              target:self selector:@selector(spawnEnemies)
                                            userInfo:nil
                                             repeats:YES];
  
  gunSpawnTimer = [NSTimer scheduledTimerWithTimeInterval:12 target:self selector:@selector(spawnGun) userInfo:nil repeats:YES];
  
  [shareButton setAlpha:0];
  [menuBut setAlpha:0];
  [restartBut setAlpha:0];
  mainTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addToScore) userInfo:nil repeats:YES];
  gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
  
}//resumeGame-----------------------------------------------------------------------------------------------------------

-(void)stopTimer{
  [enemyTime invalidate];
  [gunSpawnTimer invalidate];
  
}//stopeTimer-----------------------------------------------------------------------------------------------------------

-(void) restartGame{
  plus1lifeButton.transform =CGAffineTransformMakeScale(1,1);
  canGetFirstLife = TRUE;
  lives = 0;
  angelPenguin.alpha = 0;
  gunIsOnScreen = FALSE;
  if(!isMute){
    //genteMusicIsPlaying = TRUE;
    //if(!genteMusicIsPlaying){
      [backgroundMusicGentle play];
      //[backgroundMusicIntense stop];
    //}
  }
  // [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil]; //Sends message to viewcontroller to show ad.
  tauntLabel.text = [NSString stringWithFormat:@"Score above 200 to get your %@ back next round!", characterName];
  [tauntLabel sizeToFit];
  [tauntLabel setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.3)];
  isPaused = FALSE;
  bestScore.textColor = [UIColor whiteColor];
  
  //change this to 200
  if(score<-1){
    isSausage = TRUE;
    hero.texture = [SKTexture textureWithImageNamed:@"theSaus"];
    hero.size = hero.texture.size;
    hero.physicsBody = [SKPhysicsBody bodyWithTexture:hero.texture size:hero.texture.size];
    hero.physicsBody.dynamic=YES;
    hero.physicsBody.friction=NO;
    hero.physicsBody.allowsRotation=NO;
    hero.physicsBody.categoryBitMask = heroCategory;
    hero.physicsBody.contactTestBitMask = enemyCategory;
    hero.physicsBody.collisionBitMask = 0;
    hero.physicsBody.usesPreciseCollisionDetection = YES;
    
  }else{
    isSausage = FALSE;
    hero.texture = [SKTexture textureWithImageNamed:characterName];
    hero.size = hero.texture.size;
    hero.physicsBody = [SKPhysicsBody bodyWithTexture:hero.texture size:hero.texture.size];
    hero.physicsBody.dynamic=YES;
    hero.physicsBody.friction=NO;
    hero.physicsBody.allowsRotation=NO;
    hero.physicsBody.categoryBitMask = heroCategory;
    hero.physicsBody.contactTestBitMask = enemyCategory;
    hero.physicsBody.collisionBitMask = 0;
    hero.physicsBody.usesPreciseCollisionDetection = YES;
  }
  
  if(fishSpawnBool==FALSE){
    [fish removeFromParent];
  }
  
  if(powerUpTimeBool==FALSE){
    [powerUp removeFromParent];
  }
  
  if(gameOverBool==TRUE){
    [mainLayer addChild:hero];
    gameOverBool=FALSE;
    [shareButton setAlpha:0];
    [bestScore setAlpha:0];
    
  }
  if(isSausage==TRUE)
    tauntLabel.alpha = 1;
  
  
  // NSLog(@"game restarted");
  [pauseScreen setAlpha:0];
  [shareButton setAlpha:0];
  [resume setAlpha:0];
  [menuBut setAlpha:0];
  [restartBut setAlpha:0];
  [start setAlpha:1];
  hero.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
  score=0;
  [mainTimer invalidate];
  [gameTimer invalidate];
  [mainLayer enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
  [mainLayer enumerateChildNodesWithName:@"bullet" usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
  [mainLayer enumerateChildNodesWithName:@"gunTestingPoint" usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
  
  
  [mainLayer enumerateChildNodesWithName:@"gun" usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
  
  theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
  theAnimation.duration=1.0;
  theAnimation.repeatCount=HUGE_VALF;
  theAnimation.autoreverses=YES;
  theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
  theAnimation.toValue=[NSNumber numberWithFloat:0.1];
  [start.layer addAnimation:theAnimation forKey:@"animateOpacity"];
  
  rotMax = initialrotMax;
  timeConstant = initialTimeConstant;
  speedTime = initialspeedTime;
  delayTime=initialdelayTime;
  
}//restartGame-----------------------------------------------------------------------------------------------------------

-(void)addToScore{
  score+=1;
  
}//addToScore-----------------------------------------------------------------------------------------------------------

-(void) didFinishUpdate{
  
  if(gunIsOnScreen==TRUE){
    if((hero.position.x-gun.position.x)>0){
      gun.zRotation = atan((hero.position.y-gun.position.y)/(hero.position.x-gun.position.x));
    }else{
      gun.zRotation = M_PI+atan((hero.position.y-gun.position.y)/(hero.position.x-gun.position.x));
    }
  }
  
  [mainLayer enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *node, BOOL *stop) {
    if ((node.position.x > self.frame.size.width*2)||(node.position.x<-500) || (node.position.y > self.frame.size.height*2)||(node.position.y<-500)) {
      [node removeFromParent];
    }
  }];
  
  [mainLayer enumerateChildNodesWithName:@"gun" usingBlock:^(SKNode *node, BOOL *stop) {
    if ((node.position.x > self.frame.size.width+200)||(node.position.x<-200) || (node.position.y > self.frame.size.height+200)||(node.position.y<-200)) {
      [node removeFromParent];
      gunIsOnScreen = FALSE;
    }
  }];
  [mainLayer enumerateChildNodesWithName:@"bullet" usingBlock:^(SKNode *node, BOOL *stop) {
    if ((node.position.x > self.frame.size.width*2)||(node.position.x<-700) || (node.position.y > self.frame.size.height*2)||(node.position.y<-700)) {
      [node removeFromParent];
    }
  }];
  [mainLayer enumerateChildNodesWithName:@"gunTestingPoint" usingBlock:^(SKNode *node, BOOL *stop) {
    if ((node.position.x > self.frame.size.width*2)||(node.position.x<-700) || (node.position.y > self.frame.size.height*2)||(node.position.y<-700)) {
      [node removeFromParent];
    }
  }];
  
  
  //Rotation
  if(!(clockTime==0)&&(clockTime%50==0) &&(rotMax<maxRot) && (rotLab==TRUE)){
    rotLab = FALSE;
    rotMax+=50;
    // NSLog(@"%d",rotMax);
    [rotationLabel setAlpha:0.9];
    rotationLabelTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fadeRotationLabel) userInfo:nil repeats:NO];
    delayForRotLab = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateForRotLab) userInfo:nil repeats:NO];
    // set to 60
  }
  //speedTime
  if(!(clockTime==0)&&(clockTime%40==0) &&(speedTime>speedTimeMax) && (speedTimeBOOL==TRUE)){
    speedTimeBOOL=FALSE;
    speedTime-=10;
    //NSLog(@"%d",speedTime);
    delayForSpeedTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fadeSpeedTimeLabel) userInfo:nil repeats:NO];
    speedTimeBOOLTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updatespeedTimeBOOL) userInfo:nil repeats:NO];
    
    [speedTimeLabel setAlpha:0.9];
    //set to 45
  }
  //timeConsant
  if(!(clockTime==0)&&(clockTime%80==0)&&(timeConstant>timeConstantMin) &&(timeConstantBool==TRUE)){
    timeConstantBool = FALSE;
    timeConstant -= 0.0005;
    //NSLog(@"%f",timeConstant);
    timeConstantBoolTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updatetimeConstantBool) userInfo:nil repeats:NO];
    //set to 100
    
  }
  
  //fish spawn function
  if(!(clockTime==0)&&(clockTime%100==0)&&(musicTransitionBool==TRUE)){
//    if(!isMute){
//      genteMusicIsPlaying = FALSE;
//      [backgroundMusicGentle stop];
//      [backgroundMusicIntense play];
//      musicTransitionBool=FALSE;
//    }
//    updateMusicTransitionBoolTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(updateMusicTranstionBool) userInfo:nil repeats:NO];
//    
    
  }
  if(!(clockTime==0)&&(clockTime%14==0)&&(fishSpawnBool==TRUE)){
    fish.alpha = 1;
    fishSpawnBool=FALSE;
    CGPoint fishPosition = CGPointMake([self getRanNum:self.frame.size.width]*0.7+100, [self getRanNum:(self.frame.size.height)]*0.55+190);
    fish.position = fishPosition;
    double angle = (double)[self getRanNum:100]/100;
    fishBone = [SKSpriteNode spriteNodeWithImageNamed:@"coins"];
    fish.zRotation = (M_PI)*angle;
    fishBone.zRotation =(M_PI)*angle;
    [mainLayer addChild:fish];
    [fish runAction: pulseFade withKey:@"pulseFade"];
    fishSpawnBoolTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(updatefishSpawnBool) userInfo:nil repeats:NO];
    
    //14
  }
  
  if(!(score==0)&&(score>1000)&&(canGetFirstLife==TRUE)){
    //change this to 3000 or 4000
    lives++;
    canGetFirstLife=FALSE;
    [self showExtraLife];
  }
  
  //delayTime
  if(!(clockTime==0)&&(clockTime%25==0)&&(delayTime>delayTimeMin) &&(delayTimeBool==TRUE)&&(collideBool==TRUE)&&(isPaused==FALSE)){
    delayTimeBool = FALSE;
    delayTime-=0.05;
    delayTimeLabelTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fadeDelayTimeLabel) userInfo:nil repeats:NO];
    delayTimeBBoolTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateDelaytimeBool) userInfo:nil repeats:NO];
    [delayTimeLabel setAlpha:1];
    [enemyTime invalidate];
    enemyTime = [NSTimer scheduledTimerWithTimeInterval:delayTime
                                                 target:self selector:@selector(spawnEnemies)
                                               userInfo:nil
                                                repeats:YES];
    //NSLog(@"delay time: %lf", delayTime);
    
    //set to 30
  }
  //powerUp
  if(!(clockTime==0)&&(clockTime%20==0)&&(powerUpTimeBool==TRUE)){
    powerUpTimeBool=FALSE;
    CGPoint powerUpPosition = CGPointMake([self getRanNum:self.frame.size.width]*0.7+100,[self getRanNum:(self.frame.size.height)]*0.55+190);
    powerUp.position = powerUpPosition;
    [mainLayer addChild:powerUp];
    powerUpBoolTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updatePowerUpBool) userInfo:nil repeats:NO];
    [powerUp runAction:pulseFade withKey:@"pulseFade"];
    //30
    
  }
  
  
  
  
  
  mainTimerLabel.text = [NSString stringWithFormat:@"Score: %d",score];
  [mainTimerLabel sizeToFit];
  
  
  
  
}//didFinishUpdate-----------------------------------------------------------------------------------------------------------

-(void)addBomb: (CGPoint) position{
  
  NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"ExplosionAnimation" ofType:@"sks"];
  SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
  explosion.position = position;
  [mainLayer addChild:explosion];
  
  SKAction *removeExposion = [SKAction sequence:@[[SKAction waitForDuration:4],[SKAction removeFromParent]]];
  [explosion runAction:removeExposion];
}//addBomb------------------------------------------------------------------------------------------



-(void)addFeathers: (CGPoint) position{
  if (soundEnabled==TRUE) {
    [poofSound play];
  }
  
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"toupeAnnimation" ofType:@"sks"];
  //NSLog(@"added feathers");
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}//addFeathers-----------------------------------------------------------------------------------------------------------


-(void)addBacon: (CGPoint) position{
  if (soundEnabled==TRUE) {
    [pigSound play];
  }
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"ExplosionAnimation2" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}//



-(void)addSheepAnimation: (CGPoint) position{
  if (soundEnabled==TRUE) {
    [sheepSound play];
  }
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"SheepAnimation" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}//

-(void)addGoatAnimation: (CGPoint) position{
  if (soundEnabled==TRUE) {
    [sheepSound play];
  }
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"goatAnimation" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}//


-(void)addBeeAnimation: (CGPoint) position{
  if (soundEnabled==TRUE) {
    [beeSound play];
  }
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"beeAnimation" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}//
-(void)addElephantAnimation: (CGPoint) position{
  if (soundEnabled==TRUE) {
    [elephantSound play];
  }
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"elephantAnimation" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}//
-(void)addBeaverAnimation: (CGPoint) position{
  if (soundEnabled==TRUE) {
    [woodSound play];
  }
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"beaverAnimation" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}
-(void)addGoldPenguinAnimation: (CGPoint) position{
  if (soundEnabled==TRUE) {
    [goldClink play];
  }
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"goldPenguinAnimation" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}
-(void)addGunshot: (CGPoint) position{
  if (soundEnabled==TRUE) {
    //add sound
  }
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"explosion" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}


-(void)addMooseAnimation: (CGPoint) position{
  if (soundEnabled==TRUE) {
    [mooseSound play];
  }
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"mooseAnimation" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}

-(void)addGiraffeAnimation: (CGPoint) position{
  if (soundEnabled==TRUE) {
    [leaveSound play];
  }
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"giraffeAnimation" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}//

-(void)addOwlAnimation: (CGPoint) position{
  if (soundEnabled==TRUE) {
    [poofSound play];
  }
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"owlAnimation" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}//

-(void)addHippoAnimation: (CGPoint) position{
  if (soundEnabled==TRUE) {
    [splashSound play];
  }
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"hippoAnimation" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}//


-(void)addbloodSplat: (CGPoint)position{
  if(soundEnabled==TRUE){
    [splatSound play];
  }
  
  bloodSplatter = [SKSpriteNode spriteNodeWithImageNamed:@"bloodSplat"];
  bloodSplatter.position = position;
  [mainLayer addChild:bloodSplatter];
  [bloodSplatter runAction:fadeOut];
  
}

-(void)addExplosion: (CGPoint) position{
  NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"moneyExplosion" ofType:@"sks"];
  SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
  explosion.position = position;
  [mainLayer addChild:explosion];
  SKAction *removeExposion = [SKAction sequence:@[[SKAction waitForDuration:4],[SKAction removeFromParent]]];
  [explosion runAction:removeExposion];
}//addExplosion-----------------------------------------------------------------------------------------------------------



-(void)fadeSpeedTimeLabel{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:3];
  [speedTimeLabel setAlpha:0];
  [UIView commitAnimations];
}//fadeSpeedTimeLabel-----------------------------------------------------------------------------------------------------------

-(void)fadeRotationLabel{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:3];
  [rotationLabel setAlpha:0];
  [UIView commitAnimations];
}//fadeRotaitonLabel-----------------------------------------------------------------------------------------------------------

-(void)fadeDelayTimeLabel{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:3];
  [delayTimeLabel setAlpha:0];
  [UIView commitAnimations];
}//fadeDelatTimeLabel-----------------------------------------------------------------------------------------------------------

-(void) fadePlus100Button{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:3];
  [plus100Button setAlpha:0];
  [UIView commitAnimations];
}//fadePluse100Button-----------------------------------------------------------------------------------------------------------

//UPDATE BOOLIANS-----------------------------------------------------------------------------------------------------------
-(void)updateForRotLab{
  rotLab = TRUE;
}
-(void)updatespeedTimeBOOL{
  speedTimeBOOL=TRUE;
}
-(void)updatetimeConstantBool{
  timeConstantBool=TRUE;
}

-(void)updateDelaytimeBool{
  delayTimeBool=TRUE;
}
-(void)updatefishSpawnBool{
  fishSpawnBool=TRUE;
  [fish removeFromParent];
  [fishBone removeFromParent];
}

-(void)updatePowerUpBool{
  powerUpTimeBool=TRUE;
  [powerUp removeFromParent];
}

-(void) updateFishTimerBool{
  fishDelayTimeBool=TRUE;
}
-(void)updatePowerUpdelayTimeBool{
  powerUpDelayTime = TRUE;
}


//UPDATE BOOLIANS-----------------------------------------------------------------------------------------------------------



-(void)tick{
  clockTime +=1;
}//tick-----------------------------------------------------------------------------------------------------------


- (void) didCollideWithMonster{
  NSLog(@"this ran");
  collideBool = FALSE;
  CGPoint deadPos = hero.position;
  //NSLog(@"hit");
  [hero removeFromParent];
  [mainTimer invalidate];
  [gameTimer invalidate];
  [enemyTime invalidate];
  [gunSpawnTimer invalidate];
  [self addFeathers:deadPos];
  [self addBacon:deadPos];
  
  /*
  
  if(isSausage==FALSE){
    
    
    if([characterName isEqualToString:@"penguin"]){
      [self addFeathers:deadPos];
    }else if([characterName isEqualToString:@"pig"]){
      [self addBacon:deadPos];
    }else if ([characterName isEqualToString:@"sheep"]){
      [self addSheepAnimation:deadPos];
    }else if([characterName isEqualToString:@"goat"]){
      [self addGoatAnimation: deadPos];
    }else if([characterName isEqualToString:@"owl"]){
      [self addOwlAnimation:deadPos];
    }else if ([characterName isEqualToString:@"hippo"]){
      [self addHippoAnimation:deadPos];
    }else if([characterName isEqualToString:@"bee"]){
      [self addBeeAnimation:deadPos];
    }else if ([characterName isEqualToString:@"moose"]){
      [self addMooseAnimation:deadPos];
    }else if ([characterName isEqualToString:@"giraffe"]){
      [self addGiraffeAnimation:deadPos];
      
    }else if ([characterName isEqualToString:@"elephant"]){
      [self addElephantAnimation:deadPos];
    }else if ([characterName isEqualToString:@"beaver"]){
      [self addBeaverAnimation:deadPos];
    }else{
      [self addGoldPenguinAnimation:deadPos];
    }
    
  }else{
    [self addbloodSplat:deadPos];
  }
   
  */
  [pause setAlpha:0];
  gameOverDelay = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(gameOver) userInfo:nil repeats:NO];
  
}//didCollideWithMonster-----------------------------------------------------------------------------------------------------------

- (void)didBeginContact:(SKPhysicsContact *)contact
{
  
  SKPhysicsBody *firstBody, *secondBody;
  
  if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
  {
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
  }
  else
  {
    firstBody = contact.bodyB;
    secondBody = contact.bodyA;
  }
  
  
  if ((firstBody.categoryBitMask & heroCategory) != 0 &&
      (secondBody.categoryBitMask & enemyCategory) != 0 && (collideBool == TRUE))
  {
    
    //comment out the following line to make hero invinsible
    if(lives==0){
      [self didCollideWithMonster];
    }else{
      [self didCollideWithNonLethal];
    }
  }
  
  if((firstBody.categoryBitMask & heroCategory) != 0 && (secondBody.categoryBitMask & fishCategory) !=0 && (fishDelayTimeBool == TRUE)){
    [self removeFish];
    fishBone.position = fish.position;
    
    [self didCollideWithFish];
    
    fishDelayTimeBool=FALSE;
    fishDelayTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(updateFishTimerBool) userInfo:nil repeats:NO];
    
  }
  
  if ((firstBody.categoryBitMask & heroCategory) != 0 &&
      (secondBody.categoryBitMask & powerUpCategory) != 0 && (powerUpDelayTime == TRUE))
  {
    
    [self didCollideWithPowerUp];
    powerUpdelayTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePowerUpdelayTimeBool) userInfo:nil repeats:NO];
    powerUpDelayTime = FALSE;
    
    
  }
}//didBeginContact-----------------------------------------------------------------------------------------------------------

-(void)gameOver{
  //[[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
  if((clockTime%14==0) || (clockTime%25==0) || (clockTime%40==0) || (clockTime%50==0)){
    clockTime+=3;
  }
  
  [restartBut setBackgroundImage:[UIImage imageNamed:@"turqois"] forState:UIControlStateNormal];
//  if(genteMusicIsPlaying==FALSE){
//    if(!isMute){
//      [backgroundMusicIntense stop];
//      [backgroundMusicGentle play];
//      // NSLog(@"intense music stopped");
//    }
//  }
  genteMusicIsPlaying = TRUE;
  angelPenguin.alpha = 0;
  lives = 0;
  
  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
  [characterSelected sizeToFit];
  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
  
  collideBool = TRUE;
  
  [bestScore sizeToFit];
  if(score > highScore){
    [self changeScore:score];
    bestScore.textColor = [UIColor redColor];
  }
  [self saveScore];
  
  //first if statement is iphone 6 plus size
  //else applies to everything else
  
  if ((int)[[UIScreen mainScreen] bounds].size.width > 700){
    restartBut.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.9-260, self.view.frame.size.width*0.9, 75);
    menuBut.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.9-80, self.view.frame.size.width*0.44, 75);
    shareButton.frame= CGRectMake(self.view.frame.size.width*0.51, self.view.frame.size.height*0.9-80, self.view.frame.size.width*0.44, 75);
  }else if ((int)[[UIScreen mainScreen] bounds].size.width > 600){
    restartBut.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.9-240, self.view.frame.size.width*0.9, 75);
    menuBut.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.9-60, self.view.frame.size.width*0.44, 75);
    shareButton.frame= CGRectMake(self.view.frame.size.width*0.51, self.view.frame.size.height*0.9-60, self.view.frame.size.width*0.44, 75);
  }else{
    restartBut.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.9-195, self.view.frame.size.width*0.9, 65);
    menuBut.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.9-55, self.view.frame.size.width*0.44, 50);
    shareButton.frame= CGRectMake(self.view.frame.size.width*0.51, self.view.frame.size.height*0.9-55, self.view.frame.size.width*0.44, 50);
    
  }
  
  [pause setAlpha:0];
  [bestScore setAlpha:1];
  gameOverBool = TRUE;
  [pauseScreen setAlpha:0.75];
  [menuBut setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
  [restartBut setAlpha:1];
  [menuBut setAlpha:1];
  [shareButton setAlpha:1];
  
  //NSLog(@"game over");
}//gameOver--------------------------------------------------------------------------------------------------------

-(void)removeFish{
  [fish removeFromParent];
  
}//removeFist-----------------------------------------------------------------------------------------------------------

-(void)didCollideWithFish{
  if (soundEnabled==TRUE) {
    [popSound play];
  }
  [fish removeActionForKey:@"pulseFade"];
  [mainLayer addChild:fishBone];
  [fishBone runAction:fadeOut];
  
  [self addExplosion:fish.position];
  score+=175;
  
  if(score<1000){
    plus100Button.center = CGPointMake(self.view.frame.size.width*0.5+118, self.view.frame.size.height*0.03+18);
  }else if (score <10000){
    plus100Button.center = CGPointMake(self.view.frame.size.width*0.5+130, self.view.frame.size.height*0.03+18);
  }else{
    plus100Button.center = CGPointMake(self.view.frame.size.width*0.5+142, self.view.frame.size.height*0.03+18);
  }
  [plus100Button setAlpha:0.9];
  plus100ButtonFadeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fadePlus100Button) userInfo:nil repeats:NO];
  
}//didCollideWithFish-----------------------------------------------------------------------------------------------------------


-(void)didCollideWithPowerUp{
  if(soundEnabled==TRUE){
    [explosionSound play];
  }
  [powerUp removeActionForKey:@"pulseFade"];
  CGPoint pos = powerUp.position;
  [self addBomb:pos];
  [powerUp removeFromParent];
  [mainLayer enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
  [mainLayer enumerateChildNodesWithName:@"bullet" usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
  [mainLayer enumerateChildNodesWithName:@"gunTestingPoint" usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
  [mainLayer enumerateChildNodesWithName:@"gun" usingBlock:^(SKNode *node, BOOL *stop) {
    [node removeFromParent];
  }];
  gunIsOnScreen = FALSE;
  
  //NSLog(@"did collide with powerup method was run!");
  
}//didCollideWithPowerUp-----------------------------------------------------------------------------------------------------------


-(IBAction)runShareGame:(id)sender{
  
  UIViewController *vc = self.view.window.rootViewController;
  
  if ([vc isKindOfClass:[GameViewController class]])
  {
    GameViewController *myViewController = (GameViewController *)vc;
    [myViewController shareGame];
  }
}//runShareGame------------------------------------------------------------------------------------------------


//UPDATE AND SAVE BEST SCORE-----------------------------------------------------------------------------------------------------------
-(void)changeScore:(int)Newscore{
  highScore = Newscore;
  bestScore.text = [NSString stringWithFormat:@"Best: %ld",highScore];
  [bestScore sizeToFit];
}

-(void)saveScore{
  [[NSUserDefaults standardUserDefaults] setInteger:highScore forKey:@"highScore"];
}

-(void)loadScore{
  highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
  bestScore.text = [NSString stringWithFormat:@"Best: %ld",highScore];
  
}

//UPDATE AND SAVE BEST SCORE-----------------------------------------------------------------------------------------------------

-(void)handleNotification: (NSNotification* )notification{
  if ([notification.name isEqualToString:@"pauseGame"] && (gameOverBool==FALSE) && (hasBegan == TRUE) && (isPaused == FALSE)) {
    [self pauseGame];
    
  }else if ([notification.name isEqualToString:@"gameOver"] && (gameOverBool==FALSE)){
    [self gameOver];
  }
  
  if ([notification.name isEqualToString:@"pauseMusic"] && (soundEnabled==TRUE)) {
//    if(!isMute){
//      [backgroundMusicIntense pause];
      [backgroundMusicGentle pause];
//    }
    
  }
  
  if([notification.name isEqualToString:@"playMusic"] && (soundEnabled == TRUE)){
    if(!isMute){
      [backgroundMusicGentle play];
    }
  }
}
-(void)helpPage{
  helpScreenImage.alpha = 1;
  mainTimerLabel.alpha=0;
  bestScore.alpha=0;
  if(isPaused)
    [resume setAlpha:0];
}
-(void)removeHelpPage{
  helpScreenImage.alpha = 0;
  mainTimerLabel.alpha=1;
  
  if(!isPaused)
    bestScore.alpha=1;
  if(isPaused)
    [resume setAlpha:1];
  
}
-(void)toggleSound{
  if(soundEnabled==TRUE){
    isMute = TRUE;
    soundEnabled=FALSE;
    //if(genteMusicIsPlaying){
      [backgroundMusicGentle pause];
    //}else{
    //  [backgroundMusicIntense pause];
    //}
  }else{
    isMute = FALSE;
    soundEnabled=TRUE;
   // if(genteMusicIsPlaying){
      [backgroundMusicGentle play];
   // }else{
    //  [backgroundMusicIntense play];
   // }
  }
}

-(void)triggerAd{
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil]; //Sends message to viewcontroller to show ad.
}

//-(void)changeCharacterPressed{
//  moreButton.alpha = 1;
//  [restartBut setAlpha:0];
//  [shareButton setAlpha:0];
//  [menuBut setAlpha:0];
//  [backButton setAlpha:1];
//  [sheepButton setAlpha:1];
//  [penguinButton setAlpha:1];
//  [goatButton setAlpha:1];
//  [hippoButton setAlpha:1];
//  [owlButton setAlpha:1];
//  [pigButton setAlpha:1];
//  characterSelected.alpha = 1;
//  characterTitle.alpha = 1;
//  
//  
//  if ((int)[[UIScreen mainScreen] bounds].size.width == 480){
//    [goatButton setFrame:CGRectMake(0, 0, 50, 52)];
//    [goatButton setCenter:CGPointMake(self.view.frame.size.width*0.57142, self.view.frame.size.height*0.5)];
//    [penguinButton setFrame:CGRectMake(0, 0, 50, 50)];
//    [penguinButton setCenter:CGPointMake(self.view.frame.size.width*0.142857, self.view.frame.size.height*0.5)];
//    [sheepButton setFrame:CGRectMake(0, 0, 50, 50)];
//    [sheepButton setCenter:CGPointMake(self.view.frame.size.width*0.28571, self.view.frame.size.height*0.5)];
//    [owlButton setFrame:CGRectMake(0, 0, 50, 50)];
//    [owlButton setCenter:CGPointMake(self.view.frame.size.width*0.714285, self.view.frame.size.height*0.5)];
//    [hippoButton setFrame:CGRectMake(0, 0, 50, 50)];
//    [hippoButton setCenter:CGPointMake(self.view.frame.size.width*0.85714, self.view.frame.size.height*0.5)];
//    [pigButton setFrame:CGRectMake(0, 0, 50, 50)];
//    [pigButton setCenter:CGPointMake(self.view.frame.size.width*0.438571, self.view.frame.size.height*0.5)];
//    
//  }
//  
//  if(highScore >= 5500){
//    hippoButton.enabled = TRUE;
//    [hippoButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//    // characterTitle.alpha = 0;
//  }
//  if (highScore >= 5000){
//    owlButton.enabled = TRUE;
//    [owlButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//  }
//  if (highScore >=4000){
//    goatButton.enabled = TRUE;
//    [goatButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//  }
//  if (highScore>=2000){
//    sheepButton.enabled = TRUE;
//    [sheepButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//  }
//  if (highScore>=3000){
//    pigButton.enabled = TRUE;
//    [pigButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//  }
//}

-(void)moreButtonAction{
  penguinButton.alpha = 0;
  moreButton.alpha = 0;
  sheepButton.alpha = 0;
  pigButton.alpha = 0;
  goatButton.alpha = 0;
  owlButton.alpha = 0;
  hippoButton.alpha = 0;
  lessButton.alpha = 1;
  goldPenguinButton.alpha = 1;
  giraffeButton.alpha = 1;
  beaverButton.alpha = 1;
  elephantButton.alpha = 1;
  beeButton.alpha = 1;
  mooseButton.alpha = 1;
  
  if ((int)[[UIScreen mainScreen] bounds].size.width == 480){
    [beaverButton setFrame:CGRectMake(0, 0, 50, 52)];
    [beaverButton setCenter:CGPointMake(self.view.frame.size.width*0.57142, self.view.frame.size.height*0.5)];
    [mooseButton setFrame:CGRectMake(0, 0, 57, 57)];
    [mooseButton setCenter:CGPointMake(self.view.frame.size.width*0.142857, self.view.frame.size.height*0.5)];
    [beeButton setFrame:CGRectMake(0, 0, 50, 60)];
    [beeButton setCenter:CGPointMake(self.view.frame.size.width*0.28571, self.view.frame.size.height*0.5)];
    [giraffeButton setFrame:CGRectMake(0, 0, 50, 68)];
    [giraffeButton setCenter:CGPointMake(self.view.frame.size.width*0.714285, self.view.frame.size.height*0.5)];
    [goldPenguinButton setFrame:CGRectMake(0, 0, 55, 55)];
    [goldPenguinButton setCenter:CGPointMake(self.view.frame.size.width*0.85714, self.view.frame.size.height*0.5)];
    [elephantButton setFrame:CGRectMake(0, 0, 50, 50)];
    [elephantButton setCenter:CGPointMake(self.view.frame.size.width*0.438571, self.view.frame.size.height*0.5)];
    
  }
  
  
  if(highScore>=10000){
    goldPenguinButton.enabled = TRUE;
    [goldPenguinButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
  }
  
  if(highScore>=8000){
    giraffeButton.enabled = TRUE;
    [giraffeButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
  }
  if (highScore>=7500) {
    beaverButton.enabled = TRUE;
    [beaverButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
  }
  if (highScore>=7000) {
    elephantButton.enabled = TRUE;
    [elephantButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
  }
  if (highScore>=6500) {
    beeButton.enabled = TRUE;
    [beeButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
  }
  if (highScore>=6000) {
    mooseButton.enabled = TRUE;
    [mooseButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
  }
  
}


-(void)goBack{
  moreButton.alpha = 0;
  [restartBut setAlpha:1];
  [shareButton setAlpha:1];
  [menuBut setAlpha:1];
  [backButton setAlpha:0];
  [sheepButton setAlpha:0];
  [penguinButton setAlpha:0];
  [goatButton setAlpha:0];
  [hippoButton setAlpha:0];
  [owlButton setAlpha:0];
  characterSelected.alpha = 0;
  characterTitle.alpha = 0;
  [pigButton setAlpha:0];
  lessButton.alpha = 0;
  goldPenguinButton.alpha = 0;
  giraffeButton.alpha = 0;
  beaverButton.alpha = 0;
  elephantButton.alpha = 0;
  beeButton.alpha = 0;
  mooseButton.alpha = 0;
  
}

-(void)lessButtonAction{
  moreButton.alpha = 1;
  lessButton.alpha = 0;
  [sheepButton setAlpha:1];
  [penguinButton setAlpha:1];
  [goatButton setAlpha:1];
  [hippoButton setAlpha:1];
  [owlButton setAlpha:1];
  [pigButton setAlpha:1];
  goldPenguinButton.alpha = 0;
  giraffeButton.alpha = 0;
  beaverButton.alpha = 0;
  elephantButton.alpha = 0;
  beeButton.alpha = 0;
  mooseButton.alpha = 0;
  
  if ((int)[[UIScreen mainScreen] bounds].size.width == 480){
    [goatButton setFrame:CGRectMake(0, 0, 50, 52)];
    [goatButton setCenter:CGPointMake(self.view.frame.size.width*0.57142, self.view.frame.size.height*0.5)];
    [penguinButton setFrame:CGRectMake(0, 0, 50, 50)];
    [penguinButton setCenter:CGPointMake(self.view.frame.size.width*0.142857, self.view.frame.size.height*0.5)];
    [sheepButton setFrame:CGRectMake(0, 0, 50, 50)];
    [sheepButton setCenter:CGPointMake(self.view.frame.size.width*0.28571, self.view.frame.size.height*0.5)];
    [owlButton setFrame:CGRectMake(0, 0, 50, 50)];
    [owlButton setCenter:CGPointMake(self.view.frame.size.width*0.714285, self.view.frame.size.height*0.5)];
    [hippoButton setFrame:CGRectMake(0, 0, 50, 50)];
    [hippoButton setCenter:CGPointMake(self.view.frame.size.width*0.85714, self.view.frame.size.height*0.5)];
    [pigButton setFrame:CGRectMake(0, 0, 50, 50)];
    [pigButton setCenter:CGPointMake(self.view.frame.size.width*0.438571, self.view.frame.size.height*0.5)];
    
  }
  
  if(highScore >= 5500){
    hippoButton.enabled = TRUE;
    [hippoButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    //characterTitle.alpha = 0;
  }
  if (highScore >= 5000){
    owlButton.enabled = TRUE;
    [owlButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
  }
  if (highScore >=4000){
    goatButton.enabled = TRUE;
    [goatButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
  }
  if (highScore>=2000){
    sheepButton.enabled = TRUE;
    [sheepButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
  }
  if (highScore>=3000){
    pigButton.enabled = TRUE;
    [pigButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
  }
  
}
//
//-(void)selectSheep{
//  characterName = @"sheep";
//  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
//  [characterSelected sizeToFit];
//  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
//}
//
//-(void)selectOwl{
//  characterName = @"owl";
//  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
//  [characterSelected sizeToFit];
//  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
//}
//
//-(void)selectPenguin{
//  characterName = @"trumpFace";
//  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
//  [characterSelected sizeToFit];
//  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
//}
//-(void)selectHippo{
//  characterName = @"hippo";
//  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
//  [characterSelected sizeToFit];
//  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
//}
//
//-(void)selectgoat{
//  characterName = @"goat";
//  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
//  [characterSelected sizeToFit];
//  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
//}
//
//-(void)selectPig{
//  characterName = @"pig";
//  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
//  [characterSelected sizeToFit];
//  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
//  
//  
//}
//
//-(void)selectGoldPenguin{
//  characterName = @"gold penguin";
//  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
//  [characterSelected sizeToFit];
//  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
//}
//-(void)selectGiraffe{
//  characterName = @"giraffe";
//  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
//  [characterSelected sizeToFit];
//  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
//}
//-(void)selectBeaver{
//  characterName = @"beaver";
//  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
//  [characterSelected sizeToFit];
//  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
//}
//-(void)selectElephant{
//  characterName = @"elephant";
//  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
//  [characterSelected sizeToFit];
//  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
//}
//-(void)selectBee{
//  characterName = @"bee";
//  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
//  [characterSelected sizeToFit];
//  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
//}
//-(void)selectMoose{
//  characterName = @"moose";
//  characterSelected.text = [NSString stringWithFormat:@"%@ selected", characterName];
//  [characterSelected sizeToFit];
//  [characterSelected setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.67)];
//}
//
//

-(void)updateMusicTranstionBool{
  musicTransitionBool = TRUE;
}

-(int)getRandomBool{
  return [self getRanNum:2];
}




-(void)spawnGun{
  
  
  
  gun = [SKSpriteNode spriteNodeWithImageNamed:@"gun"];
  gun.physicsBody = [SKPhysicsBody bodyWithTexture:gun.texture size:(gun.texture.size)];
  gun.physicsBody.dynamic = YES;
  gun.physicsBody.friction=NO;
  gun.physicsBody.categoryBitMask = enemyCategory;
  gun.physicsBody.contactTestBitMask = heroCategory;
  gun.physicsBody.collisionBitMask = 0;
  gun.name = @"gun";
  
  int sideNum = [self getRanNum:10];
  int directionDeg;
  gunIsOnScreen = TRUE;
  
  
  //deals with the placement of enemies
  if(sideNum<3){
    gun.position = CGPointMake([self getRanNum:(self.frame.size.width)], (self.frame.size.height)+20);
    directionDeg = [self getRanNum:180]+180;
    movingUp = FALSE;
  }else if(sideNum<6){
    gun.position = CGPointMake([self getRanNum:self.frame.size.width], -10);
    directionDeg = [self getRanNum:180];
    movingUp = TRUE;
    
  }else if(sideNum==6){
    gun.position = CGPointMake(self.frame.size.width+15, [self getRanNum:self.frame.size.height]);
    directionDeg = [self getRanNum:180]+90;
    if (directionDeg < 270) movingUp = TRUE;
    else movingUp = FALSE;
    
    
  }else if (sideNum ==7){
    gun.position = CGPointMake(-15, [self getRanNum:self.frame.size.height]);
    directionDeg = [self getRanNum:180]+270;
    if(directionDeg > 360) movingUp = TRUE;
    else movingUp = FALSE;
    
  }else if(sideNum ==8){
    gun.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height+10);
    directionDeg = [self getRanNum:180]+180;
    movingUp = FALSE;
    
  }else{
    gun.position = CGPointMake(self.frame.size.width*0.5, -10);
    directionDeg = (70+[self getRanNum:40]);
    movingUp = TRUE;
    
  }
  
  CGVector gunDirection = degreesToVector(directionDeg);
  
  [mainLayer addChild:gun];
  
  
  
  SKAction *gunMove =  [SKAction moveBy:gunDirection duration:0.007];//0.007
  [gun runAction:[SKAction repeatActionForever:gunMove]];
  
  bulletSpawnDelayTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(spawnBullet) userInfo:nil repeats:NO];
  //2
  
}
-(void)spawnBullet{
  //NSLog(@"%d",gunIsOnScreen);
  
  if ((gunIsOnScreen==TRUE) &&((gun.position.x > 0)&&(gun.position.x<self.frame.size.width)&&(gun.position.y>0)&&(gun.position.y<self.frame.size.height))) {
    
    
    
    bulletNode = [SKSpriteNode spriteNodeWithImageNamed:@"bulletSmall"];
    bulletNode.physicsBody = [SKPhysicsBody bodyWithTexture:bulletNode.texture size:bulletNode.texture.size];
    bulletNode.physicsBody.dynamic=YES;
    bulletNode.physicsBody.friction=NO;
    bulletNode.physicsBody.allowsRotation=NO;
    bulletNode.physicsBody.categoryBitMask = noCategory;
    bulletNode.physicsBody.contactTestBitMask = heroCategory;
    bulletNode.physicsBody.collisionBitMask = 0;
    bulletNode.physicsBody.usesPreciseCollisionDetection = YES;
    bulletNode.name = @"bullet";
    
    
    gunTestingPoint = [SKSpriteNode spriteNodeWithImageNamed:@"bulletSmall"];
    gunTestingPoint.physicsBody = [SKPhysicsBody bodyWithTexture:gunTestingPoint.texture size:gunTestingPoint.texture.size];
    gunTestingPoint.physicsBody.dynamic=YES;
    gunTestingPoint.physicsBody.friction=NO;
    gunTestingPoint.physicsBody.allowsRotation=NO;
    gunTestingPoint.physicsBody.categoryBitMask = enemyCategory;
    gunTestingPoint.physicsBody.contactTestBitMask = heroCategory;
    gunTestingPoint.physicsBody.collisionBitMask = 0;
    gunTestingPoint.physicsBody.usesPreciseCollisionDetection = YES;
    gunTestingPoint.name = @"gunTestingPoint";
    gunTestingPoint.position = CGPointMake(-55, -17);
    gunTestingPoint.alpha = 0;
    
    bulletNode.zRotation = gun.zRotation+M_PI;
    
    bulletNode.anchorPoint =CGPointMake(2.3, 1.5);
    
    
    bulletNode.position = gun.position;
    //[self addGunshot:gunTestingPoint.position]; doesnt work for some reason, not important
    
    CGVector rotationVector;
    
    rotationVector = radiansToVector(gun.zRotation);
    
    bulletNode.physicsBody.velocity = CGVectorMake(rotationVector.dx*270, rotationVector.dy*270);
    gunTestingPoint.physicsBody.velocity = CGVectorMake(rotationVector.dx*270, rotationVector.dy*270);
    [mainLayer addChild:bulletNode];
    [bulletNode addChild:gunTestingPoint];
    gunIsOnScreen = FALSE;
    
    
  }
}

-(void)didCollideWithNonLethal{
  lives--;
  [self removeExtraLife];
  collideBool = FALSE;
  updateCollideBoolTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateColideBool) userInfo:nil repeats:NO];
  CGPoint deadPos = hero.position;
  

}

-(void)updateColideBool{
  collideBool = TRUE;
}

-(void)showExtraLife{
  plus1lifeButton.alpha = 1;
  SKAction *angelPenguinAction;
  if ((int)[[UIScreen mainScreen] bounds].size.width == 480){
    angelPenguinAction = [SKAction sequence:@[   [SKAction moveTo:hero.position duration:0],[SKAction fadeAlphaTo:0.95 duration:0.2],
                                                 [SKAction moveTo:CGPointMake(self.frame.size.width*0.25,self.frame.size.height*0.83) duration:3.5]]];
    
  }else{
    angelPenguinAction = [SKAction sequence:@[   [SKAction moveTo:hero.position duration:0],[SKAction fadeAlphaTo:0.95 duration:0.2],
                                                 [SKAction moveTo:CGPointMake(self.frame.size.width*0.25,self.frame.size.height*0.75) duration:3.5]]];
  }
  [angelPenguin runAction:angelPenguinAction];
  plus1lifebuttonTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(fadePlus1LifeLabel) userInfo:nil repeats:NO];
}
-(void)removeExtraLife{
  SKAction *angelPenguinAction = [SKAction fadeOutWithDuration:1];
  [angelPenguin runAction:angelPenguinAction];
}

-(void)fadePlus1LifeLabel{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:3];
  plus1lifeButton.transform = CGAffineTransformMakeScale(2,2);
  [plus1lifeButton setAlpha:0];
  [UIView commitAnimations];
  
}
@end
