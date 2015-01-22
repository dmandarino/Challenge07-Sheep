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


SKLabelNode *lifeLabel;
CGFloat score = 0;
SKLabelNode *scoreLabel;
CGPoint pointLocation;
int counter = 0;
int randomSide = 5;
NSTimer *timer;
bool attackLeft = false;
bool attackRight = false;
bool attackUp = false;
bool attackDown = false;
//SKSpriteNode *up;
//SKSpriteNode *down;
//SKSpriteNode *right;
//SKSpriteNode *left;
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


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    [self prepareDragonImages];
    [self prepareClawsImages];
    
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.size = CGSizeMake(self.frame.size.height, self.frame.size.width);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:bgImage];
    
    scoreLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 15;
    scoreLabel.position = CGPointMake((self.frame.size.width/8), (self.frame.size.height/2.8));
    [self addChild:scoreLabel];
    
    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"viking.png"];
    sprite.xScale = 0.2;
    sprite.yScale = 0.2;
    sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:sprite];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //seconds
    lpgr.delegate = self;
    [self.view addGestureRecognizer:lpgr];
    
    
    SKAction *Timetofire= [SKAction sequence:@[
                                               //time after you want to fire a function
                                               [SKAction waitForDuration:4],
                                               [SKAction performSelector:@selector(prepareAttack)
                                                                onTarget:self]
                                               
                                               ]];
    [self runAction:[SKAction repeatActionForever:Timetofire ]];

    SKSpriteNode *heartImage = [SKSpriteNode spriteNodeWithImageNamed:@"heart.png"];
    heartImage.xScale = 0.01;
    heartImage.yScale = 0.01;
    heartImage.position = CGPointMake(CGRectGetMidX(self.frame)-135, CGRectGetMidY(self.frame)+75);
    [self addChild:heartImage];
   
    lifeLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lifeLabel.text = @"3";
    lifeLabel.fontColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    lifeLabel.fontSize = 20;
    lifeLabel.position = CGPointMake(CGRectGetMidX(self.frame)-118, CGRectGetMidY(self.frame)+68);
    
    [self addChild: lifeLabel];

}


-(void)prepareDragonImages{
    dragonFrames = [NSMutableArray array];
    dragonAnimatedAtlas = [SKTextureAtlas atlasNamed:@"dragon"];
    
    int numImages = dragonAnimatedAtlas.textureNames.count;

    for (int i=1; i <= numImages/2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"dragao%d", i];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [dragonFrames addObject:temp];
    }

    for (int i=1; i <= 4; i++) {
        NSString *textureName = [NSString stringWithFormat:@"dragao7"];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [dragonFrames addObject:temp];
    }
    
    for (int i=7; i >= 1; i--) {
        NSString *textureName = [NSString stringWithFormat:@"dragao%d", i];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [dragonFrames addObject:temp];
    }
    NSLog(@"num de img no animated = %d", dragonFrames.count);
    
    
    _dragonFireFrames = dragonFrames;
    
    SKTexture *temp = _dragonFireFrames[0];
    _dragon = [SKSpriteNode spriteNodeWithTexture:temp];
    _dragon.xScale = 0.1;
    _dragon.yScale = 0.1;
    
    [self addChild:_dragon];

 
}

-(void)prepareClawsImages{
    
    clawsFrames = [NSMutableArray array];
    
    int numImages = dragonAnimatedAtlas.textureNames.count;
    for (int i=1; i<= numImages/2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"claws%d", i];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [clawsFrames addObject:temp];
    }
    for (int i=7; i> 1; i--) {
        NSString *textureName = [NSString stringWithFormat:@"claws%d", i];
        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
        [clawsFrames addObject:temp];
    }
    
    _clawsAttackingFrames = clawsFrames;
    
    SKTexture *temp = _clawsAttackingFrames[0];
    _claws = [SKSpriteNode spriteNodeWithTexture:temp];
    _claws.position = CGPointMake(CGRectGetMidX(self.frame)+20, CGRectGetMidY(self.frame)+60);
    _claws.xScale = 0.2;
    _claws.yScale = 0.3;
    [self addChild:_claws];
}

