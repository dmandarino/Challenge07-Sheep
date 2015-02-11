//
//  BossScene.m
//  Challenge07-Sheep
//
//  Created by Rodrigo Dezouzart on 2/4/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "BossScene.h"
#import "GameScene.h"
#import "RWGameData.h"

@implementation BossScene

static const int spriteHitCategory = 1;
static const int fireHitCategory = 2;

RWGameData *data;
bool playing;

SKLabelNode *coinsLabel;
SKLabelNode *msgLabel;
SKLabelNode *scoreLabel;
SKLabelNode *heartLabel;

SKSpriteNode *coinsImg;
SKSpriteNode *heartImg;
SKSpriteNode *bgImage;

SKAction *msgAct;
SKAction *createWaves;
SKAction *pulseRed;
SKAction *createGiant;
SKAction *fadeOutSheep;
SKAction *fadeInSheep;

RWGameData *data;


-(void) didMoveToView:(SKView *)view {
    data = [[RWGameData alloc] init];
    playing = true;
    
    [self createActions];
    
    [self createBackground];
    
    [self playEffectBgSounds];
    
    [msgLabel runAction: msgAct];
    
    int i = 1;
    if (_level>=3) {
        i = 2;
    }
    [self runAction:[SKAction repeatAction:createWaves count:i]completion:^{
        [self runAction: [SKAction waitForDuration:(10-_level)]completion:^{
            
            if(_level == 2 || _level == 4 || _level == 6){
                int numb = 17;
                if(_level == 2){
                    numb = 12;
                }
                [self runAction:[SKAction repeatAction:createGiant count:1]completion:^{
                    [self runAction: [SKAction waitForDuration:(numb)]completion:^{
                        [_player stop];
                        [self backGame];
                    }];
                }];
            }else{
                [_player stop];
                [self backGame];
            }

        }];
    }];
    
    
}

-(void) createActions {
    
    
    msgAct = [SKAction sequence:@[
                                  [SKAction fadeAlphaTo:1 duration:2],
                                  [SKAction fadeOutWithDuration:2]
                                  ]];
    
    createWaves = [SKAction sequence:@[
                                       //time after you want to fire a function
                                       [SKAction waitForDuration:2],
                                       [SKAction performSelector:@selector(sendWave)
                                                        onTarget:self]]];
    createGiant = [SKAction sequence:@[
                                       [SKAction performSelector:@selector(giantFireBall)
                                                        onTarget:self]]];
    
    pulseRed = [SKAction sequence:@[
                                    [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15],
                                    [SKAction waitForDuration:0.1],
                                    [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15]]];
    
    fadeOutSheep = [SKAction fadeAlphaTo:0 duration:1];
    fadeInSheep = [SKAction fadeAlphaTo:1 duration:1];
    
}

-(void) createBackground {
    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundBoss.png"];
    bgImage.size = CGSizeMake(self.frame.size.width, self.frame.size.height/2-100);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    bgImage.zPosition = 0;
    [self addChild:bgImage];
    
    msgLabel= [SKLabelNode labelNodeWithFontNamed:@"HoeflerText-BlackItalic"];
    msgLabel.fontSize = 25;
    msgLabel.fontColor = [SKColor blackColor];
    msgLabel.position = CGPointMake((self.frame.size.width/2), (self.frame.size.height/2+45));
    msgLabel.text = @"Fire Waves";
    msgLabel.zPosition = 1;
    msgLabel.alpha = 0;
    [self addChild:msgLabel];
    
    scoreLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 15;
    scoreLabel.position = CGPointMake((self.frame.size.width/8), (self.frame.size.height/2.8));
    scoreLabel.text = [NSString stringWithFormat:@"%.0f", _scoreParam];
    scoreLabel.zPosition = 1;
    [self addChild:scoreLabel];
    
    coinsLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    coinsLabel.fontSize = 12;
    coinsLabel.position = CGPointMake(CGRectGetMidX(self.frame)-105, CGRectGetMidY(self.frame)+45);
    coinsLabel.fontColor = [SKColor whiteColor];
    coinsLabel.text = [NSString stringWithFormat:@"%.0f", _coinsParam];
    coinsLabel.zPosition = 1;
    [self addChild:coinsLabel];
    
    coinsImg = [SKSpriteNode spriteNodeWithImageNamed:@"coins.png"];
    coinsImg.xScale = 0.05;
    coinsImg.yScale = 0.05;
    coinsImg.position = CGPointMake(CGRectGetMidX(self.frame)-130, CGRectGetMidY(self.frame)+52);
    coinsImg.zPosition = 1;
    [self addChild:coinsImg];
    
    heartImg = [SKSpriteNode spriteNodeWithImageNamed:@"heart.png"];
    heartImg.xScale = 0.01;
    heartImg.yScale = 0.01;
    heartImg.position = CGPointMake(CGRectGetMidX(self.frame)-129, CGRectGetMidY(self.frame)+72);
    heartImg.zPosition = 1;
    [self addChild:heartImg];
    
    heartLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    heartLabel.fontSize = 15;
    heartLabel.text = [NSString stringWithFormat:@"%d", _nHeartsParam];
    heartLabel.position = CGPointMake(CGRectGetMidX(self.frame)-103, CGRectGetMidY(self.frame)+63);
    heartLabel.fontColor = [SKColor whiteColor];
    heartLabel.zPosition = 1;
    [self addChild:heartLabel];
    
    [self showHighScore];
    
    
    //[_spriteParam removeFromParent];
    [self addChild:_spriteParam];
    //[_spriteParam runAction:fadeInSheep];
    _spriteParam.zPosition = 1;
    _spriteParam.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:40];
    _spriteParam.physicsBody.categoryBitMask = spriteHitCategory;
    _spriteParam.physicsBody.contactTestBitMask = fireHitCategory;
    _spriteParam.physicsBody.collisionBitMask =  fireHitCategory;
    _spriteParam.physicsBody.dynamic = NO;
    
}

