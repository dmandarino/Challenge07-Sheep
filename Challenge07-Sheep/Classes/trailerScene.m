//
//  trailerScene.m
//  Challenge07-Sheep
//
//  Created by Felipe Argento on 1/28/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "trailerScene.h"
#import <AVFoundation/AVFoundation.h>
#import "InitialScreen.h"
#import "RWGameData.h"

@implementation trailerScene

SKLabelNode *tapSkip;
SKVideoNode *video;

- (void) didMoveToView:(SKView *)view{
    RWGameData *data = [[RWGameData alloc] init];
    
    [data updateFirstPlaying:[NSNumber numberWithBool:TRUE]]; 
    [[data firstPlaying] boolValue] || _play ? [self showTrailer] : [self skip:NO];
}
-(void) skip:(BOOL) fade{
    SKTransition *reveal;
    if(fade){
        reveal = [SKTransition fadeWithDuration:3];
        [video setPaused:true];
        [self removeAllChildren];
    } else {
        reveal = [[SKTransition alloc] init];
    }
    
    InitialScreen *scene = [InitialScreen sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition:reveal];
    
}

-(void) showTrailer {
    tapSkip= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    tapSkip.fontSize = 8;
    tapSkip.fontColor = [SKColor whiteColor];
    tapSkip.position = CGPointMake((self.frame.size.width/2 + 130), (self.frame.size.height/2 + 82));
    tapSkip.text = @"tap to skip";
    tapSkip.zPosition = 1;
    [self addChild:tapSkip];
    
    video = [SKVideoNode videoNodeWithVideoFileNamed:@"introMovie2.mov"];
    video.position = CGPointMake(CGRectGetMidX(self.frame),
                                 CGRectGetMidY(self.frame));
    video.xScale = 0.52;
    video.yScale = 0.39;
    
    [self addChild: video];
    [video play];
    
    SKAction *attackLaunch= [SKAction sequence:@[
                                                 //time after you want to fire a function
                                                 [SKAction waitForDuration:12],
                                                 [SKAction performSelector:@selector(skip:)
                                                                  onTarget:self]
                                                 
                                                 ]];
    [self runAction:[SKAction repeatAction:attackLaunch count: 1]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self skip: YES];
}
@end
