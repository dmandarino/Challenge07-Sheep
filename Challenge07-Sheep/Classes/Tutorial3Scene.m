//
//  Tutorial3Scene.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 2/9/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "Tutorial3Scene.h"
#import "RWGameData.h"
#import "Tutorial4Scene.h"

SKSpriteNode *soundButtonNode;
RWGameData *data;
CGPoint pointLocation;
SKTexture *cardHeart;
SKSpriteNode *card;

@implementation Tutorial3Scene
- (void) didMoveToView:(SKView *)view{
    data = [[RWGameData alloc]init];
    
    [self createHeartCard];
    
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial3.png"];
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
    if ([node.name isEqualToString:@"cardNode"]) {
        [self nextPage];
    }
}

-(void) nextPage {
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1];
    
    Tutorial4Scene *scene = [Tutorial4Scene sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.playScene = _playScene;
    
    [self.view presentScene:scene transition:reveal];
}

-(void) createCountPage {
    SKLabelNode *highScoreTitle = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    highScoreTitle.fontSize = 10;
    highScoreTitle.fontColor = [SKColor redColor];
    highScoreTitle.position = CGPointMake(CGRectGetMidX(self.frame)- 120, CGRectGetMidY(self.frame)-70);
    highScoreTitle.text = @"3/4";
    highScoreTitle.zPosition = 1;
    [self addChild:highScoreTitle];
}

-(void) createHeartCard {
    cardHeart = [SKTexture textureWithImageNamed:@"cardHeart.png"];
    card = [SKSpriteNode spriteNodeWithTexture:cardHeart];
    card.name = @"cardNode";
    card.xScale = 0.07;
    card.yScale = 0.07;
    card.zPosition = 3;
    card.position = CGPointMake(CGRectGetMidX(self.frame) - 90, CGRectGetMidY(self.frame)+60);
    
    [self addChild: card];
}

@end