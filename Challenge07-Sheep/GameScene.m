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



@implementation GameScene

SKLabelNode *life;

//CGFloat score = 0;
SKLabelNode *scoreLabel;
CGPoint pointLocation;
int counter = 0;
int randomSide;
float level = 0.2f;
float speed = 4.0f;
NSTimer *timer;
bool attackLeft = false;
bool attackRight = false;
bool attackUp = false;
bool attackDown = false;
bool defenseRight = false;
bool defenseLeft = false;
bool defenseUp = false;

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
int cardStatus;
bool invencible;
SKLabelNode *msgLabel;

SKTexture *sheepDir;
SKTexture *sheepEsq;
SKTexture *sheepUp;
SKTexture *sheepSheep;


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    [self prepareGameBackground];
    
    [self prepareDragonImages];
    
    [self showHighScore];
    
    [self setPressRegoganizer];
    
    [self prepareCards];
    
    [RWGameData sharedGameData].score = 0;
    
    pulseRed = [SKAction sequence:@[
                                    
                                    [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15],
                                    [SKAction waitForDuration:0.1],
                                    [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15]]];
    
    sheepSuper = [SKAction sequence:@[
                                    [SKAction colorizeWithColor:[SKColor blueColor] colorBlendFactor:1.0 duration:3.15],
                                    [SKAction waitForDuration:3.1],
                                    [SKAction colorizeWithColorBlendFactor:0.0 duration:3.15]
                                    ]];
    
    
    SKAction *Timetofire= [SKAction sequence:@[
                                               //time after you want to fire a function
                                               [SKAction waitForDuration:speed],
                                               [SKAction performSelector:@selector(prepareAttack)
                                                                onTarget:self]]];
    [self runAction:[SKAction repeatActionForever:Timetofire ]];
    
    SKAction *LevelUp= [SKAction sequence:@[
                                               //time after you want to fire a function
                                               [SKAction waitForDuration:0.1f],
                                               [SKAction performSelector:@selector(levelUp)
                                                                onTarget:self]]];
    [self runAction:[SKAction repeatActionForever:LevelUp ]];
    
    SKAction *wait = [SKAction waitForDuration:10.0];
    SKAction *performSelector = [SKAction performSelector:@selector(playEffectBgSounds) onTarget:self];
    SKAction *sequence = [SKAction sequence:@[performSelector, wait]];
    SKAction *repeat   = [SKAction repeatActionForever:sequence];
    [self runAction:repeat];

    
}

-(void)playEffectBgSounds{
    
    //Play Sound
    [self runAction:[SKAction playSoundFileNamed:@"backgroundMusic.wav" waitForCompletion:NO]];
    
}

-(void)setPressRegoganizer{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                        initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.1; //seconds
    lpgr.delegate = self;
    [self.view addGestureRecognizer:lpgr];
}

-(void)prepareCards{
    cardHeart = [SKTexture textureWithImageNamed:@"cardHeart.png"];
    cardCoin = [SKTexture textureWithImageNamed:@"cardCoin.png"];
    cardSuper = [SKTexture textureWithImageNamed:@"cardSuper.png"];
    cardBonus = [SKTexture textureWithImageNamed:@"cardBonus.png"];
    card = [SKSpriteNode spriteNodeWithTexture:cardHeart];
    cardStatus = 0;
    card.name = @"cardNode";
    card.xScale = 0.04;
    card.yScale = 0.04;
    card.position = CGPointMake(350, 170);// Y varia de 390 ateh 175 nao visivel
    cardMove = [SKAction moveToY:170 duration:4];
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
        card.xScale = 0.04;
        card.yScale = 0.04;
        card.position = CGPointMake(randomX, 380);
        [card runAction:cardMove];
    }
    
}

-(void)prepareGameBackground{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.size = CGSizeMake(self.frame.size.height, self.frame.size.width);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:bgImage];
    
    
    msgLabel= [SKLabelNode labelNodeWithFontNamed:@"HoeflerText-BlackItalic"];
    msgLabel.fontSize = 20;
    msgLabel.fontColor = [SKColor blueColor];
    msgLabel.position = CGPointMake((self.frame.size.width/2), (self.frame.size.height/2+45));
    msgLabel.text = @"";
    [self addChild:msgLabel];
    
    scoreLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 15;
    scoreLabel.position = CGPointMake((self.frame.size.width/8), (self.frame.size.height/2.8));
    [self addChild:scoreLabel];
    
    sheepSheep = [SKTexture textureWithImageNamed:@"sheep.png"];
    sheepEsq = [SKTexture textureWithImageNamed:@"sheetEsq.png"];
    sheepDir = [SKTexture textureWithImageNamed:@"sheepDir.png"];
    sheepUp = [SKTexture textureWithImageNamed:@"sheepUp.png"];
    sprite = [SKSpriteNode spriteNodeWithTexture:sheepSheep];
   
    sprite.xScale = 0.2;
    sprite.yScale = 0.2;
    sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:sprite];
    
    SKSpriteNode *heart = [SKSpriteNode spriteNodeWithImageNamed:@"heart.png"];
    heart.xScale = 0.01;
    heart.yScale = 0.01;
    heart.position = CGPointMake(CGRectGetMidX(self.frame)-130, CGRectGetMidY(self.frame)+72);
    [self addChild:heart];
    
    life= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    life.fontSize = 20;
    life.text = @"3";
    life.position = CGPointMake(CGRectGetMidX(self.frame)-110, CGRectGetMidY(self.frame)+65);
    life.fontColor = [SKColor blackColor];
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
    _claws.xScale = 0.1;
    _claws.yScale = 0.1;
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
                                                               timePerFrame:0.1f

                                                                     resize:NO
                                                                    restore:YES] count: 1]];
    
    return;
}

