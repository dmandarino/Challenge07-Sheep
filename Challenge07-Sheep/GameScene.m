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
SKSpriteNode *up;
SKSpriteNode *down;
SKSpriteNode *right;
SKSpriteNode *left;
SKSpriteNode *sprite;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
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
    } else {
        // Up swipe
        NSLog(@"PRA CIMA");
    }
}

-(void)update:(CFTimeInterval)currentTime {
    score += 0.1;
    scoreLabel.text =[NSString stringWithFormat:@"%.0f", score];

    /* Called before each frame is rendered */
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

- (void)incrementCounter {
    counter++;
}

- (void) prepareAttack {
    randomSide = arc4random_uniform(4);
    up = [SKSpriteNode spriteNodeWithImageNamed:@"claws.png"];
    down = [SKSpriteNode spriteNodeWithImageNamed:@"tail.png"];
    right = [SKSpriteNode spriteNodeWithImageNamed:@"dragon1-right.png"];
    left = [SKSpriteNode spriteNodeWithImageNamed:@"dragon1-left.png"];
    attackDown = false;
    attackLeft = false;
    attackRight = false;
    attackUp = false;
    
    [sprite removeAllChildren];
    
    switch (randomSide)
    {
        case 0:
            up.position = CGPointMake(sprite.position.x - 300, sprite.position.y * 1.3);
            up.xScale = 0.5;
            up.yScale = 0.5;
            [sprite addChild:up];
            break;
        case 1:

            right.position = CGPointMake(sprite.position.x * 4, sprite.position.y/2);
            right.xScale = 0.5;
            right.yScale = 0.5;
            [sprite addChild:right];
            break;
        case 2:
            down.position = CGPointMake(sprite.position.x, -sprite.position.y);
            down.xScale = 0.5;
            down.yScale = 0.5;
            [sprite addChild:down];
            break;
        case 3:
            left.position = CGPointMake(-700, sprite.position.y/2);
            left.xScale = 0.5;
            left.yScale = 0.5;
            [sprite addChild:left];
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
