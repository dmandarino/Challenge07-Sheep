//
//  HighScoreScene.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/23/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "HighScoreScene.h"
#import "GameScene.h"
#import "RWGameData.h"

@implementation HighScoreScene
SKLabelNode *scoreLabel;

-(void) didMoveToView:(SKView *)view {
    [self createBackground];
    
    [self showScore];
    
    SKSpriteNode *backButtonNode = [self createBackButton];
    [self addChild: backButtonNode];
    
    [self showHighScore];
    
    
//    SKLabelNode *rankingLabel;
//    rankingLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    rankingLabel.fontSize = 30;
//    rankingLabel.position = CGPointMake(CGRectGetMidX(self.frame)- 80, CGRectGetMidY(self.frame)+30);
//    rankingLabel.text = [NSMutableString stringWithFormat:@"High Score \n%@",[[RWGameData sharedGameData].ranking objectAtIndex:0]];
//    [self addChild:rankingLabel];
    
//    [self saveScore];
}

-(void) saveScore {
//    [[RWGameData sharedGameData] save];
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
    } else if ([node.name isEqualToString:@"saveButton"]) {
        [self saveScore];
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

-(SKSpriteNode *) createSaveButton {
    SKSpriteNode *backButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"retryButton.png"];
    backButtonNode.position = CGPointMake(CGRectGetMinX(self.frame)+200, CGRectGetMidY(self.frame)-60);
    backButtonNode.name = @"saveButton";//how the node is identified later
    backButtonNode.zPosition = 1.0;
    backButtonNode.xScale = 0.4;
    backButtonNode.yScale = 0.4;
    
    return backButtonNode;
}

-(void) showScore {
    SKLabelNode *titleLabel ;
    titleLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    titleLabel.fontSize = 30;
    
    if ([RWGameData sharedGameData].score >= [RWGameData sharedGameData].highScore) {
        titleLabel.text = @"New High Score";
    } else {
        titleLabel.text = @"Score";
    }
    
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+30);

    [self addChild:titleLabel];

    scoreLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 30;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    scoreLabel.text = [NSString stringWithFormat:@"%.0f",[RWGameData sharedGameData].score];
    scoreLabel.fontColor = [SKColor whiteColor];
    [self addChild:scoreLabel];
}

-(void) showHighScore {
    SKLabelNode *highScoreTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScoreTitle.fontSize = 10;
    highScoreTitle.fontColor = [SKColor redColor];
    highScoreTitle.position = CGPointMake(CGRectGetMidX(self.frame)+ 120, CGRectGetMidY(self.frame)+70);
    highScoreTitle.text = @"High Score";
    [self addChild:highScoreTitle];
    
    
    SKLabelNode *highScore;
    highScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScore.fontSize = 10;
    highScore.fontColor = [SKColor redColor];
    highScore.position = CGPointMake(CGRectGetMidX(self.frame)+ 120, CGRectGetMidY(self.frame)+60);
    highScore.text = [NSMutableString stringWithFormat:@"%.0f",[RWGameData sharedGameData].highScore];
    [self addChild:highScore];

}

-(void) createBackground {
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.size = CGSizeMake(self.size.height, self.size.width);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:bgImage];
}

@end
