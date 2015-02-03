//
//  Store.m
//  Challenge07-Sheep
//
//  Created by Rodrigo Dezouzart on 1/27/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "Store.h"
#import "GameScene.h"
#import "RWGameData.h"
#import "InitialScreen.h"
#import "Sheep.h"

@implementation Store

RWGameData *data;

SKSpriteNode *bgImage;
SKLabelNode *generalStoreLabel;
SKLabelNode *sheepsOutfitLabel;
SKLabelNode *heartLabel;
SKLabelNode *coinsLabel;
SKSpriteNode *coinsImg;
SKLabelNode *coinsLabel2;
SKSpriteNode *coinsImg2;
SKSpriteNode *heartImg;
SKLabelNode *nHeart;

NSMutableArray *sheepArray;
NSMutableArray *storeSheep;

SKLabelNode *name;
SKLabelNode *price;
SKSpriteNode *outfitImg;
SKSpriteNode *coinsImg2;
NSString *sheepName;
float sheepPrice;

int used;

-(void) didMoveToView:(SKView *)view {
    
    [self loadValues];
    
    [self createBackground];
    
    [self playEffectBgSounds];
    
    SKSpriteNode *homeButtonNode = [self createHomeButton];
    [self addChild: homeButtonNode];
    
    SKSpriteNode *retryButtonNode = [self createRetryButton];
    [self addChild: retryButtonNode];
    
}

-(void) createBackground {
    
    bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"woodBackground.png"];
    bgImage.xScale = 0.1;
    bgImage.yScale = 0.1;
    bgImage.size = CGSizeMake(self.size.height, self.size.width);
    bgImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:bgImage];
    
    heartImg = [SKSpriteNode spriteNodeWithImageNamed:@"heart.png"];
    heartImg.xScale = 0.008;
    heartImg.yScale = 0.008;
    heartImg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-69);
    [self addChild:heartImg];
    
    coinsLabel= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    coinsLabel.fontSize = 12;
    coinsLabel.position = CGPointMake(CGRectGetMidX(self.frame)-108, CGRectGetMidY(self.frame)+65);
    coinsLabel.fontColor = [SKColor blackColor];
    coinsLabel.text = [NSString stringWithFormat:@"%.0f", [[data loadCoins] floatValue]];
    [self addChild:coinsLabel];
    
    coinsImg = [SKSpriteNode spriteNodeWithImageNamed:@"coins.png"];
    coinsImg.xScale = 0.05;
    coinsImg.yScale = 0.05;
    coinsImg.position = CGPointMake(CGRectGetMidX(self.frame)-135, CGRectGetMidY(self.frame)+72);
    [self addChild:coinsImg];
    
    coinsLabel2= [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    coinsLabel2.fontSize = 10;
    coinsLabel2.position = CGPointMake(CGRectGetMidX(self.frame)+35, CGRectGetMidY(self.frame)-76);
    coinsLabel2.fontColor = [SKColor whiteColor];
    coinsLabel2.text = [NSString stringWithFormat:@"1000"];
    [self addChild:coinsLabel2];
    
    coinsImg2 = [SKSpriteNode spriteNodeWithImageNamed:@"coins.png"];
    coinsImg2.xScale = 0.03;
    coinsImg2.yScale = 0.03;
    coinsImg2.position = CGPointMake(CGRectGetMidX(self.frame)+15, CGRectGetMidY(self.frame)-72);
    [self addChild:coinsImg2];
    
    generalStoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    generalStoreLabel.fontSize = 20;
    generalStoreLabel.fontColor = [SKColor whiteColor];
    generalStoreLabel.position = CGPointMake((self.frame.size.width/2), (self.frame.size.height/2)+62);
    generalStoreLabel.text = @"General Store";
    [self addChild:generalStoreLabel];
    
    sheepsOutfitLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    sheepsOutfitLabel.fontSize = 12;
    sheepsOutfitLabel.fontColor = [SKColor whiteColor];
    sheepsOutfitLabel.position = CGPointMake((self.frame.size.width/2), (self.frame.size.height/2)+42);
    sheepsOutfitLabel.text = @"Sheep's Outfit";
    [self addChild:sheepsOutfitLabel];
    
    heartLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    heartLabel.fontSize = 12;
    heartLabel.fontColor = [SKColor whiteColor];
    heartLabel.position = CGPointMake((self.frame.size.width/2), (self.frame.size.height/2)-56);
    heartLabel.text = @"Number of Hearts";
    [self addChild:heartLabel];
    
    nHeart = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    nHeart.fontSize = 8;
    nHeart.fontColor = [SKColor whiteColor];
    nHeart.position = CGPointMake(((self.frame.size.width/2)-10), (self.frame.size.height/2)-76);
    nHeart.text = @"2";
    [self addChild:nHeart];

    [self showSheeps];
}

