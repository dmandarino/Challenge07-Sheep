//
//  GameScene.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/18/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "GameScene.h"
#import "GameViewController.h"



@implementation GameScene{
    
    SKSpriteNode *_dragon;
    NSArray *_dragonFireFrames;
    
}

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
SKSpriteNode *up;
SKSpriteNode *down;
SKSpriteNode *right;
SKSpriteNode *left;
SKSpriteNode *sprite;
SKAction *runAnimation;
NSMutableArray *dragonFrames;
SKTextureAtlas *dragonAnimatedAtlas;

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
    
    
    dragonFrames = [NSMutableArray array];
    dragonAnimatedAtlas = [SKTextureAtlas atlasNamed:@"dragon"];
    
    [self prepareDragonImages];
    
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
    
}


-(void)prepareDragonImages{
    int numImages = dragonAnimatedAtlas.textureNames.count;
//    for (int i=1; i <= numImages/2; i++) {
//        NSString *textureName = [NSString stringWithFormat:@"dragon%d", i];
//        SKTexture *temp = [dragonAnimatedAtlas textureNamed:textureName];
//        [dragonFrames addObject:temp];
//    }
    
    
    NSString *textureName = [NSString stringWithFormat:@"dragon1"];
    SKTexture *temp1 = [dragonAnimatedAtlas textureNamed:textureName];
    [dragonFrames addObject:temp1];
    textureName = [NSString stringWithFormat:@"dragon1"];
    temp1 = [dragonAnimatedAtlas textureNamed:textureName];
    [dragonFrames addObject:temp1];
    textureName = [NSString stringWithFormat:@"dragon2"];
    temp1 = [dragonAnimatedAtlas textureNamed:textureName];
    [dragonFrames addObject:temp1];
    textureName = [NSString stringWithFormat:@"dragon3"];
    temp1 = [dragonAnimatedAtlas textureNamed:textureName];
    [dragonFrames addObject:temp1];
    textureName = [NSString stringWithFormat:@"dragon4"];
    temp1 = [dragonAnimatedAtlas textureNamed:textureName];
    [dragonFrames addObject:temp1];
    textureName = [NSString stringWithFormat:@"dragon5"];
    temp1 = [dragonAnimatedAtlas textureNamed:textureName];
    [dragonFrames addObject:temp1];
    textureName = [NSString stringWithFormat:@"dragon6"];
    temp1 = [dragonAnimatedAtlas textureNamed:textureName];
    [dragonFrames addObject:temp1];
    textureName = [NSString stringWithFormat:@"dragon7"];
    temp1 = [dragonAnimatedAtlas textureNamed:textureName];
    [dragonFrames addObject:temp1];
    
    
    _dragonFireFrames = dragonFrames;
    
    SKTexture *temp = _dragonFireFrames[0];
    _dragon = [SKSpriteNode spriteNodeWithTexture:temp];
    _dragon.position = CGPointMake(CGRectGetMaxX(self.frame)-30, CGRectGetMidY(self.frame)-20);
    _dragon.xScale = 0.4;
    _dragon.yScale = 0.15;

    [self addChild:_dragon];

}

-(void)attackingDragonFire
{
    [_dragon runAction:[SKAction repeatAction:[SKAction animateWithTextures:_dragonFireFrames
                                                            timePerFrame:0.2f
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
            NSLog(@"Defend .. %d seconds", counter);
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
    randomSide = arc4random_uniform(4);
    up = [SKSpriteNode spriteNodeWithImageNamed:@"claws.png"];
    down = [SKSpriteNode spriteNodeWithImageNamed:@"tail.png"];
    right = [SKSpriteNode spriteNodeWithImageNamed:@"dragonRight-1.png"];
    left = [SKSpriteNode spriteNodeWithImageNamed:@"dragonLeft-1.png"];
    attackDown = false;
    attackLeft = false;
    attackRight = false;
    attackUp = false;
    
    [sprite removeAllChildren];
    
    switch (randomSide)
    {
        case 0:
            [self attackingDragonFire];
//            up.position = CGPointMake(sprite.position.x - 300, sprite.position.y * 1.3);
//            up.xScale = 0.5;
//            up.yScale = 0.5;
//            [sprite addChild:up];
            break;
        case 1:
            [self attackingDragonFire];
//            right.position = CGPointMake(sprite.position.x * 4, sprite.position.y/2);
//            right.xScale = 0.5;
//            right.yScale = 0.5;
//            [sprite addChild:right];
            break;
        case 2:
            [self attackingDragonFire];
//            down.position = CGPointMake(sprite.position.x, -sprite.position.y);
//            down.xScale = 0.5;
//            down.yScale = 0.5;
//            [sprite addChild:down];
            break;
        case 3:
            [self attackingDragonFire];
//            left.position = CGPointMake(-700, sprite.position.y/2);
//            left.xScale = 0.5;
//            left.yScale = 0.5;
//            [sprite addChild:left];
            break;
            
            
    }


    SKAction *attackLaunch= [SKAction sequence:@[
                                               //time after you want to fire a function
                                               [SKAction waitForDuration:arc4random()%2],
                                               [SKAction performSelector:@selector(attack)
                                                                onTarget:self]
                                               
                                               ]];
    [self runAction:[SKAction repeatAction:attackLaunch count: 1]];
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
