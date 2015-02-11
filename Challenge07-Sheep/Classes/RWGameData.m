//
//  RWGameData.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/24/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "RWGameData.h"
#import "Sheep.h"

@implementation RWGameData

static NSString* const RankingKey = @"highScore";
static NSString* const CoinsKey = @"coins";
static NSString* const SheepSkinKey = @"sheepList";
static NSString* const FirstPlayingKey = @"FirstPlaying";
static NSString* const SoundKey = @"Sound";
static NSString* const HeartNumKey = @"HeartNum";


// Gets the path to the app's Documents folder
- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

// Gets the path to the data file
- (NSString *)dataFilePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"sheep.plist"];
}

// Loads the array from the file or creates a new array if no file present
- (NSMutableArray *)loadRanking {
    NSMutableArray *array;
    NSString *path = [self dataFilePath];
    if ( [self archiveExists:path] ) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        array = [unarchiver decodeObjectForKey:RankingKey];
        [unarchiver finishDecoding];
    } else {
        array = [[NSMutableArray alloc] init];
        [array addObject:[NSNumber numberWithFloat:0]];
    }
    return array;
}

// Saves the array to a file
- (void)saveRanking:(NSMutableArray *)array {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:array forKey:RankingKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

// Gets the path to the data file
- (NSString *)dataFilePathForCoins {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"coins.plist"];
}


- (NSNumber *)loadCoins {
    NSNumber *coins;
    NSString *path = [self dataFilePathForCoins];
    if ( [self archiveExists:path] ) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        coins = [unarchiver decodeObjectForKey:CoinsKey];
        [unarchiver finishDecoding];
    } else {
        coins = [NSNumber numberWithFloat:0];
    }
    return coins;
}

// Saves the array to a file
- (void)saveCoins:(NSNumber *)coins {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:coins forKey:CoinsKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePathForCoins] atomically:YES];
}

// Gets the path to the data file
- (NSString *)dataFilePathForSheep {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"sheepList.plist"];
}


- (NSMutableArray *)loadSheeps {
    NSMutableArray *array;
    NSString *path = [self dataFilePathForSheep];
    if ( [self archiveExists:path] ) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        array = [unarchiver decodeObjectForKey:SheepSkinKey];
        [unarchiver finishDecoding];
    } else {
        Sheep *sheep = [self createDefaultSheep];
        [array addObject:sheep];
        [self saveSheep:array];
    }
    return array;
}

// Saves the array to a file
- (void)saveSheep:(NSMutableArray *)array {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:array forKey:SheepSkinKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePathForSheep] atomically:YES];
}

// Gets the path to the data file
- (NSString *)dataFilePathForSettings {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"settings.plist"];
}

- (NSNumber *)firstPlaying {
    NSString *path = [self dataFilePathForSettings];
    if ( [self archiveExists:path] ) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _firstPlaying = [unarchiver decodeObjectForKey:FirstPlayingKey];
        [unarchiver finishDecoding];
    } else {
        _firstPlaying = [NSNumber numberWithFloat:1];
    }
    return _firstPlaying;
}

// Saves the array to a file
- (void)updateFirstPlaying:(NSNumber *)firstPlaying {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:firstPlaying forKey:FirstPlayingKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePathForSettings] atomically:YES];
}

// Gets the path to the data file
- (NSString *)dataFilePathForSound {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"sound.plist"];
}

- (NSNumber *)isSoundOn {
    NSString *path = [self dataFilePathForSound];
    if ( [self archiveExists:path] ) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _soundOn = [unarchiver decodeObjectForKey:SoundKey];
        [unarchiver finishDecoding];
        if ([[self firstPlaying]boolValue])
            _soundOn = [NSNumber numberWithFloat:1];
    } else {
        _soundOn = [NSNumber numberWithFloat:1];
    }
    return _soundOn;
}

// Saves the array to a file
- (void)updateSoundOn:(NSNumber *)sound {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:sound forKey:SoundKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePathForSound] atomically:YES];
}

// Gets the path to the data file
- (NSString *)dataFilePathForInventory {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"heart.plist"];
}

- (NSNumber *)heartNumber {
    NSString *path = [self dataFilePathForInventory];
    if ( [self archiveExists:path] ) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _heartNum = [unarchiver decodeObjectForKey:HeartNumKey];
        [unarchiver finishDecoding];
    } else {
        _heartNum = [NSNumber numberWithInt:2];
        [self updateHeartNumber:_heartNum];
    }
    [self updateHeartNumber:_heartNum];
    return _heartNum;
}

// Saves the array to a file
- (void)updateHeartNumber:(NSNumber *)heart {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:heart forKey:HeartNumKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePathForInventory] atomically:YES];
}

-(BOOL) archiveExists: (NSString *) path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

-(Sheep*) createDefaultSheep {
    Sheep *sheep = [[Sheep alloc] init];
    [sheep setName:@"viking"];
    [sheep setPrice:[NSNumber numberWithFloat:0]];
    [sheep setMainSheep:[NSNumber numberWithBool:YES]];
    [sheep setImage:@"viking.png"];
    [sheep setImageLeft:@"vikingEsq.png"];
    [sheep setImageRigh:@"vikingDir.png"];
    [sheep setImageUP:@"vikingUp.png"];
    return sheep;
}

@end
