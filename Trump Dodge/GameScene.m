



#import "GameScene.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GameViewController.h"
#import "AppDelegate.h"
#import "Joystick.h"
#import <QuartzCore/QuartzCore.h>

@import Foundation;

static const uint32_t heroCategory     =  0x1 << 0;
static const uint32_t enemyCategory    =  0x1 << 1;
static const uint32_t fishCategory    =  0x1 << 2;
static const uint32_t powerUpCategory=  0x1 << 3;
static const uint32_t noCategory =      0X1 <<4;


int dx;
int dy;
int clockTime;
double initialdelayTime = 0.8;//
double delayTimeMin = 0.2;
double delayTime = 0.8;//start at 0.9
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
int numDeaths = 0;
int threshold = 2;
int lifeScore = 0;


BOOL gunIsOnScreen;
BOOL ponchoIsOnScreen;
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
BOOL ponchoEffectBool = TRUE;
BOOL canGetFirstLife = TRUE;
BOOL canGetLife = TRUE;


@implementation GameScene{
  
  AVAudioPlayer *mooseSound;
  AVAudioPlayer *beeSound;
  AVAudioPlayer *splashSound;
  AVAudioPlayer *sheepSound;
  AVAudioPlayer *pigSound;
  NSTimer *updateMusicTransitionBoolTimer;
  UIButton *pigButton;
  NSTimer *adDelayTime;
  AVAudioPlayer *goldClink;
  AVAudioPlayer *elephantSound;
  AVAudioPlayer *popSound;
  AVAudioPlayer *backgroundMusicGentle;
  AVAudioPlayer *quoteAudioPlayer;
  AVAudioPlayer *explosionSound;
  AVAudioPlayer *splatSound;
  AVAudioPlayer *poofSound;
  NSTimer *powerUpdelayTimer;
  NSTimer *powerUpBoolTimer;
  NSTimer *ponchoEffectBoolTimer;
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
  NSMutableArray *quoteList;
  CABasicAnimation *theAnimation;
  SKAction *move;
  UIButton *resume;
  UIView *pauseScreen;
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

  UIButton *soundButton;
  NSString *characterName;
  SKAction *instructionAnimation;
  SKSpriteNode *bulletNode;
  NSTimer *bulletSpawnDelayTimer;
  CGPoint *gunPosition;
  SKSpriteNode *gun;
  NSTimer *gunSpawnTimer;
  SKSpriteNode *gunTestingPoint;
  SKSpriteNode *angelTrump;
  NSTimer *updateCollideBoolTimer;
  AVAudioPlayer *woodSound;
  AVAudioPlayer *leaveSound;
  SKSpriteNode *poncho;
  NSTimer* ponchoTimer;
  NSMutableArray *quoteTimeList;
  NSTimer *startingMusicDelayTimer;
  NSTimer *fadeTimer;
  Joystick *joystick;
  CADisplayLink *velocityTick;
  NSTimer *canGetLifeTimer;
  NSTimer *resetPlus1ButtonTimer;
  UILabel *lifeLabel;
  
  
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
  
  
  [self playQuote]; 
  
  [self JoystickInit];
  
  NSString *path = [NSString stringWithFormat:@"%@/Dying.mp3", [[NSBundle mainBundle] resourcePath]];
  NSURL *soundUrl = [NSURL fileURLWithPath:path];
  poofSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
  poofSound.volume = 2.5;
  
  NSString *path2 = [NSString stringWithFormat:@"%@/splat.mp3", [[NSBundle mainBundle] resourcePath]];
  NSURL *soundUrl2 = [NSURL fileURLWithPath:path2];
  splatSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl2 error:nil];
  //[splatSound setVolume:0.1]; to adjust volume
  
  NSString *path3 = [NSString stringWithFormat:@"%@/explosion.mp3", [[NSBundle mainBundle] resourcePath]];
  NSURL *soundUrl3 = [NSURL fileURLWithPath:path3];
  explosionSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl3 error:nil];
  [explosionSound setVolume:1.5];
  
  
  
  NSString *path7 = [NSString stringWithFormat:@"%@/cash.mp3", [[NSBundle mainBundle] resourcePath]];
  NSURL *soundUrl7 = [NSURL fileURLWithPath:path7];
  popSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl7 error:nil];
  [popSound setVolume:1.5];
  
  
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
  restartBut.layer.borderColor = [UIColor whiteColor].CGColor;
  restartBut.layer.borderWidth = 2;
  
  shareButton = [[UIButton alloc]init];
  [shareButton setTitle:@"Share" forState:UIControlStateNormal];
  [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  shareButton.titleLabel.font = [UIFont systemFontOfSize:25];
  [shareButton setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
  [shareButton addTarget:self action:@selector(runShareGame:) forControlEvents:UIControlEventTouchUpInside];
  [shareButton setExclusiveTouch:YES];
  shareButton.layer.borderColor = [UIColor whiteColor].CGColor;
  shareButton.layer.borderWidth = 2;
  
  
  

  [self.view addSubview:pauseScreen];
  [self.view addSubview:restartBut ];
  [self.view addSubview:shareButton];
  
  [shareButton setAlpha:0];
  [pauseScreen setAlpha:0];
  [restartBut setAlpha:0];
  [pause setAlpha:0];
  
  //initial physics
  clockTime = 0;
  self.physicsWorld.gravity = CGVectorMake(0, 0);
  self.physicsWorld.contactDelegate = self;
  
  //MutableArray ---> instert enemy image name in this array
  enemyList = [NSMutableArray arrayWithObjects:@"moustache",@"democrat",@"hilary",@"ak",@"antiGun",@"obama",@"policeNoBG",@"hairspray",@"hairbrush",@"gavel",@"alien",@"bernie",@"taxes",@"weThePeeps",@"cnn",@"marcRubio",@"hillar",@"Republicanlogo",@"trumpUni", nil];
  
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
  start  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*1.3)];
  [start setTitle:@"Tap Screen To Start" forState:(UIControlStateNormal)];
  [start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [start addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
  start.titleLabel.font = [UIFont systemFontOfSize:30];
  [self.view addSubview:start];
  
  
  
 
  
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
  lifeScore = 0;
  
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
  
  
  angelTrump = [SKSpriteNode spriteNodeWithImageNamed:@"TrumpwithWings@2x"];
  [mainLayer addChild:angelTrump];
  //angelTrump.xScale = 0.25;
  //angelTrump.yScale = 0.25;
  angelTrump.alpha = 0;
  
  
  
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
  fishBone = [SKSpriteNode spriteNodeWithImageNamed:@"moneyBag"];
  fishBone.alpha = 0.9;
  fadeOut = [SKAction fadeOutWithDuration:3];
  
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
  
  lifeLabel = [[UILabel alloc]init];
  lifeLabel.text = [NSString stringWithFormat:@"X%d",lives];
  lifeLabel.textColor = [UIColor redColor];
  lifeLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:35];
    [lifeLabel sizeToFit];
  [lifeLabel setCenter:CGPointMake(self.view.frame.size.width*0.37, self.view.center.y*0.35)];
  lifeLabel.alpha = 0;
  [self.view addSubview:lifeLabel];
 
  
  
  
  //title label
  
  gameTitleLabel = [[UILabel alloc]init];
  gameTitleLabel.text = [NSString stringWithFormat:@"TRUMPA DODGE"];
  gameTitleLabel.textColor = [UIColor redColor];
  [gameTitleLabel setShadowColor:[UIColor whiteColor]];
  gameTitleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:65];
  [gameTitleLabel sizeToFit];
  [gameTitleLabel setCenter:CGPointMake(self.view.frame.size.width*0.5, self.view.center.y*0.5)];
  
  [self.view addSubview:gameTitleLabel];
  
  [self.view addSubview:soundButton];
  
  
  
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
    enemy.position = CGPointMake([self getRanNum:(self.frame.size.width)], (self.frame.size.height)+30);
    directionDeg = [self getRanNum:180]+180;
    
  }else if(sideNum<6){
    enemy.position = CGPointMake([self getRanNum:self.frame.size.width], -30);
    directionDeg = [self getRanNum:180];
    
    
  }else if(sideNum==6){
    enemy.position = CGPointMake(self.frame.size.width+25, [self getRanNum:self.frame.size.height]);
    directionDeg = [self getRanNum:180]+90;
    
  }else if (sideNum ==7){
    enemy.position = CGPointMake(-30, [self getRanNum:self.frame.size.height]);
    directionDeg = [self getRanNum:180]+270;
  }else if(sideNum ==8){
    enemy.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height+20);
    directionDeg = [self getRanNum:180]+180;
    
  }else{
    enemy.position = CGPointMake(self.frame.size.width*0.5, -25);
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
  hero.alpha = 1;
  
  //
  //  adDelayTime = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(triggerAd) userInfo:nil repeats:NO];
  
  
  hasBegan = TRUE;
  [UIView animateWithDuration:2.5 animations:^{
    gameTitleLabel.alpha = 0;
  }];;
  
  
  
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
  
  pause.layer.borderColor = [UIColor whiteColor].CGColor;
  pause.layer.borderWidth = 2;
  
}//startGame-----------------------------------------------------------------------------------------------------------


