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

//NSMutableArray *walkFrames = [NSMutableArray array];
//SKTextureAtlas *bearAnimatedAtlas = [SKTextureAtlas atlasNamed:@"BearImages"];
//
//int numImages = bearAnimatedAtlas.textureNames.count;
//for (int i=1; i <= numImages/2; i++) {
//    NSString *textureName = [NSString stringWithFormat:@"bear%d", i];
//    SKTexture *temp = [bearAnimatedAtlas textureNamed:textureName];
//    [walkFrames addObject:temp];
//}
//_bearWalkingFrames = walkFrames;
//
//SKTexture *temp = _bearWalkingFrames[0];
//_bear = [SKSpriteNode spriteNodeWithTexture:temp];
//_bear.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
//[self addChild:_bear];
//[self walkingBear];
//-(void)walkingBear
//{
//    NSLog(@"ENTREI NO WALKING");
//    //This is our general runAction method to make our bear walk.
//    [_bear runAction:[SKAction repeatActionForever:
//                      [SKAction animateWithTextures:_bearWalkingFrames
//                                       timePerFrame:0.1f
//                                             resize:NO
//                                            restore:YES]] withKey:@"walkingInPlaceBear"];
//    return;
//}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    [self prepareDragonImages];
    [self prepareClawsImages];
    [self prepareGameBackground];
    [self setLongPress];
    
    
    SKAction *Timetofire= [SKAction sequence:@[
                                               //time after you want to fire a function
                                               [SKAction waitForDuration:4],
                                               [SKAction performSelector:@selector(prepareAttack)
                                                                onTarget:self]
                                               
                                               ]];
    [self runAction:[SKAction repeatActionForever:Timetofire ]];
    
}
-(void)setLongPress{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //seconds
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
    
    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"viking.png"];
    sprite.xScale = 0.2;
    sprite.yScale = 0.2;
    sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:sprite];

}

-(void)prepareDragonImages{
    dragonFrames = [NSMutableArray array];
    dragonAnimatedAtlas = [SKTextureAtlas atlasNamed:@"dragon"];
    
    int numImages = dragonAnimatedAtlas.textureNames.count;
    for (int i=1; i <= numImages/2; i++) {
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
    _dragon.xScale = 0.5;
    _dragon.yScale = 0.15;
    
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
        
    _clawsAttackingFrames = clawsFrames;
    
    SKTexture *temp = _clawsAttackingFrames[0];
    _claws = [SKSpriteNode spriteNodeWithTexture:temp];
    _claws.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+60);
    _claws.xScale = 0.2;
    _claws.yScale = 0.3;
    [self addChild:_claws];
}

-(void)attackingDragonFire: (BOOL)isRightSide{
    
    CGFloat multiplierForDirection;
    
    if (isRightSide) {
        multiplierForDirection = 1;
        _dragon.position = CGPointMake(CGRectGetMaxX(self.frame)-50, CGRectGetMidY(self.frame)-20);

        
    } else {
        multiplierForDirection = -1;
        _dragon.position = CGPointMake(CGRectGetMinX(self.frame)+50, CGRectGetMidY(self.frame)-20);

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
//            [self attackingClaws];

            break;
        case 2:
             [self attackingDragonFire: NO];
//            [self attackingClaws];
            
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
            break;
        case 1:
            attackRight = true;
            break;
        case 2:
            attackDown = true;
            break;
        case 3:
            attackLeft = true;
            break;
            
    }
}



@end
