//
//  TutorialScene.m
//  Challenge07-Sheep
//
//  Created by Felipe Argento on 1/27/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "TutorialScene.h"
#import "InitialScreen.h"
#import "RWGameData.h"

SKSpriteNode *soundButtonNode;
RWGameData *data;

@implementation TutorialScene
- (void) didMoveToView:(SKView *)view{
    data = [[RWGameData alloc]init];
    
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"background1.png"];
    bgImage.size = CGSizeMake(self.frame.size.height/1.7, self.frame.size.width/1.7);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

    [self addChild:bgImage];
    
    SKSpriteNode *homeButtonNode = [self createHomeButton];
    [self addChild: homeButtonNode];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"homeButtonNode"]) {
        [self goToHome];
    }
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


-(void) goToHome {
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
    
    InitialScreen *scene = [InitialScreen sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.view presentScene:scene transition:reveal];
}

@end