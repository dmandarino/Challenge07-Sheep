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
float screenWidth;
float screenHeight;

@implementation SettingsScene

- (void) didMoveToView:(SKView *)view{
    data = [[RWGameData alloc]init];
    screenWidth = self.frame.size.width;
    screenHeight = self.frame.size.height;
    
    [self createBackground];
    
    [self createButtons];
    
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

-(void)createButtons {
    SKSpriteNode *homeButtonNode = [services createButton:@"home.png" :@"homeButtonNode" :CGRectGetMidX(self.frame) + 120 :CGRectGetMidY(self.frame) - 60 : screenWidth / 9 : screenHeight / 18];
    [self addChild:homeButtonNode];
    
    SKSpriteNode *playButton = [services createButton:@"play2.png" :@"playButtonNode" :CGRectGetMidX(self.frame) - 120 :CGRectGetMidY(self.frame) - 60 : screenWidth / 9 : screenHeight / 18];
    [self addChild:playButton];
    
    SKSpriteNode *tutorialButton = [services createButton:@"tutorialButton.png" :@"tutorialButtonNode" :CGRectGetMidX(self.frame) + 60 :CGRectGetMidY(self.frame) : screenWidth / 7 : screenHeight / 14];
    [self addChild:tutorialButton];
    
    SKSpriteNode *trailerButton = [services createButton:@"trailer.png" :@"trailerButtonNode" :CGRectGetMidX(self.frame) : CGRectGetMidY(self.frame) : screenWidth / 7 : screenHeight / 14];
    [self addChild:trailerButton];
    
    [self createMuteButton];
}

-(void) createMuteButton {
    soundButtonNode = [services createButton:@"sound.png" :@"muteButtonNode" :(CGRectGetMidX(self.frame) - 60) : CGRectGetMidY(self.frame) : (screenWidth/7): (screenHeight/14)];
    
    if (![[data isSoundOn] boolValue])
        [soundButtonNode setTexture:[SKTexture textureWithImageNamed:@"mute.png"]];
    
    [self addChild:soundButtonNode];
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
    bgImage.size = CGSizeMake(self.frame.size.height, self.frame.size.width);
    bgImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
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
