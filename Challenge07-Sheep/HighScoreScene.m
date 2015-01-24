//
//  HighScoreScene.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/23/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "HighScoreScene.h"
#import "GameScene.h"

@implementation HighScoreScene
SKLabelNode *scoreLabel;

-(void) didMoveToView:(SKView *)view {
    [self createBackground];
    
    [self showScore];
    
    SKLabelNode *titleLabel = [self createTitleLabel];
    [self addChild:titleLabel];
    
    SKSpriteNode *backButtonNode = [self createBackButton];
    [self addChild: backButtonNode];
    
    
//    [self saveScore];
}

-(void) saveScore {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"score" ofType:@"plist"];
    NSMutableDictionary *plistdict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    [plistdict writeToFile:filePath atomically:YES];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"backButtonNode"]) {
        SKTransition *reveal = [SKTransition fadeWithDuration:3];
        
        GameScene *scene = [GameScene sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
}

-(SKSpriteNode *) createBackButton {
    SKSpriteNode *backButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"retryButton.png"];
    backButtonNode.position = CGPointMake(CGRectGetMinX(self.frame)+60, CGRectGetMidY(self.frame)-60);
    backButtonNode.name = @"backButtonNode";//how the node is identified later
    backButtonNode.zPosition = 1.0;
    backButtonNode.xScale = 0.4;
    backButtonNode.yScale = 0.4;
    
    return backButtonNode;
}

-(void) showScore {
    scoreLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 30;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:scoreLabel];
}

-(SKLabelNode *) createTitleLabel {
    SKLabelNode *titleLabel ;
    titleLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    titleLabel.fontSize = 30;
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+30);
    titleLabel.text = @"Score";
    
    return titleLabel;
}

-(void) createBackground {
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.size = CGSizeMake(self.size.height, self.size.width);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:bgImage];
}

@end
