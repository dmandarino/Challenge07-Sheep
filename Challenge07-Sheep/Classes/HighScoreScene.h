//
//  HighScoreScene.h
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/23/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HighScoreScene : SKScene
@property AVAudioPlayer *player;
@property float score;
@property float coins;
@property NSMutableArray *ranking;

@end