-(void)update:(CFTimeInterval)currentTime {
  
  if(hero.position.x<-3){
    hero.position = CGPointMake(0, hero.position.y);
  }
  
  [self joystickMovement];
  
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
  restartBut.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.5-75, self.view.frame.size.width*0.9, 75);
  pauseGame = TRUE;
  [pauseScreen setAlpha:0.75];
  [restartBut setBackgroundImage:[UIImage imageNamed:@"turqois"] forState:UIControlStateNormal];
  [restartBut setExclusiveTouch:YES];
  
  [enemyTime invalidate];
  [gameTimer invalidate];
  [mainTimer invalidate];
  [gunSpawnTimer invalidate];
  
  mainLayer.speed = 0;
  
  resume = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.5+25, self.view.frame.size.width*0.9, 75)];
  [resume setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
  [resume setTitle:@"Continue" forState:UIControlStateNormal];
  [resume setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [resume addTarget:self action:@selector(resumeGame) forControlEvents:UIControlEventTouchUpInside];
  resume.titleLabel.font = [UIFont systemFontOfSize:25];
  [pause setAlpha:0];
  [resume setExclusiveTouch:YES];
  resume.layer.borderColor = [UIColor whiteColor].CGColor;
  resume.layer.borderWidth = 2;
  
  
  
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
  [restartBut setAlpha:0];
  mainTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addToScore) userInfo:nil repeats:YES];
  gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
  
}//resumeGame-----------------------------------------------------------------------------------------------------------

