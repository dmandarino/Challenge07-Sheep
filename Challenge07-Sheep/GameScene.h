//
//  GameScene.h
//  Challenge07-Sheep
//

//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GameScene : SKScene <UIGestureRecognizerDelegate>
@property AVAudioPlayer *player;
@property int level;

@end
