//
//  BossScene.h
//  Challenge07-Sheep
//
//  Created by Rodrigo Dezouzart on 2/4/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HighScoreScene.h"
#import "RWGameData.h"

@interface BossScene : SKScene <SKPhysicsContactDelegate>

@property AVAudioPlayer *player;
@property SKSpriteNode *spriteParam;
@property float scoreParam;
@property float coinsParam;
@property float rankingParam;
@property int nHeartsParam;
@property int level;

@end