-(void)stopTimer{
  [enemyTime invalidate];
  [gunSpawnTimer invalidate];
  
}//stopeTimer-----------------------------------------------------------------------------------------------------------

-(void) restartGame{
  //  [self requestAd];
  lifeLabel.alpha = 0;
  plus1lifeButton.transform =CGAffineTransformMakeScale(1,1);
  canGetFirstLife = TRUE;
  lives = 0;
  angelTrump.alpha = 0;
  gunIsOnScreen = FALSE;
  if(!isMute){
    //genteMusicIsPlaying = TRUE;
    //if(!genteMusicIsPlaying){
    [backgroundMusicGentle play];
    //[backgroundMusicIntense stop];
    //}
  }
  
  isPaused = FALSE;
  bestScore.textColor = [UIColor whiteColor];
  
  //change this to 200
  
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
 
  
  
  
  // NSLog(@"game restarted");
  [pauseScreen setAlpha:0];
  [shareButton setAlpha:0];
  [resume setAlpha:0];
  [restartBut setAlpha:0];
  [start setAlpha:1];
  hero.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
  score=0;
  lifeScore = 0;
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
  lifeScore+=1;
  
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
  
  
  if(!(clockTime==0)&&(clockTime%100==0)&&(musicTransitionBool==TRUE)){
    
    
  }
  if(!(clockTime==0)&&(clockTime%12==0)&&(fishSpawnBool==TRUE)){
    fish.alpha = 1;
    fishSpawnBool=FALSE;
    CGPoint fishPosition = CGPointMake([self getRanNum:self.frame.size.width]*0.7+100, [self getRanNum:(self.frame.size.height)]*0.55+190);
    fish.position = fishPosition;
    double angle = (double)[self getRanNum:100]/100;
    fishBone = [SKSpriteNode spriteNodeWithImageNamed:@"moneyBag"];
    fishBone.alpha = 0.9;
    fish.zRotation = (M_PI)*angle;
    fishBone.zRotation =(M_PI)*angle;
    [mainLayer addChild:fish];
    [fish runAction: pulseFade withKey:@"pulseFade"];
    fishSpawnBoolTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(updatefishSpawnBool) userInfo:nil repeats:NO];
    
    //14
  }
  
  if(!(lifeScore==0)&&(lifeScore>1000)&&(canGetLife==TRUE)){
  
    [self resetLifeScore];
    lives++;
    canGetLife = FALSE;
    canGetLifeTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateCanGetLife) userInfo:nil repeats:NO];
    if (canGetFirstLife){
      [self runAngelTrump];
    }
    lifeLabel.alpha = 1;
    lifeLabel.text = [NSString stringWithFormat:@"X%d",lives];
    [lifeLabel sizeToFit];
    canGetFirstLife=FALSE;
    [self showExtraLifelabel];
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
  if(!(clockTime==0)&&(clockTime%14==0)&&(powerUpTimeBool==TRUE)){
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
  
  NSString *explosionPath2 = [[NSBundle mainBundle] pathForResource:@"explosionFixed2" ofType:@"sks"];
  SKEmitterNode *explosion2 = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath2];
  explosion2.position = position;
  [mainLayer addChild:explosion2];
  SKAction *removeExposion2 = [SKAction sequence:@[[SKAction waitForDuration:10],[SKAction removeFromParent]]];
  [explosion2 runAction:removeExposion2];
  
}//

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
  if((clockTime%14==0) || (clockTime%25==0) || (clockTime%40==0) || (clockTime%50==0)){
    clockTime+=3;
  }
  
  numDeaths+=1;
  if (numDeaths==threshold){
    
    [self showAd];
    numDeaths = 0;
    threshold = [self getRanNum:2]+1;
    
  }
  //[restartBut setBackgroundImage:[UIImage imageNamed:@"turqois"] forState:UIControlStateNormal];
  
  genteMusicIsPlaying = TRUE;
  angelTrump.alpha = 0;
  lives = 0;
  
 
  collideBool = TRUE;
  
  [bestScore sizeToFit];
  if(score > highScore){
    [self changeScore:score];
    bestScore.textColor = [UIColor redColor];
  }
  [self saveScore];
  
  restartBut.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.5-75, self.view.frame.size.width*0.9, 75);
  shareButton.frame = CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.5+25, self.view.frame.size.width*0.9, 75);
  
  [pause setAlpha:0];
  [bestScore setAlpha:1];
  gameOverBool = TRUE;
  [pauseScreen setAlpha:0.75];
  [restartBut setAlpha:1];
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
  lifeScore+=175;
  
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

