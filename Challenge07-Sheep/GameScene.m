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
NSTimer *timer;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.size = CGSizeMake(self.frame.size.height, self.frame.size.width);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:bgImage];
    
    
    scoreLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 15;
    scoreLabel.position = CGPointMake((self.frame.size.width/2)-132, (self.frame.size.height/2)-85);
    [self addChild:scoreLabel];
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"viking.png"];
    sprite.xScale = 0.2;
    sprite.yScale = 0.2;
    sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:sprite];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //seconds
    lpgr.delegate = self;
    [self.view addGestureRecognizer:lpgr];

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    score = score + 1000;
    UITouch *touch = [[event allTouches] anyObject];
    pointLocation = [touch locationInView:touch.view];
}

-(void)update:(CFTimeInterval)currentTime {
    score += 0.05;
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

@end
