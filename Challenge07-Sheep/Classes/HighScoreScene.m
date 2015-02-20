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
#import "Services.h"

@implementation HighScoreScene
SKLabelNode *scoreLabel;
RWGameData *data;
Services *services;

-(void) didMoveToView:(SKView *)view {
    [self createBackground];
    
    SKSpriteNode *retryButtonNode = [self createRetryButton];
    [self addChild: retryButtonNode];
    
    SKSpriteNode *homeButtonNode = [self createHomeButton];
    [self addChild: homeButtonNode];
    
    [self loadValues];
    
    [self showHighScore];
    
    [self showScore];
    
    [self showCoins];
    
    [self rankingScore];
    
    [self playEffectBgSounds];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"retryButtonNode"]) {
        [_player stop];
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];

        GameScene *scene = [GameScene sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        scene.level = 1;

        [self.view presentScene:scene transition:reveal];
    } else if ([node.name isEqualToString:@"homeButtonNode"]) {
        [_player stop];
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
        
        InitialScreen *scene = [InitialScreen sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
    }
}

-(SKSpriteNode *) createRetryButton {
    SKSpriteNode *retryButtonNode;
    if ( _score > 0 )
       retryButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"retry.png"];
    else
       retryButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"play2.png"]; 
    retryButtonNode.position = CGPointMake(CGRectGetMidX(self.frame)-120, CGRectGetMidY(self.frame)-70);
    retryButtonNode.name = @"retryButtonNode";//how the node is identified later
    retryButtonNode.zPosition = 1.0;
    retryButtonNode.xScale = 0.15;
    retryButtonNode.yScale = 0.15;
    
    return retryButtonNode;
}

-(void) showCoins{
    
    SKLabelNode *coinsLabel;
    SKSpriteNode *coinsImg;
    
    coinsLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    coinsLabel.fontSize = 12;
    coinsLabel.position = CGPointMake(CGRectGetMidX(self.frame)-108, CGRectGetMidY(self.frame)+64);
    coinsLabel.fontColor = [SKColor blackColor];
    coinsLabel.text = [NSString stringWithFormat:@"%.0f", _coins];
    coinsLabel.zPosition = 1;
    [self addChild:coinsLabel];
    
    coinsImg = [SKSpriteNode spriteNodeWithImageNamed:@"coins.png"];
    coinsImg.xScale = 0.05;
    coinsImg.yScale = 0.05;
    coinsImg.position = CGPointMake(CGRectGetMidX(self.frame)-135, CGRectGetMidY(self.frame)+71);
    coinsImg.zPosition = 1;
    [self addChild:coinsImg];
}

-(SKSpriteNode *) createHomeButton {
    SKSpriteNode *homeButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"home.png"];
    homeButtonNode.position = CGPointMake(CGRectGetMidX(self.frame)+120, CGRectGetMidY(self.frame)-70);
    homeButtonNode.name = @"homeButtonNode";//how the node is identified later
    homeButtonNode.zPosition = 1.0;
    homeButtonNode.xScale = 0.15;
    homeButtonNode.yScale = 0.15;
    
    return homeButtonNode;
}

-(void) showScore {
    SKLabelNode *titleLabel ;

    titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    titleLabel.fontSize = 20;
    titleLabel.fontColor = [SKColor blackColor];
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+60);
    titleLabel.zPosition = 1;
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];

    if ( _score >= [[_ranking objectAtIndex:0] floatValue]) {
        titleLabel.text = @"New High Score";
        titleLabel.fontColor = [SKColor redColor];
        scoreLabel.fontColor = [SKColor redColor];
    } else {
        titleLabel.text = @"Score";
        scoreLabel.fontColor = [SKColor blackColor];
    }
    
    
    scoreLabel.fontSize = 20;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+37);
    scoreLabel.text = [NSString stringWithFormat:@"%.0f", _score];
    scoreLabel.zPosition = 1;
    
    
    
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
    titleLabel.zPosition = 1;
    
    [self addChild:titleLabel];
    
    NSString *value;
    int y = CGRectGetMidY(self.frame) +10;
    
    for ( int i = 0 ; i < 5 ; i++ ) {
        
        if ( [_ranking count] > i )
            value = [NSString stringWithFormat:@"%.0f", [[_ranking objectAtIndex:i] floatValue]];
        else
            value = @"0";
        
        y -= 15;
        
        SKLabelNode *ranking;
        ranking= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        ranking.fontSize = 15;
        ranking.text = [NSString stringWithFormat:@"%@", value];
        ranking.position = CGPointMake(CGRectGetMidX(self.frame), y);
        ranking.fontColor = [SKColor blackColor];
        ranking.zPosition = 1;
        
        [self addChild:ranking];
    }
}

-(void) showHighScore {
    SKLabelNode *highScoreTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScoreTitle.fontSize = 10;
    highScoreTitle.fontColor = [SKColor redColor];
    highScoreTitle.position = CGPointMake(CGRectGetMidX(self.frame)+ 120, CGRectGetMidY(self.frame)+70);
    highScoreTitle.text = @"High Score";
    highScoreTitle.zPosition = 1;
    [self addChild:highScoreTitle];
    
    
    SKLabelNode *highScore;
    highScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScore.fontSize = 10;
    highScore.fontColor = [SKColor redColor];
    highScore.position = CGPointMake(CGRectGetMidX(self.frame)+ 120, CGRectGetMidY(self.frame)+60);
    highScore.text = [NSMutableString stringWithFormat:@"%.0f", [[_ranking objectAtIndex:0] floatValue]];
    highScoreTitle.zPosition = 1;
    [self addChild:highScore];

}

-(void) createBackground {
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.size = CGSizeMake(self.size.height, self.size.width);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    bgImage.zPosition = 0;
    [self addChild:bgImage];
}

-(void)playEffectBgSounds{
    _player = [services playEffectBgSounds:@"backgroundMusic"];
    if ([[data isSoundOn]boolValue])
        [_player play];
}

-(NSMutableArray *) getRankingList {
    _ranking = [data loadRanking];
    return _ranking;
}

-(void) loadValues {
    data = [[RWGameData alloc] init];
    services = [[Services alloc] init];
    _ranking = [self getRankingList];
}

@end