-(void)showAd{
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil]; //Sends message to viewcontroller to show ad.
}

//-(void)requestAd{
//  [[NSNotificationCenter defaultCenter] postNotificationName:@"requestAd" object:nil];
//
//}




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
    gun.position = CGPointMake([self getRanNum:(self.frame.size.width)], (self.frame.size.height)+25);
    directionDeg = [self getRanNum:180]+180;
    movingUp = FALSE;
  }else if(sideNum<6){
    gun.position = CGPointMake([self getRanNum:self.frame.size.width], -25);
    directionDeg = [self getRanNum:180];
    movingUp = TRUE;
    
  }else if(sideNum==6){
    gun.position = CGPointMake(self.frame.size.width+30, [self getRanNum:self.frame.size.height]);
    directionDeg = [self getRanNum:180]+90;
    if (directionDeg < 270) movingUp = TRUE;
    else movingUp = FALSE;
    
    
  }else if (sideNum ==7){
    gun.position = CGPointMake(-30, [self getRanNum:self.frame.size.height]);
    directionDeg = [self getRanNum:180]+270;
    if(directionDeg > 360) movingUp = TRUE;
    else movingUp = FALSE;
    
  }else if(sideNum ==8){
    gun.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height+25);
    directionDeg = [self getRanNum:180]+180;
    movingUp = FALSE;
    
  }else{
    gun.position = CGPointMake(self.frame.size.width*0.5, -25);
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
  if (lives == 0){
    canGetFirstLife = TRUE;
    lifeLabel.alpha = 0;
  [self removeExtraLife];
  }else{
    lifeLabel.text = [NSString stringWithFormat:@"X%d",lives];
  }
  CGPoint deadPos = hero.position;
  [self addBomb:deadPos];
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
  collideBool = FALSE;
  updateCollideBoolTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateColideBool) userInfo:nil repeats:NO];
  [self addFeathers:deadPos];

  
}

-(void)updateColideBool{
  collideBool = TRUE;
}

-(void)showExtraLifelabel{
  plus1lifeButton.alpha = 1;
  plus1lifebuttonTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(fadePlus1LifeLabel) userInfo:nil repeats:NO];
}
-(void)removeExtraLife{
  SKAction *angelTrumpAction = [SKAction fadeOutWithDuration:1];
  [angelTrump runAction:angelTrumpAction];
}

-(void)fadePlus1LifeLabel{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:3];
  plus1lifeButton.transform = CGAffineTransformMakeScale(2,2);
  [plus1lifeButton setAlpha:0];
  [UIView commitAnimations];
  resetPlus1ButtonTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(resetPlus1LifeButton) userInfo:nil repeats:NO];
}

-(void)resetPlus1LifeButton{
  plus1lifeButton.transform =CGAffineTransformMakeScale(1,1);
}


