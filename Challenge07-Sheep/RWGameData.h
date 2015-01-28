//
//  RWGameData.h
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/24/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sheep.h"

@interface RWGameData : NSObject <NSCoding, NSCopying>

@property (assign, nonatomic) float score;

@property (assign, nonatomic) float coins;

@property (assign, nonatomic) float highScore;

@property (assign, nonatomic) float topScore1;
@property (assign, nonatomic) float topScore2;
@property (assign, nonatomic) float topScore3;
@property (assign, nonatomic) float topScore4;
@property (assign, nonatomic) float topScore5;

@property (assign, nonatomic) NSString *sheep;
@property (assign, nonatomic) Boolean gotPirateSheep;
@property (assign, nonatomic) Boolean gotSecondSheep;
@property (assign, nonatomic) Boolean gotThirdSheep;
@property (assign, nonatomic) Boolean gotFourthSheep;
@property (assign, nonatomic) int used;



+(instancetype)sharedGameData;
-(void)reset;
-(void)save;

@end