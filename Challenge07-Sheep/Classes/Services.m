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

@end
