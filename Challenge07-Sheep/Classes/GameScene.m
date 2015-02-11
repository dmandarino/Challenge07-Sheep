//
//  GameScene.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/18/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "GameScene.h"
#import "GameViewController.h"
#import "HighScoreScene.h"
#import "RWGameData.h"
#import <AVFoundation/AVFoundation.h>
#import "Sheep.h"
#import "BossScene.h"


@implementation GameScene

SKLabelNode *life;

float gameCoins;
SKLabelNode *scoreLabel;
SKLabelNode *coinsLabel;
SKSpriteNode *coinsImg;
SKSpriteNode *poofImg;
CGPoint pointLocation;
float counter = 0;
float score;
int randomSide;
int defenseSide;

NSTimer *timer;
bool attackLeft = false;
bool attackRight = false;
bool attackUp = false;
bool attackDown = false;
bool defenseRight = false;
bool defenseLeft = false;
bool defenseUp = false;
bool playing  = true;

SKSpriteNode *sprite;
SKAction *runAnimation;
NSMutableArray *dragonFrames;
SKTextureAtlas *dragonAnimatedAtlas;
NSMutableArray *clawsFrames;
SKTextureAtlas *clawsAnimatedAtlas;
SKSpriteNode *_dragon;
NSArray *_dragonFireFrames;
SKSpriteNode *_claws;
NSArray *_clawsAttackingFrames;
SKAction *pulseRed;

SKSpriteNode *card;
SKTexture *cardHeart;
SKTexture *cardCoin;
SKTexture *cardSuper;
SKTexture *cardBonus;

SKAction *cardMove;
SKAction *sheepSuper;
SKAction *fadeOutSheep;
SKAction *fadeInSheep;


int cardStatus;
bool invencible;
SKLabelNode *msgLabel;

SKTexture *sheepDir;
SKTexture *sheepEsq;
SKTexture *sheepUp;
SKTexture *sheepSheep;

NSMutableArray *sheepSkin;

RWGameData *data;
float ranking;


// ==== LEVEL DE DIFICULDADE ===== //

float intervalToAttack;
float framesSpeed;
float intervalToCancelAttack;
float intervalDuringAttack;
int numberOfAttacks;

