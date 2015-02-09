//
//  Tutorial4Scene.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 2/9/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "Tutorial4Scene.h"
#import "RWGameData.h"
#import "SettingsScene.h"
#import "GameScene.h"

SKSpriteNode *soundButtonNode;
RWGameData *data;
CGPoint pointLocation;
SKTexture *fireBallImg;
SKSpriteNode *fireBall;

@implementation Tutorial4Scene
- (void) didMoveToView:(SKView *)view{
    data = [[RWGameData alloc]init];
    
    [self createFireBall];
    
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial4.png"];
    bgImage.size = CGSizeMake(self.frame.size.height, self.frame.size.width/1.5);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [self addChild:bgImage];
    
    [self createCountPage];
    //    SKSpriteNode *homeButtonNode = [self createHomeButton];
    //    [self addChild: homeButtonNode];
    
}

-(SKSpriteNode *) createHomeButton {
    SKSpriteNode *homeButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"home.png"];
    homeButtonNode.position = CGPointMake(CGRectGetMidX(self.frame) - 120, CGRectGetMidY(self.frame) - 60);
    homeButtonNode.name = @"homeButtonNode";//how the node is identified later
    homeButtonNode.zPosition = 1.0;
    homeButtonNode.xScale = 0.2;
    homeButtonNode.yScale = 0.2;
    
    return homeButtonNode;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"fireBallNode"]) {
        [self endTutorial];
    }
}


-(void) endTutorial {
    
    if ( _playScene ){
        SKTransition *reveal = [[SKTransition alloc] init];
        
        GameScene *scene = [GameScene sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [self.view presentScene:scene transition:reveal];
    } else {
        SKTransition *reveal = [[SKTransition alloc] init];
    
        SettingsScene *scene = [SettingsScene sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
    
        [self.view presentScene:scene transition:reveal];
    }
}

-(void) createCountPage {
    SKLabelNode *highScoreTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScoreTitle.fontSize = 10;
    highScoreTitle.fontColor = [SKColor redColor];
    highScoreTitle.position = CGPointMake(CGRectGetMidX(self.frame)- 120, CGRectGetMidY(self.frame)-70);
    highScoreTitle.text = @"4/4";
    highScoreTitle.zPosition = 1;
    [self addChild:highScoreTitle];
}

-(void) createFireBall {
    fireBallImg = [SKTexture textureWithImageNamed:@"fireBall.png"];
    fireBall = [SKSpriteNode spriteNodeWithTexture:fireBallImg];
    fireBall.name = @"fireBallNode";
    fireBall.xScale = 0.07;
    fireBall.yScale = 0.07;
    fireBall.zPosition = 3;
    fireBall.zRotation = 5 * M_PI/4;
    fireBall.position = CGPointMake(CGRectGetMidX(self.frame) + 90, CGRectGetMidY(self.frame)+60);
    
    [self addChild: fireBall];
}

@end