-(void)playQuote{
  
  quoteList = [NSMutableArray arrayWithObjects:@"%@/trumpQuote1.mp3",@"%@/trumpquote3.mp3",@"%@/trumpquote4.mp3",@"%@/trumpquote5.mp3",@"%@/trumpquote6.mp3",@"%@/trumpquote7.mp3",@"%@/trumpquote8.mp3",@"%@/trumpquote10.mp3",@"%@/trumpquote11.mp3",@"%@/trumpquote14.mp3",@"%@/trumpquote15.mp3",@"%@/trumpquote16.mp3", nil];
  int QuoteDelayList[15] = {2,3,4,3,2,3.5,2,4,5,2,5,5,2.5,2,2 };
  
  int num = [self getRanNum:(int)[quoteList count]];
  int quoteDelay = QuoteDelayList[num];
  NSString *quoteName = [quoteList objectAtIndex:num];
  NSString *quotePath = [NSString stringWithFormat:quoteName, [[NSBundle mainBundle] resourcePath]];
  NSURL *quoteUrl = [NSURL fileURLWithPath:quotePath];
  quoteAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:quoteUrl error:nil];
  [quoteAudioPlayer setVolume:2];
  [quoteAudioPlayer play];
  startingMusicDelayTimer = [NSTimer scheduledTimerWithTimeInterval:quoteDelay target:self selector:@selector(playBackgroundMusic) userInfo:nil repeats:NO];
  
}

-(void)playBackgroundMusic{
  
  NSString *path4 = [NSString stringWithFormat:@"%@/menuSong.mp3", [[NSBundle mainBundle] resourcePath]];
  NSURL *soundUrl4 = [NSURL fileURLWithPath:path4];
  backgroundMusicGentle = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl4 error:nil];
  [backgroundMusicGentle setNumberOfLoops:-1];
  [backgroundMusicGentle play];
  [backgroundMusicGentle setVolume:0];
  fadeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(increaseVolumeLevel) userInfo:nil repeats:YES];
  
}

-(void)increaseVolumeLevel{
  if(backgroundMusicGentle.volume < 0.3){
    [backgroundMusicGentle setVolume: backgroundMusicGentle.volume+0.01];
  }else{
    [fadeTimer invalidate];
  }
}


// Joystick Code
//

-(void)JoystickInit{
  
  SKSpriteNode *jsThumb = [SKSpriteNode spriteNodeWithImageNamed:@"joystick"];
  SKSpriteNode *jsBackdrop = [SKSpriteNode spriteNodeWithImageNamed:@"dpad"];
  joystick = [Joystick joystickWithThumb:jsThumb andBackdrop:jsBackdrop];
  joystick.position = CGPointMake((self.size.width - jsBackdrop.size.width * 0.5-self.size.width*0.1),(jsBackdrop.size.height * 0.5+self.size.height*.2));
  [self addChild:joystick];
  joystick.zPosition = 1;
  [joystick setScale:1.5];
}

-(id)init
{
  if (self = [super init])
  {
    velocityTick = [CADisplayLink displayLinkWithTarget:self selector:@selector(joystickMovement)];
    [velocityTick addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
  }
  return self;
}


-(void)joystickMovement
{
  if (joystick.velocity.x != 0 || joystick.velocity.y != 0)
  {
    hero.position = CGPointMake(hero.position.x + .15 *joystick.velocity.x, hero.position.y + .15 * joystick.velocity.y);
  }
}

-(void)updatePonchoEffectBool{
  ponchoEffectBool = TRUE;
}

-(void)updateCanGetLife{
  canGetLife = TRUE;
}

-(void)runAngelTrump{
  SKAction *angelTrumpAction;
  if ((int)[[UIScreen mainScreen] bounds].size.width == 480){
    angelTrumpAction = [SKAction sequence:@[   [SKAction moveTo:hero.position duration:0],[SKAction fadeAlphaTo:0.95 duration:0.2],
                                                 [SKAction moveTo:CGPointMake(self.frame.size.width*0.25,self.frame.size.height*0.83) duration:3.5]]];
    
  }else{
    angelTrumpAction = [SKAction sequence:@[   [SKAction moveTo:hero.position duration:0],[SKAction fadeAlphaTo:0.95 duration:0.2],
                                                 [SKAction moveTo:CGPointMake(self.frame.size.width*0.25,self.frame.size.height*0.75) duration:3.5]]];
  }
  [angelTrump runAction:angelTrumpAction];
}

-(void)resetLifeScore{
  lifeScore = 0;
}
@end
