//
//  Sheep.h
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/28/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sheep : NSObject <NSCoding, NSCopying>
-(void) setName: (NSString *)nameReceived;

-(void) setPrice: (float)priceReceived;

-(NSString *) getName;

-(float) getPrice;

-(void) setOwned: (BOOL)param;

-(BOOL) isOwned;

//-(NSMutableData*) instanceToSave;

@end
