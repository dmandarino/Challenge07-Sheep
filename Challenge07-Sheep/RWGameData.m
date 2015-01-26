//
//  RWGameData.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/24/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "RWGameData.h"

@implementation RWGameData

static NSString* const SSGameDataHighScoreKey = @"highScore";
static NSString* const SSGameDataRankingKey = @"ranking";
static NSString* const SSGameDataCoinsKey = @"coins";
static NSString* const SSGameDataTopScore1Key = @"topScore1";
static NSString* const SSGameDataTopScore2Key = @"topScore2";
static NSString* const SSGameDataTopScore3Key = @"topScore3";
static NSString* const SSGameDataTopScore4Key = @"topScore4";
static NSString* const SSGameDataTopScore5Key = @"topScore5";

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.highScore forKey: SSGameDataHighScoreKey];
    [encoder encodeDouble:self.coins     forKey: SSGameDataCoinsKey];
    [encoder encodeDouble:self.topScore1 forKey: SSGameDataTopScore1Key];
    [encoder encodeDouble:self.topScore2 forKey: SSGameDataTopScore2Key];
    [encoder encodeDouble:self.topScore3 forKey: SSGameDataTopScore3Key];
    [encoder encodeDouble:self.topScore4 forKey: SSGameDataTopScore4Key];
    [encoder encodeDouble:self.topScore5 forKey: SSGameDataTopScore5Key];
}

+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        sharedInstance = [[self alloc] init];
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

-(void)reset
{
    self.score = 0;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        _highScore = [decoder decodeDoubleForKey: SSGameDataHighScoreKey];
        _topScore1 = [decoder decodeDoubleForKey: SSGameDataTopScore1Key];
        _topScore2 = [decoder decodeDoubleForKey: SSGameDataTopScore2Key];
        _topScore3 = [decoder decodeDoubleForKey: SSGameDataTopScore3Key];
        _topScore4 = [decoder decodeDoubleForKey: SSGameDataTopScore4Key];
        _topScore5 = [decoder decodeDoubleForKey: SSGameDataTopScore5Key];
        _coins     = [decoder decodeDoubleForKey: SSGameDataCoinsKey];
    }
    return self;
}

+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}

+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [RWGameData filePath]];
    if (decodedData) {
        RWGameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[RWGameData alloc] init];
}

-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[RWGameData filePath] atomically:YES];
}

@end