-(void)playEffectBgSounds{
    if ([[data isSoundOn]boolValue]){
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:@"backgroundMusic"
                                             ofType:@"mp3"]];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player.numberOfLoops = -1;
        
        [_player play];
    }
}

-(void) showHighScore {
    SKLabelNode *highScoreTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScoreTitle.fontSize = 10;
    highScoreTitle.fontColor = [SKColor redColor];
    highScoreTitle.position = CGPointMake(CGRectGetMidX(self.frame)+ 120, CGRectGetMidY(self.frame)+70);
    highScoreTitle.text = @"High Score";
    highScoreTitle.zPosition = 1;
    [self addChild:highScoreTitle];
    
    
    SKLabelNode *highScore;
    highScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScore.fontSize = 10;
    highScore.fontColor = [SKColor redColor];
    highScore.position = CGPointMake(CGRectGetMidX(self.frame)+ 120, CGRectGetMidY(self.frame)+60);
    highScore.text = [NSMutableString stringWithFormat:@"%.0f", _rankingParam];
    highScore.zPosition  =1;
    [self addChild:highScore];
    
}

-(void)update:(NSTimeInterval)currentTime {
    if(playing){
        _scoreParam += 0.1;
        scoreLabel.text = [NSString stringWithFormat:@"%.0f", _scoreParam];
        
        _coinsParam += 0.005;
        coinsLabel.text = [NSString stringWithFormat:@"%.0f", _coinsParam];
        
        if ( _scoreParam >= _rankingParam )
            scoreLabel.fontColor = [SKColor redColor];
    }
}

-(void) backGame {
    
    int scoreAux = _scoreParam+1;
    int coinsAux = _coinsParam+1;
    
    SKTransition *reveal = [SKTransition fadeWithDuration:1];
    GameScene *scene = [GameScene sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.level = self.level + 1;
    scene.scoreParam = scoreAux;
    scene.coinsParam = coinsAux;
    scene.nHeartsParam = heartLabel.text.intValue;
    
    [self.view presentScene:scene transition:reveal];
}

-(void)fireWave: (int) positionX: (int) positionY {
    
    SKSpriteNode *fire = [SKSpriteNode spriteNodeWithImageNamed:@"fireBall.png"];
    fire.name = @"fire";
    fire.xScale = 0.05;
    fire.yScale = 0.05;
    fire.zPosition = 2;
    
    fire.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:1];
    fire.physicsBody.categoryBitMask = fireHitCategory;
    fire.physicsBody.contactTestBitMask = spriteHitCategory;
    fire.physicsBody.collisionBitMask =  spriteHitCategory;
    fire.physicsBody.dynamic = YES;
    fire.physicsBody.affectedByGravity = false;
    
    SKRange *range = [SKRange rangeWithConstantValue:0.0f];
    SKConstraint *orientConstraint = [SKConstraint orientToNode:_spriteParam offset:range];
    
    fire.constraints = @[orientConstraint];
    
    fire.position = CGPointMake(CGRectGetMidX(self.frame) - positionX, CGRectGetMidY(self.frame) - positionY);
    [self addChild:fire];
    
    SKAction *hotWave = [SKAction moveTo:_spriteParam.position duration:(10 - _level)];
    [fire runAction:hotWave];
    
    
}