-(void)didMoveToView:(SKView *)view {
    
    
    /* Setup your scene here */
    
    sheepSkin = [[NSMutableArray alloc] init];
    
    [self loadValues];
    
    [self prepareGameBackground];
    
    [self playEffectBgSounds];
    
    [self prepareDragonImages];
    
    [self showHighScore];
    
    [self prepareCards];
    
    pulseRed = [SKAction sequence:@[
                                    [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15],
                                    [SKAction waitForDuration:0.1],
                                    [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15]]];
    
    sheepSuper = [SKAction sequence:@[
                                      [SKAction colorizeWithColor:[SKColor cyanColor] colorBlendFactor:1.0 duration:3.15],
                                      [SKAction waitForDuration:3.1],
                                      [SKAction colorizeWithColorBlendFactor:0.0 duration:3.15]]];
    
    fadeOutSheep = [SKAction fadeAlphaTo:0 duration:0.5];
    fadeInSheep = [SKAction fadeAlphaTo:1 duration:0.5];
    
    SKAction *runGameAnimations = [SKAction sequence:@[
                                                      //time after you want to fire a function
                                                      [SKAction waitForDuration:intervalToAttack],
                                                      [SKAction performSelector:@selector(prepareAttack)
                                                                       onTarget:self]]];
    
    
    
    [self runAction:[SKAction repeatAction:runGameAnimations count:6+_level]completion:^{
        
        [self runAction: [SKAction waitForDuration:2]completion:^{
            sprite.texture = sheepSheep;
            [sprite removeFromParent];
            poofImg.hidden = false;
            //[sprite runAction:fadeOutSheep];
            [self runAction:[SKAction waitForDuration:1]completion:^{
                [self startBossScene];
            }];
        }];
    }];
    
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


-(void)prepareCards{
    cardHeart = [SKTexture textureWithImageNamed:@"cardHeart.png"];
    cardCoin = [SKTexture textureWithImageNamed:@"cardCoin.png"];
    cardSuper = [SKTexture textureWithImageNamed:@"cardSuper.png"];
    cardBonus = [SKTexture textureWithImageNamed:@"cardBonus.png"];
    card = [SKSpriteNode spriteNodeWithTexture:cardHeart];
    cardStatus = 0;
    card.name = @"cardNode";
    card.xScale = 0.08;
    card.yScale = 0.08;
    card.zPosition = 3;
    card.position = CGPointMake(350, 170);// Y varia de 390 ateh 175 nao visivel
    cardMove = [SKAction moveToY:170 duration:2.5];
    invencible = false;
    
    [self addChild: card];
}

-(void)chooseCard{
    int randomCard = arc4random_uniform(4);
    
    switch (randomCard)
    {
        case 0:
            card.texture = cardHeart;
            cardStatus = 0;
            break;
        case 1:
            card.texture = cardCoin;
            cardStatus = 1;
            break;
        case 2:
            card.texture = cardSuper;
            cardStatus = 2;
            break;
        case 3:
            card.texture = cardBonus;
            cardStatus = 3;
            break;
    }
    
}

-(void)randomFallCard{
    int randomFall = arc4random_uniform(1);//probabilidade de cair carta
    int randomX = arc4random_uniform(290);
    randomX = randomX + 15;
    
    if (randomFall == 0 && card.position.y == 170 && invencible == false) {
        [self chooseCard];
        card.xScale = 0.06;
        card.yScale = 0.06;
        card.position = CGPointMake(randomX, 380);
        [card runAction:cardMove];
    }
    
}

-(Sheep *) getSheep {
    if ([data loadSheeps] != nil){
        NSMutableArray *sheeps = [[NSMutableArray array] init];
        sheeps = [data loadSheeps];
        for (int i = 0; i < [sheeps count] ; i++){
            Sheep *sheep = [[Sheep alloc] init];
            sheep = [sheeps objectAtIndex:i];
            if ([[sheep isMainSheep] boolValue] == YES)
                return sheep;
        }
    }
    return [self createDefaultSheep];
}

-(Sheep*) createDefaultSheep {
    Sheep *sheep = [[Sheep alloc] init];
    [sheep setName:@"viking"];
    [sheep setPrice:[NSNumber numberWithFloat:0]];
    [sheep setMainSheep:[NSNumber numberWithBool:YES]];
    [sheep setImage:@"viking.png"];
    [sheep setImageLeft:@"vikingEsq.png"];
    [sheep setImageRigh:@"vikingDir.png"];
    [sheep setImageUP:@"vikingUp.png"];
    
    NSMutableArray *sheepArray = [[NSMutableArray array] init];
    [sheepArray addObject:sheep];
    [data saveSheep:sheepArray];
    return sheep;
}

-(void) showSheep {
    Sheep *sheep = [[Sheep alloc] init];
    sheep = [self getSheep];
    sheepSheep = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@", [sheep getImage]]];
    sheepEsq = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@", [sheep getImageLeft]]];
    sheepDir = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@", [sheep getImageRight]]];
    sheepUp = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@", [sheep getImageUp]]];
    sprite = [SKSpriteNode spriteNodeWithTexture:sheepSheep];
}

-(void)prepareGameBackground{
    
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.size = CGSizeMake(self.frame.size.height, self.frame.size.width);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    bgImage.zPosition = 0;
    [self addChild:bgImage];
    
    msgLabel= [SKLabelNode labelNodeWithFontNamed:@"HoeflerText-BlackItalic"];
    msgLabel.fontSize = 20;
    msgLabel.fontColor = [SKColor blueColor];
    msgLabel.position = CGPointMake((self.frame.size.width/2+10), (self.frame.size.height/2+45));
    msgLabel.text = @"";
    msgLabel.zPosition = 1;
    [self addChild:msgLabel];
    
    scoreLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 15;
    scoreLabel.position = CGPointMake((self.frame.size.width/8), (self.frame.size.height/2.8));
    scoreLabel.zPosition = 1;
    [self addChild:scoreLabel];
    
    coinsLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    coinsLabel.fontSize = 12;
    coinsLabel.position = CGPointMake(CGRectGetMidX(self.frame)-108, CGRectGetMidY(self.frame)+45);
    coinsLabel.fontColor = [SKColor blackColor];
    coinsLabel.zPosition = 1;
    [self addChild:coinsLabel];
    
    coinsImg = [SKSpriteNode spriteNodeWithImageNamed:@"coins.png"];
    coinsImg.xScale = 0.05;
    coinsImg.yScale = 0.05;
    coinsImg.position = CGPointMake(CGRectGetMidX(self.frame)-130, CGRectGetMidY(self.frame)+52);
    coinsImg.zPosition = 1;
    [self addChild:coinsImg];
    
    poofImg = [SKSpriteNode spriteNodeWithImageNamed:@"poof.png"];
    poofImg.xScale = 0.3;
    poofImg.yScale = 0.3;
    poofImg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) * 0.95);
    poofImg.zPosition = 1;
    poofImg.hidden = true;
    [self addChild:poofImg];
    
    [self showSheep];
    
    sprite.xScale = 0.3;
    sprite.yScale = 0.3;
    sprite.zPosition = 1;
    sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) * 0.95);
    sprite.zPosition = 1;
    [self addChild:sprite];
    //[sprite runAction:fadeInSheep];
    
    SKSpriteNode *heart = [SKSpriteNode spriteNodeWithImageNamed:@"heart.png"];
    heart.xScale = 0.01;
    heart.yScale = 0.01;
    heart.position = CGPointMake(CGRectGetMidX(self.frame)-135, CGRectGetMidY(self.frame)+72);
    heart.zPosition = 1;
    [self addChild:heart];
    
    life= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    life.fontSize = 20;
    if (self.nHeartsParam >0 )
        life.text = [NSString stringWithFormat:@"%d", self.nHeartsParam];
    else
        life.text = [NSString stringWithFormat:@"%d", [[data heartNumber] intValue]];
    life.position = CGPointMake(CGRectGetMidX(self.frame)-110, CGRectGetMidY(self.frame)+65);
    life.fontColor = [SKColor blackColor];
    life.zPosition = 1;
    [self addChild:life];
}

