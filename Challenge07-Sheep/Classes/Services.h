//
//  Services.h
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 2/19/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Services : NSObject

@property AVAudioPlayer *player;

-(AVAudioPlayer*)playEffectBgSounds:(NSString*)sound;
-(SKSpriteNode *) createButton:(NSString*) imageName:(NSString*) nodeName:(float) xPosition:(float) yPosition:(float) width:(float) height;
-(SKSpriteNode *) createImage:(NSString*) imageName : (float) xPosition : (float) yPosition : (float) zPosition : (float) width : (float) height;
-(SKLabelNode *) createLabel: (NSString*) text : (NSString*)fontFamily : (int) fontSize : (SKColor*) color : (float) width : (float) height;

@end
