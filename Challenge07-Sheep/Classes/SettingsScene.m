//
//  SettingsScene.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 2/8/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "SettingsScene.h"
#import "TutorialScene.h"
#import "InitialScreen.h"
#import "trailerScene.h"
#import "GameScene.h"
#import "RWGameData.h"
#import "Services.h"

SKSpriteNode *soundButtonNode;
RWGameData *data;
Services *services;

@implementation SettingsScene
- (void) didMoveToView:(SKView *)view{
    data = [[RWGameData alloc]init];
    
    [self createBackground];
    
    SKSpriteNode *homeButtonNode = [self createHomeButton];
    [self addChild: homeButtonNode];
    
    [self createMuteButton];
    [self createTrailerButton];
    [self createPlayButton];
    [self createTutorialButton];
    [self playEffectBgSounds];
}

-(void)playEffectBgSounds{
    _player = [services playEffectBgSounds:@"initialScreen"];
    if ([[data isSoundOn]boolValue]){
        [_player play];
    }else{
        [_player stop];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"homeButtonNode"]) {
        [self goToHome];
    } else if ([node.name isEqualToString:@"muteButtonNode"]) {
        [self updateSoundSettings];
        [self playEffectBgSounds];
    } else if ([node.name isEqualToString:@"tutorialButtonNode"]) {
        [self goToTutorial];
    } else if ([node.name isEqualToString:@"trailerButtonNode"]) {
        [self goToTrailer];
    } else if ([node.name isEqualToString:@"playButtonNode"]) {
        [self playGame];
    }
}


-(SKSpriteNode *) createHomeButton {
    SKSpriteNode *homeButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"home.png"];
    homeButtonNode.position = CGPointMake(CGRectGetMidX(self.frame) + 120, CGRectGetMidY(self.frame) - 60);
    homeButtonNode.name = @"homeButtonNode";//how the node is identified later
    homeButtonNode.zPosition = 1.0;
    homeButtonNode.xScale = 0.15;
    homeButtonNode.yScale = 0.15;
    
    return homeButtonNode;
}

-(void) createPlayButton {
    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"play2.png"];
    playButton.position = CGPointMake(CGRectGetMidX(self.frame) - 120, CGRectGetMidY(self.frame) - 60);
    playButton.name = @"playButtonNode";//how the node is identified later
    playButton.zPosition = 1.0;
    playButton.xScale = 0.15;
    playButton.yScale = 0.15;
    
    [self addChild:playButton];
}

-(void) createTutorialButton {
    SKSpriteNode *tutorialButton = [SKSpriteNode spriteNodeWithImageNamed:@"tutorialButton.png"];
    tutorialButton.position = CGPointMake(CGRectGetMidX(self.frame) + 60, CGRectGetMidY(self.frame));
    tutorialButton.name = @"tutorialButtonNode";//how the node is identified later
    tutorialButton.zPosition = 1.0;
    tutorialButton.xScale = 0.2;
    tutorialButton.yScale = 0.2;
    
    [self addChild:tutorialButton];
}

-(void) createMuteButton {
    soundButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"sound.png"];
    soundButtonNode.position = CGPointMake(CGRectGetMidX(self.frame) - 60, CGRectGetMidY(self.frame));
    soundButtonNode.name = @"muteButtonNode";//how the node is identified later
    soundButtonNode.zPosition = 1.0;
    soundButtonNode.xScale = 0.2;
    soundButtonNode.yScale = 0.2;
    
    if (![[data isSoundOn] boolValue])
        [soundButtonNode setTexture:[SKTexture textureWithImageNamed:@"mute.png"]];
    
    [self addChild:soundButtonNode];
}

-(void) createTrailerButton {
    SKSpriteNode *trailerButton = [SKSpriteNode spriteNodeWithImageNamed:@"trailer.png"];
    trailerButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    trailerButton.name = @"trailerButtonNode";//how the node is identified later
    trailerButton.zPosition = 1.0;
    trailerButton.xScale = 0.2;
    trailerButton.yScale = 0.2;
    
    [self addChild:trailerButton];
}

-(void) goToHome {
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
    
    InitialScreen *scene = [InitialScreen sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.view presentScene:scene transition:reveal];
}

-(void) updateSoundSettings{
    if (![[data isSoundOn] boolValue]){
        [soundButtonNode setTexture:[SKTexture textureWithImageNamed:@"sound.png"]];
        [data updateSoundOn:[NSNumber numberWithBool:YES]];
    } else {
        [soundButtonNode setTexture:[SKTexture textureWithImageNamed:@"mute.png"]];
        [data updateSoundOn:[NSNumber numberWithBool:NO]];
    }
}

-(void) goToTutorial {
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
    
    TutorialScene *scene = [TutorialScene sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.playScene = NO;
    
    [self.view presentScene:scene transition:reveal];
}

-(void) goToTrailer {
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
    
    trailerScene *scene = [trailerScene sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.play = YES;
    [self.view presentScene:scene transition:reveal];
}

-(void) playGame {
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
    
    GameScene *scene = [GameScene sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.view presentScene:scene transition:reveal];
}

-(void) createBackground {
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"woodBackground.png"];
    bgImage.size = CGSizeMake(self.frame.size.height/1.7, self.frame.size.width/1.7);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [self addChild:bgImage];
    
    
    SKLabelNode *generalStoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    generalStoreLabel.fontSize = 20;
    generalStoreLabel.fontColor = [SKColor blackColor];
    generalStoreLabel.position = CGPointMake((self.frame.size.width/2), (self.frame.size.height/2)+62);
    generalStoreLabel.text = @"Settings";
    generalStoreLabel.zPosition = 1;
    [self addChild:generalStoreLabel];
}
@end