-(void)prepareDragonImages{
    dragonFrames = [NSMutableArray array];
    dragonAnimatedAtlas = [SKTextureAtlas atlasNamed:@"animation"];
    int numImages = dragonAnimatedAtlas.textureNames.count;
    
    for (int i = 1; i <= numImages/2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"dragao%d", i];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [dragonFrames addObject:temp];
    }
    
    for (int i=1; i <= 2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"dragao%d",8];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [dragonFrames addObject:temp];
    }
    
    for (int i=numImages/2; i >=1; i--) {
        NSString *textureName = [NSString stringWithFormat:@"dragao%d", i];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [dragonFrames addObject:temp];
    }
    
    
    _dragonFireFrames = dragonFrames;
    
    SKTexture *temp = _dragonFireFrames[0];
    _dragon = [SKSpriteNode spriteNodeWithTexture:temp];
    _dragon.xScale = 0.1;
    _dragon.yScale = 0.1;
    _dragon.zPosition = 2;
    _dragon.hidden = true;
    
    [self addChild:_dragon];
    
    
    clawsFrames = [NSMutableArray array];
    
    for (int i=1; i<= numImages/2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"claws%d", i];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [clawsFrames addObject:temp];
    }
    
    
    for (int i=1; i<= 2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"claws%d",8];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [clawsFrames addObject:temp];
    }
    
    
    for (int i=numImages/2; i>=1; i--) {
        NSString *textureName = [NSString stringWithFormat:@"claws%d", i];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [clawsFrames addObject:temp];
    }
    
    _clawsAttackingFrames = clawsFrames;
    
    SKTexture *temp2 = _clawsAttackingFrames[0];
    _claws = [SKSpriteNode spriteNodeWithTexture:temp2];
    _claws.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+75);
    _claws.xScale = 0.11;
    _claws.yScale = 0.13;
    _claws.zPosition = 2;
    _claws.hidden = true;
    [self addChild:_claws];
    
    
}

-(void)attackingDragonFire: (BOOL)isRightSide{
    
    CGFloat multiplierForDirection;
    
    if (isRightSide) {
        multiplierForDirection = 1;
        _dragon.position = CGPointMake(CGRectGetMaxX(self.frame)-70, CGRectGetMidY(self.frame)-20);
        
        
    } else {
        multiplierForDirection = -1;
        _dragon.position = CGPointMake(CGRectGetMinX(self.frame)+70, CGRectGetMidY(self.frame)-20);
        
    }
    
    _dragon.xScale = fabs(_dragon.xScale) * multiplierForDirection;
    
    
    _dragon.hidden = false;
    [_dragon runAction:[SKAction repeatAction:[SKAction animateWithTextures:_dragonFireFrames
                                                               timePerFrame:framesSpeed
                                               
                                                                     resize:NO
                                                                    restore:YES] count: 1]];
    
    return;
}

