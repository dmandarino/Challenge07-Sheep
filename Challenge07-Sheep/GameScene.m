//
//  GameScene.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/18/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "GameScene.h"



@implementation GameScene
CGFloat score = 0;
SKLabelNode *scoreLabel;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:bgImage];
    
    
    scoreLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 65;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   0);
    [self addChild:scoreLabel];
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"testsheep.PNG"];
    
    sprite.xScale = 0.1;
    sprite.yScale = 0.1;
    sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    
    [self addChild:sprite];

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    score = score + 1000;
    
}

-(void)update:(CFTimeInterval)currentTime {
    score += 0.3;
    scoreLabel.text =[NSString stringWithFormat:@"%.0f", score];
    /* Called before each frame is rendered */
}

@end
