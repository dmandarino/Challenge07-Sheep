//
//  Services.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 2/19/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "Services.h"
#import "RWGameData.h"

RWGameData *data;

@implementation Services

-(AVAudioPlayer *)playEffectBgSounds:(NSString*)sound{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                        pathForResource:sound
                                        ofType:@"mp3"]];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.numberOfLoops = -1;
    
    return _player;
}

-(SKSpriteNode *) createButton:(NSString*) imageName:(NSString*) nodeName:(float) xPosition:(float) yPosition:(float) width:(float) height{
    SKSpriteNode *button = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    button.position = CGPointMake(xPosition, yPosition);
    button.name = nodeName;//how the node is identified later
    button.zPosition = 1.0;
    button.size = CGSizeMake(width, height);
    
    return button;
}

-(SKSpriteNode *) createImage:(NSString*) imageName : (float) xPosition : (float) yPosition : (float) zPosition : (float) width : (float) height{
    SKSpriteNode *img = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    img.position = CGPointMake(xPosition, yPosition);
    img.zPosition = zPosition;
    img.size = CGSizeMake(width, height);
    
    return img;
}

-(SKLabelNode *) createLabel: (NSString*) text : (NSString*)fontFamily : (int) fontSize : (SKColor*) color : (float) width : (float) height {
    SKLabelNode  *label= [SKLabelNode labelNodeWithFontNamed:fontFamily];
    label.fontSize = fontSize;
    label.fontColor = color;
    label.position = CGPointMake( width, height );
    label.text = text;
    label.zPosition = 1;
    
    return label;
}

@end