- (void) showSheeps {
    for (int i=1; i<=4; i++) {
        
        name = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        name.fontSize = 10;
        name.fontColor = [SKColor whiteColor];
        name.position = CGPointMake(((self.frame.size.width/2)-190+i*75), (self.frame.size.height/2)+25);
        
        price = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        price.fontSize = 10;
        price.fontColor = [SKColor whiteColor];
        price.position = CGPointMake(((self.frame.size.width/2)-190+i*75), (self.frame.size.height/2)-37);
        price.text = [NSString stringWithFormat:@"%d", 200+i*100];
        
        
        coinsImg2 = [SKSpriteNode spriteNodeWithImageNamed:@"coins.png"];
        coinsImg2.xScale = 0.03;
        coinsImg2.yScale = 0.03;
        coinsImg2.position = CGPointMake(CGRectGetMidX(self.frame)-210+i*75, CGRectGetMidY(self.frame)-32);
        
        Sheep *mainSheep = [self getActivatedSheep];
        NSLog([NSString stringWithFormat:@"%@", [mainSheep getName]]);
        
        switch (i) {
            case 1:
                outfitImg = [SKSpriteNode spriteNodeWithImageNamed:@"viking.png"];
                outfitImg.name = @"vikingNode";
                name.text = @"viking";
                sheepName = @"viking";
                price.text = @"0";
                break;
            case 2:
                outfitImg = [SKSpriteNode spriteNodeWithImageNamed:@"pirate.png"];
                outfitImg.name = @"pirateNode";
                name.text = @"pirate";
                sheepName = @"pirate";
                if ([self isOwnedSheep])
                    price.text = @"0";
                break;
            case 3:
                outfitImg = [SKSpriteNode spriteNodeWithImageNamed:@"medieval.png"];
                outfitImg.name = @"medievalNode";
                name.text = @"medieval";
                sheepName = @"medieval";
                break;

            case 4:
                outfitImg = [SKSpriteNode spriteNodeWithImageNamed:@"king.png"];
                outfitImg.name = @"kingNode";
                name.text = @"king";
                sheepName = @"king";
                break;
        }
        
        Sheep *sheep = [[Sheep alloc] init];
        [sheep setName:sheepName];
        [sheep setPrice:[NSNumber numberWithFloat:price.text.floatValue]];
        [storeSheep addObject:sheep];
        
        outfitImg.xScale = 0.2;
        outfitImg.yScale = 0.2;
        outfitImg.position = CGPointMake(CGRectGetMidX(self.frame)-192+i*76, CGRectGetMidY(self.frame)-5);
        [self addChild:outfitImg];
        [self addChild:name];
        [self addChild:price];
        [self addChild:coinsImg2];
    }

}

-(SKSpriteNode *) createRetryButton {
    
    SKSpriteNode *retryButtonNode;

    retryButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"play2.png"];
    retryButtonNode.position = CGPointMake(CGRectGetMinX(self.frame)+40, CGRectGetMidY(self.frame)-69);
    retryButtonNode.name = @"retryButtonNode";//how the node is identified later
    retryButtonNode.zPosition = 1.0;
    retryButtonNode.xScale = 0.2;
    retryButtonNode.yScale = 0.2;
    
    return retryButtonNode;
}