-(void)attackingDragonFire: (BOOL)isRightSide{
    
    CGFloat multiplierForDirection;
    
    if (isRightSide) {
        multiplierForDirection = 1;
        _dragon.position = CGPointMake(CGRectGetMaxX(self.frame)-75, CGRectGetMidY(self.frame)-20);
        
    } else {
        multiplierForDirection = -1;
        _dragon.position = CGPointMake(CGRectGetMinX(self.frame)+75, CGRectGetMidY(self.frame)-20);
    }
    
    _dragon.xScale = fabs(_dragon.xScale) * multiplierForDirection;


    
    [_dragon runAction:[SKAction repeatAction:[SKAction animateWithTextures:_dragonFireFrames
                                                            timePerFrame:0.2f
                                                                  resize:NO
                                                                 restore:YES] count: 1]];

    return;
}

-(void)attackingClaws {
    [_claws runAction:[SKAction repeatAction:[SKAction animateWithTextures:_clawsAttackingFrames
                                                               timePerFrame:0.3f
                                                                     resize:NO
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
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGFloat x = pointLocation.x;
    CGFloat y = pointLocation.y;
    
    if( x>=290 && x<=450 && y>=100 && y<=230){
    
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            counter = 1;
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
        }
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [timer invalidate];
            NSLog(@"Defend right.. %d seconds", counter);
        }
    }else{
        if(x>=100 && x<=260 && y>=100 && y<=230){
            
            if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
                counter = 1;
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
            }
            if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
                [timer invalidate];
                NSLog(@"Defend left.. %d seconds", counter);
            }
        }
        
    }
    NSLog(@"Pressed at x = %0.f and y = %0.f",x,y);
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
    randomSide = arc4random_uniform(3);
//    up = [SKSpriteNode spriteNodeWithImageNamed:@"claws.png"];
//    down = [SKSpriteNode spriteNodeWithImageNamed:@"tail.png"];
//    right = [SKSpriteNode spriteNodeWithImageNamed:@"dragonRight-1.png"];
//    left = [SKSpriteNode spriteNodeWithImageNamed:@"dragonLeft-1.png"];
    attackDown = false;
    attackLeft = false;
    attackRight = false;
    attackUp = false;
    
//    [sprite removeAllChildren];
    
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
        case 3:
            //            [self attackingDragonFire: NO];
            //            down.position = CGPointMake(sprite.position.x, -sprite.position.y);
            //            down.xScale = 0.5;
            //            down.yScale = 0.5;
            //            [sprite addChild:down];

            break;

            
    }

//
//    SKAction *attackLaunch= [SKAction sequence:@[
//                                               //time after you want to fire a function
//                                               [SKAction waitForDuration:arc4random()%2],
//                                               [SKAction performSelector:@selector(attack)
//                                                                onTarget:self]
//                                               
//                                               ]];
//    [self runAction:[SKAction repeatAction:attackLaunch count: 1]];
}
- (void) attack {
    switch (randomSide)
    {
        case 0:
            attackUp = true;
//            if(defenseUp != attackUp){
                [self damageTaken];
//            }
            attackUp = false;
            break;
        case 1:
            attackRight = true;
//            if(defenseRight != attackRight){
                [self damageTaken];
//            }
            attackRight = false;
            break;
        case 2:
            attackLeft = true;
//            if(defenseLeft != attackLeft){
               [self damageTaken];
//            }
            attackLeft = false;
            break;
        case 3:
            attackLeft = true;
            break;
            
    }
}
-(void)damageTaken{
    int life = lifeLabel.text.intValue;
    life --;
    lifeLabel.text = [NSString stringWithFormat:@"%d", life];
    if(life == 0 )
        [self endGame];
}

-(void)endGame{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Loose!" message:[NSString stringWithFormat:@"%@", scoreLabel.text]
        delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Say Hello",nil];
    [alert show];
}


@end