- (void)giantFireBall{
    
    SKSpriteNode *fire = [SKSpriteNode spriteNodeWithImageNamed:@"fireBall.png"];
    fire.name = @"Giantfire";
    fire.xScale = 0.15;
    fire.yScale = 0.15;
    fire.zPosition = 2;
    
    fire.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:1];
    fire.physicsBody.categoryBitMask = fireHitCategory;
    fire.physicsBody.contactTestBitMask = spriteHitCategory;
    fire.physicsBody.collisionBitMask =  spriteHitCategory;
    fire.physicsBody.dynamic = YES;
    fire.physicsBody.affectedByGravity = false;
    
    fire.position = CGPointMake(CGRectGetMidX(self.frame)-230, CGRectGetMidY(self.frame));
    [self addChild:fire];
    
    SKAction *hotWave = [SKAction moveTo:_spriteParam.position duration:(11)];
    
    if(_level == 2){
        [fire runAction:hotWave];
    }
    
    if(_level == 4 || _level == 6){
        
        SKSpriteNode *fire2 = [SKSpriteNode spriteNodeWithImageNamed:@"fireBall.png"];
        fire2.name = @"Giantfire";
        fire2.xScale = 0.15;
        fire2.yScale = 0.15;
        fire2.zPosition = 1;
        fire2.zRotation = M_PI;
        
        fire2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:1];
        fire2.physicsBody.categoryBitMask = fireHitCategory;
        fire2.physicsBody.contactTestBitMask = spriteHitCategory;
        fire2.physicsBody.collisionBitMask =  spriteHitCategory;
        fire2.physicsBody.dynamic = YES;
        fire2.physicsBody.affectedByGravity = false;
        
        fire2.position = CGPointMake(CGRectGetMidX(self.frame)+230, CGRectGetMidY(self.frame));
        [self addChild:fire2];
        
        
        SKAction *launchWave = [SKAction sequence:@[
                                        [SKAction waitForDuration:5],
                                        [SKAction moveTo:_spriteParam.position duration:(11)]]];
        
        [fire runAction:hotWave];
        [fire2 runAction:[SKAction repeatAction:launchWave count:1]];
    }
}

- (void)sendWave{
    
    for ( int i = 0; i < 10; i++){
        double x = (arc4random() % 300);
        double y = (arc4random() % 320);
        if ( y < 200){
            x = (arc4random() % 320 ) + 300;
        }
        
        float sign = arc4random_uniform(4);
        if( sign == 1)
            [self fireWave : x : -1 * y + 80];
        else if (sign == 2){
            [self fireWave : -1*x : -1 * y + 80];
        }else if (sign == 3){
            [self fireWave : x : -1 * y];
        }else{
            [self fireWave : -1 * x : -1 * y];
        }
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody *firstBody, *secondBody;
    
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    if(firstBody.categoryBitMask == fireHitCategory || secondBody.categoryBitMask == fireHitCategory){
        [secondBody.node removeFromParent];
        [self damageTaken];
    }
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch1 = [touches anyObject];
    CGPoint location = [touch1 locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"fire"]) {
        [node removeFromParent];
    }
    
    if ([node.name isEqualToString:@"Giantfire"]) {
        if (node.xScale >= 0.05) {
            node.xScale = node.xScale - 0.0022;
            node.yScale = node.yScale - 0.0022;
        }else{
            [node removeFromParent];
        }
    }
    
}

-(void) damageTaken {
    
    _nHeartsParam--;
    
    [_spriteParam runAction: pulseRed];
    
    if (_nHeartsParam >= 0) {
        heartLabel.text = [NSString stringWithFormat:@"%d", _nHeartsParam];
    }
    if ( _nHeartsParam == 0 ){
        [self endGame];
        
        if ([[data isSoundOn]boolValue]){
            [self runAction:[SKAction playSoundFileNamed:@"dyingSheep.mp3" waitForCompletion:NO]];
        }
    } else {
        if ([[data isSoundOn]boolValue]){
            [self runAction:[SKAction playSoundFileNamed:@"ImSheep.mp3" waitForCompletion:NO]];
        }
    }
}

-(void) endGame {
    [_player stop];
    [self saveGame];
    playing = false;
    SKTransition *reveal = [SKTransition fadeWithDuration:3];
    HighScoreScene *scene = [HighScoreScene sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.score = _scoreParam;
    scene.coins = _coinsParam;
    
    [self.view presentScene:scene transition:reveal];
    
}

-(void) saveGame {
    data = [[RWGameData alloc] init];
    scoreLabel.fontColor = [SKColor blackColor];
    NSNumber *scoreToSave = [[NSNumber alloc] init];
    scoreToSave = [NSNumber numberWithFloat: _scoreParam];
    
    NSMutableArray *rankingToSave = [[NSMutableArray array] init];
    
    if ([data loadRanking] != nil)
        rankingToSave = [data loadRanking];
    
    [rankingToSave addObject:scoreToSave];
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [rankingToSave sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    if ( [rankingToSave count] > 5)
        [rankingToSave removeLastObject];
    
    [data saveRanking:rankingToSave];
    
    float coinsToSave = [[data loadCoins] floatValue];
    coinsToSave += _coinsParam;
    
    [data saveCoins:[NSNumber numberWithFloat:coinsToSave]];
}


@end
