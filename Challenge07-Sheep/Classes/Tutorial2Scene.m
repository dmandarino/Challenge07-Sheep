//
//  Tutorial2Scene.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 2/9/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "Tutorial2Scene.h"
#import "Tutorial3Scene.h"
#import "RWGameData.h"
#import "InitialScreen.h"

SKSpriteNode *soundButtonNode;
RWGameData *data;
CGPoint pointLocation;

@implementation Tutorial2Scene
- (void) didMoveToView:(SKView *)view{
    data = [[RWGameData alloc]init];
    
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial2.png"];
    bgImage.size = CGSizeMake(self.frame.size.height, self.frame.size.width/1.5);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [self addChild:bgImage];
    
    [self createCountPage];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    pointLocation = [touch locationInView:touch.view];
    
    //    SKNode *node = [self nodeAtPoint:location];
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint endPosition = [touch locationInView:touch.view];
    int deltaY = (endPosition.y - pointLocation.y);
    
    if( deltaY == 0){
        deltaY = 1;
    }

    if (pointLocation.y > endPosition.y){
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
        
        Tutorial3Scene *scene = [Tutorial3Scene sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        scene.playScene = _playScene;
        
        [self.view presentScene:scene transition:reveal];
    }
    
}

-(void) createCountPage {
    SKLabelNode *highScoreTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScoreTitle.fontSize = 10;
    highScoreTitle.fontColor = [SKColor redColor];
    highScoreTitle.position = CGPointMake(CGRectGetMidX(self.frame)+ 120, CGRectGetMidY(self.frame)-70);
    highScoreTitle.text = @"2/4";
    highScoreTitle.zPosition = 1;
    [self addChild:highScoreTitle];
}

@end
