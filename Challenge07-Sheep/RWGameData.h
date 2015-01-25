//
//  RWGameData.h
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/24/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWGameData : NSObject <NSCoding>

@property (assign, nonatomic) float score;

@property (assign, nonatomic) float highScore;

@property (assign, nonatomic) NSMutableArray *ranking;

+(instancetype)sharedGameData;
-(void)reset;
-(void)save;

@end