-(void) attackingClaws {
    
    _claws.hidden = false;
    [_claws runAction:[SKAction repeatAction:[SKAction animateWithTextures:_clawsAttackingFrames
                                                              timePerFrame:0.1f
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
        
        switch (cardStatus) {
            case 0://heart
                NSLog(@"heart");
                int newLife = life.text.intValue;
                newLife++;
                life.text = [NSString stringWithFormat:@"%d", newLife];
                card.position = CGPointMake(350, 170);
                break;
            case 1://coin
                NSLog(@"coin");
                card.position = CGPointMake(350, 170);
                break;
            case 2://super
                NSLog(@"super");
                invencible = true;
                msgLabel.text = @"Super Invencible Sheep";
                card.position = CGPointMake(350, 170);
                [sprite runAction: sheepSuper];
                [sprite runAction:sheepSuper completion:^{
                    msgLabel.text = @"";
                    invencible = false;
                }];
                break;
            case 3://bonus
                NSLog(@"bonus");
                [RWGameData sharedGameData].score += 250;
                card.position = CGPointMake(350, 170);
                break;
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint endPosition = [touch locationInView:touch.view];
    
    if (pointLocation.y < endPosition.y) {
        // Down swipe
        NSLog(@"PRA BAIXO");
        
    } else if (pointLocation.y > endPosition.y){
        // Up swipe
        //NSLog(@"PRA CIMA");
        
        sprite.texture = sheepUp;
        defenseUp = true;
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer

{
    
    CGFloat x = pointLocation.x;
    
    CGFloat y = pointLocation.y;
    
    
    
    if( x>=290 && x<=450 && y>=100 && y<=230){
        
        
        
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            
            defenseRight = true;
            sprite.texture = sheepDir;
            
            counter = 1;
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
            
        }
        
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            
            sprite.texture = sheepSheep;
            defenseRight = false;
            
            [timer invalidate];
            
            //            NSLog(@"Defend right.. %d seconds", counter);
            
        }
        
    }else{
        
        if(x>=100 && x<=260 && y>=100 && y<=230){
            
            
            
            if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
                
                counter = 1;
                defenseLeft = true;
                
                sprite.texture = sheepEsq;
                
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
                
            }
            
            if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
                
                defenseLeft = false;
                
                sprite.texture = sheepSheep;
                
                [timer invalidate];
                
                //                NSLog(@"Defend left.. %d seconds", counter);
                
            }
            
        }
        
    }
    
    //    NSLog(@"Pressed at x = %0.f and y = %0.f",x,y);
    
}

-(void)update:(NSTimeInterval)currentTime {
    [RWGameData sharedGameData].score += 0.1;
    scoreLabel.text = [NSString stringWithFormat:@"%.0f pt", [RWGameData sharedGameData].score];

    if ([RWGameData sharedGameData].score >= [RWGameData sharedGameData].highScore)
        scoreLabel.fontColor = [SKColor yellowColor];
    
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
                                                 [SKAction waitForDuration:1],
                                                 [SKAction performSelector:@selector(attack)
                                                                  onTarget:self]
                                                 
                                                 ]];
    [self runAction:[SKAction repeatAction:attackLaunch count: 1]];
}
- (void) attack {
    
    sprite.texture = sheepSheep;
    
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
            //        case 3:
            //            //            attackDown = true;
            //            //            if(defenseTest != attackDown){
            //            //                NSLog(@"DEAAAAD BITCH");
            //            //            }
            //            //            attackDown = false;
            //            break;
            
    }
    
}
-(void) levelUp {
    
}

-(void) showHighScore {
    SKLabelNode *highScoreTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScoreTitle.fontSize = 10;
    highScoreTitle.fontColor = [SKColor redColor];
    highScoreTitle.position = CGPointMake(CGRectGetMidX(self.frame)+ 120, CGRectGetMidY(self.frame)+70);
    highScoreTitle.text = @"High Score";
    [self addChild:highScoreTitle];
    
    
    SKLabelNode *highScore;
    highScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScore.fontSize = 10;
    highScore.fontColor = [SKColor redColor];
    highScore.position = CGPointMake(CGRectGetMidX(self.frame)+ 120, CGRectGetMidY(self.frame)+60);
    highScore.text = [NSMutableString stringWithFormat:@"%.0f",[RWGameData sharedGameData].highScore];
    [self addChild:highScore];
    
}

-(void) getBonusScore {
    [RWGameData sharedGameData].score += 50;
}

-(void) damageTaken {
        
    int newLife = life.text.intValue;
    newLife --;
   
    [sprite runAction: pulseRed];
    life.text = [NSString stringWithFormat:@"%d", newLife];
    if ( newLife ==0 ){
        [self endGame];
        [self runAction:[SKAction playSoundFileNamed:@"dyingSheep.wav" waitForCompletion:NO]];
    } else {
        [self runAction:[SKAction playSoundFileNamed:@"ImSheep.mp3" waitForCompletion:NO]];
    }
}

-(void) endGame {
    [self prepareSaveGame];

    SKTransition *reveal = [SKTransition fadeWithDuration:3];
    
    HighScoreScene *scene = [HighScoreScene sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition:reveal];
    
}

-(void) prepareSaveGame {
    

    [RWGameData sharedGameData].highScore = MAX([RWGameData sharedGameData].score,
                                                [RWGameData sharedGameData].highScore);
    [[RWGameData sharedGameData] save];
}

@end
