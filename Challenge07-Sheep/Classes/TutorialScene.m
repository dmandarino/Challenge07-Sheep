//
//  TutorialScene.m
//  Challenge07-Sheep
//
//  Created by Felipe Argento on 1/27/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "TutorialScene.h"
#import "Tutorial2Scene.h"
#import "RWGameData.h"

SKSpriteNode *soundButtonNode;
RWGameData *data;
CGPoint pointLocation;

@implementation TutorialScene
- (void) didMoveToView:(SKView *)view{
    data = [[RWGameData alloc]init];
    
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial1.png"];
    bgImage.size = CGSizeMake(self.frame.size.height, self.frame.size.width/1.7);
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
    
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    pointLocation = [touch locationInView:touch.view];
    
//    SKNode *node = [self nodeAtPoint:location];
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint endPosition = [touch locationInView:touch.view];
    int deltaX = (endPosition.x - pointLocation.x);
    int deltaY = (endPosition.y - pointLocation.y);
    
    if( deltaY == 0){
        deltaY = 1;
    }
    int tang = deltaX/deltaY;
    
    if ( abs(tang) >= 1 ){
        if ( pointLocation.x < endPosition.x){
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
            
            Tutorial2Scene *scene = [Tutorial2Scene sceneWithSize:self.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            scene.playScene = _playScene;
            
            [self.view presentScene:scene transition:reveal];
        }
    }
}

-(void) createCountPage {
    SKLabelNode *highScoreTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScoreTitle.fontSize = 10;
    highScoreTitle.fontColor = [SKColor redColor];
    highScoreTitle.position = CGPointMake(CGRectGetMidX(self.frame)- 120, CGRectGetMidY(self.frame)-70);
    highScoreTitle.text = @"1/4";
    highScoreTitle.zPosition = 1;
    [self addChild:highScoreTitle];
}

@end
