//
//  RWGameData.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/24/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "RWGameData.h"

@implementation RWGameData

static NSString* const RankingKey = @"highScore";
static NSString* const CoinsKey = @"coins";


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
        array = [[NSMutableArray alloc] initWithCapacity:20];
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


-(BOOL) archiveExists: (NSString *) path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

@end