-(void)playEffectBgSounds{
    
    //Play Sound
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"store"
                                         ofType:@"wav"]];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.numberOfLoops = -1;
    
    [_player play];
}

-(SKSpriteNode *) createHomeButton {
    SKSpriteNode *homeButtonNode = [SKSpriteNode spriteNodeWithImageNamed:@"home.png"];
    homeButtonNode.position = CGPointMake(CGRectGetMidX(self.frame)+120, CGRectGetMidY(self.frame)-68);
    homeButtonNode.name = @"homeButtonNode";//how the node is identified later
    homeButtonNode.zPosition = 1.0;
    homeButtonNode.xScale = 0.2;
    homeButtonNode.yScale = 0.2;
    
    return homeButtonNode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    Sheep *sheep = [[Sheep alloc] init];
    if ([node.name isEqualToString:@"homeButtonNode"]) {
        InitialScreen *scene = [InitialScreen sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1]];
        
    }else if([node.name isEqualToString:@"retryButtonNode"]){

        GameScene *scene = [GameScene sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1]];
        
    }else if([node.name isEqualToString:@"pirateNode"]){
        [self sheepButton:@"pirate"];
    }else if([node.name isEqualToString:@"vikingNode"]){
        [self sheepButton:@"viking"];
    }else if([node.name isEqualToString:@"medievalNode"]){
        [self sheepButton:@"medieval"];
    }else if([node.name isEqualToString:@"kingNode"]){
        [self sheepButton:@"king"];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([self isOwnedSheep]){
            [self changeSheep:sheepName];
        } else {
            Sheep *sheep = [[Sheep alloc] init];
            [sheep setName:sheepName];
            [sheep setPrice:[NSNumber numberWithFloat:sheepPrice]];
            [sheep setImage:[NSString stringWithFormat:@"%@.png", sheepName]];
            [sheep setImageLeft:[NSString stringWithFormat:@"%@Esq.png", sheepName]];
            [sheep setImageRight:[NSString stringWithFormat:@"%@Dir.png", sheepName]];
            [sheep setImageUp:[NSString stringWithFormat:@"%@Up.png", sheepName]];
            [self buySheep: sheep];
        }
    } else {
            
        
    }
}

-(void) buySheep: (Sheep *)sheep {
    [sheepArray addObject:sheep];
    [self changeSheep:sheepName];
}

-(void) changeSheep: (NSString *) name {
    for (Sheep *sheep in sheepArray){
        if([[sheep getName] isEqualToString:name])
            [sheep setMainSheep:[NSNumber numberWithBool:YES]];
        else
            [sheep setMainSheep:[NSNumber numberWithBool:NO]];
    }
    [data saveSheep:sheepArray];
}

-(Sheep *) getSheep: (NSString *) name {
    for (Sheep *sheep in sheepArray){
        if( [[sheep getName] isEqualToString:name])
            return sheep;
    }
    return nil;
}

-(BOOL) isOwnedSheep{
    for (Sheep *sheep in sheepArray){
        if( [[sheep getName] isEqualToString:sheepName])
            return true;
    }
    return false;
}

-(void) loadValues {
    data = [[RWGameData alloc] init];
    sheepArray = [[NSMutableArray array] init];
    
    if ([data loadSheeps] != nil)
        sheepArray = [data loadSheeps];

}

-(Sheep *) getActivatedSheep {
    for (Sheep *sheep in sheepArray){
        if ([sheep isMainSheep])
            return sheep;
    }
    return nil;
}

-(void) sheepButton:(NSString *) name {
    
    Sheep *sheep = [self getStoreSheep:name];
    
    sheepName = name;
    NSLog([NSString stringWithFormat:@"%@",name]);
    if ( [data loadCoins] > [sheep getPrice] ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to use this Sheep?" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You don't have enough coins" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil ,nil];
        [alert show];
        
    }
}

-(Sheep *) getStoreSheep: (NSString*) name {
    for (Sheep *sheep in storeSheep){
        if ([[sheep getName] isEqualToString:name])
            return sheep;
    }
    return nil;
}

@end
