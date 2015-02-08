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
#import "Store.h"
#import "TutorialScene.h"
#import <AVFoundation/AVFoundation.h>
#import "RWGameData.h"

@implementation InitialScreen
RWGameData *data;


-(void) didMoveToView:(SKView *)view {
    data = [[RWGameData alloc] init];
    
    [self createBackground];
    
    SKSpriteNode *backButtonNode = [self createPlayButton];
    [self addChild: backButtonNode];
    
    SKSpriteNode *scoreButtonNode = [self createScoreButton];
    [self addChild: scoreButtonNode];

    SKSpriteNode *shopButtonNode = [self createShopButton];
    [self addChild: shopButtonNode];
    
    SKSpriteNode *helpButtonNode = [self createHelpButton];
    [self addChild: helpButtonNode];
    
    [self playEffectBgSounds];
}

-(void)playEffectBgSounds{
    if ([[data isSoundOn]boolValue]){
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:@"initialScreen"
                                             ofType:@"mp3"]];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player.numberOfLoops = -1;
        
        [_player play];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];

    //if fire button touched, bring the rain
    if ([node.name isEqualToString:@"playButtonNode"]) {
        if ([[data firstPlaying] boolValue]){
            [data updateFirstPlaying:[NSNumber numberWithBool:NO]];
            [self goToTutorialScene];
        } else {
            GameScene *scene = [GameScene sceneWithSize:self.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            scene.level = 1;
            
            [self.view presentScene:scene transition:[[SKTransition alloc] init]];
        }
    }else if ([node.name isEqualToString:@"highScoreNode"]){
        HighScoreScene *scene = [HighScoreScene sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;

        [self.view presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1]];
    }else if([node.name isEqualToString:@"shopNode"]){
        Store *scene = [Store sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;

        [self.view presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1]];
    }else if([node.name isEqualToString:@"helpNode"]){
        [self goToTutorialScene];
    }

}

-(SKSpriteNode *) createPlayButton {
    SKSpriteNode *backButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"play.png"];
    backButtonNode.position = CGPointMake(self.size.width/2 , self.size.height/2 - 70);
    backButtonNode.name = @"playButtonNode";//how the node is identified later
    backButtonNode.zPosition = 1.0;
    backButtonNode.xScale = 0.6;
    backButtonNode.yScale = 0.6;
    
    return backButtonNode;
}
-(SKSpriteNode *) createScoreButton {
    SKSpriteNode *backButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"ranking.png"];
    backButtonNode.position = CGPointMake(self.size.width/2 - 100 , self.size.height/2 - 70);
    backButtonNode.name = @"highScoreNode";//how the node is identified later
    backButtonNode.zPosition = 1.0;
    backButtonNode.xScale = 0.1;
    backButtonNode.yScale = 0.1;
    
    return backButtonNode;
}
-(SKSpriteNode *) createShopButton {
    SKSpriteNode *backShopNode = [SKSpriteNode spriteNodeWithImageNamed:@"cart.png"];
    backShopNode.position = CGPointMake(self.size.width/2 - 130 , self.size.height/2 - 70);
    backShopNode.name = @"shopNode";//how the node is identified later
    backShopNode.zPosition = 1.0;
    backShopNode.xScale = 0.1;
    backShopNode.yScale = 0.1;
    
    return backShopNode;
}

-(SKSpriteNode *) createHelpButton {
    SKSpriteNode *backShopNode = [SKSpriteNode spriteNodeWithImageNamed:@"help.png"];
    backShopNode.position = CGPointMake(CGRectGetMidX(self.frame) - 70, CGRectGetMidY(self.frame)-70);
    backShopNode.name = @"helpNode";//how the node is identified later
    backShopNode.zPosition = 1.0;
    backShopNode.xScale = 0.1;
    backShopNode.yScale = 0.1;
    
    return backShopNode;
}

-(void) createBackground {
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.size = CGSizeMake(self.size.height, self.size.width);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:bgImage];

    SKSpriteNode *sheep = [SKSpriteNode spriteNodeWithImageNamed:@"nakedSheep.png"];
    sheep.xScale = 0.06;
    sheep.yScale = 0.06;
    sheep.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 10);
    [self addChild:sheep];

    SKSpriteNode *woodenSign = [SKSpriteNode spriteNodeWithImageNamed:@"wooden.png"];
    woodenSign.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 50);
    woodenSign.xScale = 0.3;
    woodenSign.yScale = 0.3;
    [self addChild: woodenSign];
    
}

-(void) goToTutorialScene {
    TutorialScene *scene = [TutorialScene sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.view presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1]];
}


@end
