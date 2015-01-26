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
    
    SKSpriteNode *backButtonNode = [self createPlayButton];
    [self addChild: backButtonNode];
    
    SKSpriteNode *scoreButtonNode = [self createScoreButton];
    [self addChild: scoreButtonNode];

    
    SKSpriteNode *shopButtonNode = [self createShopButton];
    [self addChild: shopButtonNode];
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

-(SKSpriteNode *) createPlayButton {
    SKSpriteNode *backButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"play.png"];
    backButtonNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 60);
    backButtonNode.name = @"backButtonNode";//how the node is identified later
    backButtonNode.zPosition = 1.0;
    backButtonNode.xScale = 0.6;
    backButtonNode.yScale = 0.6;
    
    return backButtonNode;
}
-(SKSpriteNode *) createScoreButton {
    SKSpriteNode *backButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"ranking.png"];
    backButtonNode.position = CGPointMake(self.size.width/2 + 120 , self.size.height/2 - 60);
    backButtonNode.name = @"highScoreNode";//how the node is identified later
    backButtonNode.zPosition = 1.0;
    backButtonNode.xScale = 0.25;
    backButtonNode.yScale = 0.25;
    
    return backButtonNode;
}
-(SKSpriteNode *) createShopButton {
    SKSpriteNode *backShopNode = [SKSpriteNode spriteNodeWithImageNamed:@"cart.png"];
    backShopNode.position = CGPointMake(self.size.width/2 - 120 , self.size.height/2 - 60);
    backShopNode.name = @"shopNode";//how the node is identified later
    backShopNode.zPosition = 1.0;
    backShopNode.xScale = 0.25;
    backShopNode.yScale = 0.25;
    
    return backShopNode;
}



-(void) createBackground {
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.size = CGSizeMake(self.size.height, self.size.width);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:bgImage];

    SKSpriteNode *sheep = [SKSpriteNode spriteNodeWithImageNamed:@"nakedSheep.png"];
    sheep.xScale = 0.05;
    sheep.yScale = 0.05;
    sheep.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 15);
    [self addChild:sheep];
    
    SKSpriteNode *woodenSign = [SKSpriteNode spriteNodeWithImageNamed:@"wooden.png"];
    woodenSign.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 40);
    woodenSign.xScale = 0.3;
    woodenSign.yScale = 0.3;
    [self addChild: woodenSign];
    
}



@end
