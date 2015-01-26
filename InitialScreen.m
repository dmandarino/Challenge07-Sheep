//
//  InitialScreen.m
//  Challenge07-Sheep
//
//  Created by Felipe Argento on 1/25/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "InitialScreen.h"
#import "GameScene.h"
#import "HighScoreScene.h"
@implementation InitialScreen


-(void) didMoveToView:(SKView *)view {
    [self createBackground];
    
    SKSpriteNode *backButtonNode = [self createBackButton];
    [self addChild: backButtonNode];
    
    SKSpriteNode *scoreButtonNode = [self createScoreButton];
    [self addChild: scoreButtonNode];


}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];

    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"backButtonNode"]) {
        
        GameScene *scene = [GameScene sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1]];
    }else if ([node.name isEqualToString:@"highScoreNode"]){
        HighScoreScene *scene = [HighScoreScene sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1]];
    }
}

-(SKSpriteNode *) createBackButton {
    SKSpriteNode *backButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"play.png"];
    backButtonNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    backButtonNode.name = @"backButtonNode";//how the node is identified later
    backButtonNode.zPosition = 1.0;
    backButtonNode.xScale = 0.4;
    backButtonNode.yScale = 0.4;
    
    return backButtonNode;
}
-(SKSpriteNode *) createScoreButton {
    SKSpriteNode *backButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"more.png"];
    backButtonNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 60);
    backButtonNode.name = @"highScoreNode";//how the node is identified later
    backButtonNode.zPosition = 1.0;
    backButtonNode.xScale = 0.4;
    backButtonNode.yScale = 0.4;
    
    return backButtonNode;
}




-(void) createBackground {
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.size = CGSizeMake(self.size.height, self.size.width);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:bgImage];
}



@end