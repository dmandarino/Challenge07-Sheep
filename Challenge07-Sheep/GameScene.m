//
//  GameScene.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/18/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "GameScene.h"
#import "GameViewController.h"



@implementation GameScene

SKLabelNode *life;

CGFloat score = 0;
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


SKTexture *sheepDir;
SKTexture *sheepEsq;
SKTexture *sheepUp;
SKTexture *sheepSheep;


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    
    [self prepareGameBackground];
    
    [self prepareDragonImages];
    
    [self setPressRegoganizer];
   
    
    
    pulseRed = [SKAction sequence:@[
                                    
                                    [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15],
                                    [SKAction waitForDuration:0.1],
                                    [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15]]];
    
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
    
}

-(void)setPressRegoganizer{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                        initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.1; //seconds
    lpgr.delegate = self;
    [self.view addGestureRecognizer:lpgr];
}

-(void)prepareGameBackground{
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.size = CGSizeMake(self.frame.size.height, self.frame.size.width);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:bgImage];
    
    
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
        NSString *textureName = [NSString stringWithFormat:@"dragon%d", i];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [dragonFrames addObject:temp];
    }
    
    for (int i=1; i <= 2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"dragon%d", 7];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [dragonFrames addObject:temp];
    }
    
    for (int i=numImages/2; i >=1; i--) {
        NSString *textureName = [NSString stringWithFormat:@"dragon%d", i];
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
        NSString *textureName = [NSString stringWithFormat:@"claws%d", 7];
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
    UITouch *touch = [[event allTouches] anyObject];
    pointLocation = [touch locationInView:touch.view];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint endPosition = [touch locationInView:touch.view];
    
    if (pointLocation.y < endPosition.y) {
        // Down swipe
        NSLog(@"PRA BAIXO");
        
    } else if (pointLocation.y > endPosition.y){
        // Up swipe
        NSLog(@"PRA CIMA");
        
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

-(void)update:(CFTimeInterval)currentTime {
    score += 0.1;
    scoreLabel.text =[NSString stringWithFormat:@"%.0f", score];
    
    /* Called before each frame is rendered */
}

- (void)incrementCounter {
    counter++;
}

- (void) prepareAttack {
    _dragon.hidden = true;
    _claws.hidden = true;
    randomSide = arc4random_uniform(3);
    NSLog(@"começou ANIMAÇÃO");
    defenseUp = false;
    
    switch (randomSide)
    {
        case 0:
            [self attackingClaws];
            
            break;
        case 1:
            [self attackingDragonFire: TRUE];
            //            [self attackingClaws];
            
            break;
        case 2:
            [self attackingDragonFire: NO];
            //            [self attackingClaws];
            
            break;
            //        case 3:
            //            //            [self attackingDragonFire: NO];
            //            //            down.position = CGPointMake(sprite.position.x, -sprite.position.y);
            //            //            down.xScale = 0.5;
            //            //            down.yScale = 0.5;
            //            //            [sprite addChild:down];
            //
            //            break;
            //
            
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
   
    BOOL defended = true;
    
    switch (randomSide)
    {
        case 0:
            attackUp = true;
            if(defenseUp != attackUp)
                [self damageTaken];
            attackUp = false;
            defended = false;
            break;
        case 1:
            attackRight = true;
            if(defenseRight != attackRight)
                [self damageTaken];
            attackRight = false;
            defended = false;
            break;
        case 2:
            attackLeft = true;
            if(defenseLeft != attackLeft)
                [self damageTaken];
            attackLeft = false;
            defended = false;
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
//    if ( scoreLabel.text.intValue % 20 == 0.0 && scoreLabel.text.intValue > 20){
//        level -= 0.002f;
//        speed -= 0.05;
//    
//    NSLog([NSString stringWithFormat:@"%f", level]);
//    
//    SKAction *Timetofire= [SKAction sequence:@[
//                                               //time after you want to fire a function
//                                               [SKAction waitForDuration:5],
//                                               [SKAction performSelector:@selector(prepareAttack)
//                                                                onTarget:self]]];
//    [self runAction:[SKAction repeatActionForever:Timetofire ]];
//
//        
//    }
//    
}


-(void) getBonusScore {
    int actualScore = scoreLabel.text.intValue;
    actualScore += 50;
    scoreLabel.text = [NSString stringWithFormat:@"%d", actualScore];
}

-(void) damageTaken {
        
    int newLife = life.text.intValue;
    newLife --;
    [sprite runAction: pulseRed];
    life.text = [NSString stringWithFormat:@"%d", newLife];
    if ( newLife ==0 )
        [self endGame];
}

-(void) endGame {

}

@end