-(void) attackingClaws {
    
    _claws.hidden = false;
    [_claws runAction:[SKAction repeatAction:[SKAction animateWithTextures:_clawsAttackingFrames
                                                              timePerFrame:framesSpeed
                                                                    resize:YES
                                                                   restore:YES] count: 1]];
    return;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    pointLocation = [touch locationInView:touch.view];
    
    UITouch *touch1 = [touches anyObject];
    CGPoint location = [touch1 locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"cardNode"]) {
        
        int newLife;
        
        switch (cardStatus) {
            case 0://heart
                //NSLog(@"heart");
                newLife = life.text.intValue;
                newLife++;
                life.text = [NSString stringWithFormat:@"%d", newLife];
                card.position = CGPointMake(350, 170);
                break;
            case 1://coin
                //NSLog(@"coin");
                gameCoins+=10;
                card.position = CGPointMake(350, 170);
                break;
            case 2://super
                //NSLog(@"super");
                invencible = true;
                msgLabel.text = @"Super Invincible Sheep";
                card.position = CGPointMake(350, 170);
                [sprite runAction:sheepSuper completion:^{
                    msgLabel.text = @"";
                    invencible = false;
                }];
                break;
            case 3://bonus
                score += 250;
                card.position = CGPointMake(350, 170);
                break;
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint endPosition = [touch locationInView:touch.view];
    int deltaX = (endPosition.x - pointLocation.x);
    int deltaY = (endPosition.y - pointLocation.y);
    
    SKAction *cancelAttackLeft= [SKAction sequence:@[
                                                     //time after you want to fire a function
                                                     [SKAction waitForDuration:intervalToCancelAttack],
                                                     [SKAction performSelector:@selector(stopAttackLeft)
                                                                      onTarget:self]
                                                     
                                                     ]];
    SKAction *cancelAttackRight= [SKAction sequence:@[
                                                      //time after you want to fire a function
                                                      [SKAction waitForDuration:intervalToCancelAttack],
                                                      [SKAction performSelector:@selector(stopAttackRight)
                                                                       onTarget:self]
                                                      
                                                      ]];
    [self runAction:[SKAction repeatAction:cancelAttackRight count: 1]];
    
    SKAction *cancelAttackUp= [SKAction sequence:@[
                                                   //time after you want to fire a function
                                                   [SKAction waitForDuration:intervalToCancelAttack],
                                                   [SKAction performSelector:@selector(stopAttackUp)
                                                                    onTarget:self]
                                                   
                                                   ]];
    if( deltaY == 0){
        deltaY = 1;
    }
    int tang = deltaX/deltaY;
    
    if ( abs(tang) >= 1 ){
        
        if ( pointLocation.x < endPosition.x){
            if( defenseRight == false){
                [self runAction:[SKAction repeatAction:cancelAttackRight count: 1]];
            }
            defenseLeft = false;
            defenseUp = false;
            defenseRight = true;
            sprite.texture = sheepDir;
            
        }else {
            if(defenseLeft == false){
                [self runAction:[SKAction repeatAction:cancelAttackLeft count: 1]];
            }
            defenseLeft = true;
            defenseUp = false;
            defenseRight = false;
            
            sprite.texture = sheepEsq;
            
        }
    }else if (pointLocation.y > endPosition.y){
        if( defenseUp == false){
            [self runAction:[SKAction repeatAction:cancelAttackUp count: 1]];
        }
        
        defenseUp = true;
        defenseLeft = false;
        defenseRight = false;
        
        
        sprite.texture = sheepUp;
        
    }
}


-(void)update:(NSTimeInterval)currentTime {
    if(playing){
        score += 0.1;
        scoreLabel.text = [NSString stringWithFormat:@"%.0f", score];
        
        gameCoins += 0.005;
        coinsLabel.text = [NSString stringWithFormat:@"%.0f", gameCoins];
        
        if ( score >= ranking )
            scoreLabel.fontColor = [SKColor redColor];
    }
    
}

- (void)incrementCounter {
    counter++;
}

- (void) prepareAttack {
    _dragon.hidden = true;
    _claws.hidden = true;
    randomSide = arc4random_uniform(3);
    defenseUp = false;
    
    [self randomFallCard];
    
    switch (randomSide)
    {
        case 0:
            [self attackingClaws];
            
            break;
        case 1:
            [self attackingDragonFire: TRUE];
            
            break;
        case 2:
            [self attackingDragonFire: NO];
            
            break;
            
    }
    
    
    SKAction *attackLaunch= [SKAction sequence:@[
                                                 //time after you want to fire a function
                                                 [SKAction waitForDuration:intervalDuringAttack],
                                                 [SKAction performSelector:@selector(attack)
                                                                  onTarget:self]
                                                 
                                                 ]];
    [self runAction:[SKAction repeatAction:attackLaunch count: 1]];
}

- (void) attack {
    
    //sprite.texture = sheepSheep;
    
    switch (randomSide)
    {
        case 0:
            attackUp = true;
            if(defenseUp != attackUp && invencible == false)
                [self damageTaken];
            else
                [self getBonusScore];
            attackUp = false;
            break;
        case 1:
            attackRight = true;
            if(defenseRight != attackRight && invencible == false)
                [self damageTaken];
            else
                [self getBonusScore];
            attackRight = false;
            break;
        case 2:
            attackLeft = true;
            if(defenseLeft != attackLeft && invencible == false)
                [self damageTaken];
            else
                [self getBonusScore];
            attackLeft = false;
            break;
            
    }
    
}

-(void) stopAttackLeft {
    if( defenseLeft == true ){
        sprite.texture = sheepSheep;
        defenseLeft = false;
    }
    
}
-(void) stopAttackRight {
    if( defenseRight == true ){
        sprite.texture = sheepSheep;
        defenseRight = false;
    }
    
}
-(void) stopAttackUp {
    if( defenseUp == true ){
        sprite.texture = sheepSheep;
        defenseUp = false;
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
    highScore.text = [NSMutableString stringWithFormat:@"%.0f", ranking];
    highScore.zPosition  =1;
    [self addChild:highScore];
    
}

-(void) getBonusScore {
    score += 50;
}

-(void) damageTaken {
    
    int newLife = life.text.intValue;
    newLife --;
    
    [sprite runAction: pulseRed];
    life.text = [NSString stringWithFormat:@"%d", newLife];
    if ( newLife ==0 ){
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
    scene.score = score;
    scene.coins = gameCoins;
    
    [self.view presentScene:scene transition:reveal];
    
}

-(void) startBossScene {
    int scoreAux = score+1;
    int coinsAux = gameCoins+1;

    [_player stop];
    playing = false;

    SKTransition *reveal = [SKTransition crossFadeWithDuration:2];
    BossScene *scene = [BossScene sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.scoreParam = scoreAux;
    scene.coinsParam = coinsAux;
    scene.nHeartsParam = life.text.intValue;
    scene.rankingParam = ranking;
    scene.spriteParam = sprite;
    scene.level = self.level;
    
    [self.view presentScene:scene transition:reveal];
    
}

-(void) saveGame {
    scoreLabel.fontColor = [SKColor blackColor];
    NSNumber *scoreToSave = [[NSNumber alloc] init];
    scoreToSave = [NSNumber numberWithFloat: score];
    
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
    coinsToSave += gameCoins;
    
    [data saveCoins:[NSNumber numberWithFloat:coinsToSave]];
}

-(NSMutableArray *) setRanking: (NSMutableArray *) array {
    
    [array addObject:[NSNumber numberWithFloat: score]];
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [array sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    if ( [array count] > 5)
        [array removeLastObject];
    
    return array;
}

- (void) loadValues {
    score = self.scoreParam;
    gameCoins = self.coinsParam;
    
    numberOfAttacks = 0;
    playing = true;
    
    if(_level <1 )
        _level =1;
    
    [self setLevelValues];
    
    data = [[RWGameData alloc] init];
    
    if ([[data loadRanking] objectAtIndex:0]!= nil)
        ranking = [[[data loadRanking] objectAtIndex:0] floatValue];
    else
        ranking = 0;
}

-(void) setLevelValues {
    [self setDefaultLevelValues];
    float actualLevel = 0;
    if (self.level > 0){
        if (self.level > 5){
            actualLevel = self.level;
            self.level = 5;
        }
        
        float aux = self.level;
        
        intervalToCancelAttack -= (aux * 0.06f);
        intervalToAttack -= (aux * 0.4f);
        intervalDuringAttack -= (aux * 0.13f);
        framesSpeed -= (aux * 0.011f);
        
        if (actualLevel == 6){
            intervalToAttack -= 0.5f;
        }
    }
}

-(void) setDefaultLevelValues {
    intervalToAttack = 4.0f;
    framesSpeed = 0.1f;
    intervalDuringAttack = 1.0;
    intervalToCancelAttack = 0.5f;
}

@end
