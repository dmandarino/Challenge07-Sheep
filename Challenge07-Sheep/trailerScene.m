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

@implementation trailerScene

SKLabelNode *tapSkip;
SKVideoNode *video;

- (void) didMoveToView:(SKView *)view{
    tapSkip= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    tapSkip.fontSize = 12;
    tapSkip.fontColor = [SKColor whiteColor];
    tapSkip.position = CGPointMake((self.frame.size.width/2 + 80), (self.frame.size.height/2 + 75));
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
    

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKTransition *reveal = [SKTransition fadeWithDuration:3];
    [video pause];
    [self removeAllChildren];
    
    InitialScreen *scene = [InitialScreen sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene transition:reveal];
    
}
@end
