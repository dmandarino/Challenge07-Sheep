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
#import "InitialScreen.h"

@implementation HighScoreScene
SKLabelNode *scoreLabel;

-(void) didMoveToView:(SKView *)view {
    [self createBackground];
    
    SKSpriteNode *retryButtonNode = [self createRetryButton];
    [self addChild: retryButtonNode];
    
    SKSpriteNode *homeButtonNode = [self createHomeButton];
    [self addChild: homeButtonNode];
    
    [self showHighScore];
    
    [self showScore];
    
    [self rankingScore];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"retryButtonNode"]) {
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
        
        GameScene *scene = [GameScene sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    } else if ([node.name isEqualToString:@"homeButtonNode"]) {
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
        
        InitialScreen *scene = [InitialScreen sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
}

-(SKSpriteNode *) createRetryButton {
    SKSpriteNode *retryButtonNode;
    if ([RWGameData sharedGameData].score > 0 )
       retryButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"retry.png"];
    else
       retryButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"play2.png"]; 
    retryButtonNode.position = CGPointMake(CGRectGetMinX(self.frame)+40, CGRectGetMidY(self.frame)-60);
    retryButtonNode.name = @"retryButtonNode";//how the node is identified later
    retryButtonNode.zPosition = 1.0;
    retryButtonNode.xScale = 0.2;
    retryButtonNode.yScale = 0.2;
    
    return retryButtonNode;
}

-(SKSpriteNode *) createHomeButton {
    SKSpriteNode *homeButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"home.png"];
    homeButtonNode.position = CGPointMake(CGRectGetMidX(self.frame)+120, CGRectGetMidY(self.frame)-60);
    homeButtonNode.name = @"homeButtonNode";//how the node is identified later
    homeButtonNode.zPosition = 1.0;
    homeButtonNode.xScale = 0.2;
    homeButtonNode.yScale = 0.2;
    
    return homeButtonNode;
}

-(void) showScore {
    SKLabelNode *titleLabel ;

    titleLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    titleLabel.fontSize = 20;
    titleLabel.fontColor = [SKColor blackColor];
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+60);

    if ([RWGameData sharedGameData].score >= [RWGameData sharedGameData].highScore) {
        titleLabel.text = @"New High Score";
        titleLabel.fontColor = [SKColor redColor];
    } else {
        titleLabel.text = @"Score";
    }
    
    
    scoreLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 20;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+40);
    scoreLabel.fontColor = [SKColor blackColor];
    scoreLabel.text = [NSString stringWithFormat:@"%.0f",[RWGameData sharedGameData].score];
    
    
    
    [self addChild:titleLabel];
    [self addChild:scoreLabel];
}

-(void) rankingScore {
    SKLabelNode *titleLabel;
    titleLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    titleLabel.fontSize = 15;
    titleLabel.text = @"Ranking";
    titleLabel.fontColor = [SKColor blackColor];
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+10);
    
    [self addChild:titleLabel];
    
    NSString *value;
    int y = CGRectGetMidY(self.frame) - 5;
    
    for ( int i = 1 ; i <= 5 ; i++ ){
        
        switch (i) {
            case 1:
                value = [NSString stringWithFormat:@"%.0f", [RWGameData sharedGameData].topScore1];
                break;
            case 2:
                value = [NSString stringWithFormat:@"%.0f", [RWGameData sharedGameData].topScore2];
                y -= 15;
                break;
            case 3:
                value = [NSString stringWithFormat:@"%.0f", [RWGameData sharedGameData].topScore3];
                y -= 15;
                break;
            case 4:
                value = [NSString stringWithFormat:@"%.0f", [RWGameData sharedGameData].topScore4];
                y -= 15;
                break;
            case 5:
                value = [NSString stringWithFormat:@"%.0f", [RWGameData sharedGameData].topScore5];
                y -= 15;
                break;
        }
        
        SKLabelNode *ranking;
        ranking= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        ranking.fontSize = 15;
        ranking.text = [NSString stringWithFormat:@"%@", value];
        ranking.position = CGPointMake(CGRectGetMidX(self.frame), y);
        ranking.fontColor = [SKColor blackColor];
        
        [self addChild:ranking];
    }
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
