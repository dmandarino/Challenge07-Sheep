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

@property (nonatomic, copy) NSNumber *coins;
@property (nonatomic, copy) NSMutableArray *sheeps;
@property (nonatomic, copy) NSMutableArray *scores;
@property (nonatomic, copy) NSNumber *firstPlaying;


- (NSMutableArray *)loadRanking;
- (void)saveRanking:(NSMutableArray *)array;
- (NSNumber *)loadCoins;
- (void)saveCoins:(NSNumber *)coins;
- (NSMutableArray *)loadSheeps;
- (void)saveSheep:(NSMutableArray *)sheeps;
- (NSNumber *)firstPlaying;
- (void)updateFirstPlaying:(NSNumber *)firstPlaying;
@end