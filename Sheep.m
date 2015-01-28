//
//  Sheep.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/28/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "Sheep.h"

@implementation Sheep{
    NSString *name;
    float price;
    NSString *nameRight;
    NSString *nameLeft;
    NSString *nameUp;
    BOOL owned;
}

-(void) setName: (NSString *)nameReceived {
    name = nameReceived;
}

-(void) setPrice: (float)priceReceived {
    price = priceReceived;
}

-(NSString *) getName{
    return name;
}

-(float) getPrice {
    return price;
}

-(void) setOwned: (BOOL)param {
    owned = param;
}

-(BOOL) isOwned {
    return owned;
}

//-(NSMutableData*) instace {
//    NSMutableData *data = [NSMutableData data];
//    NSKeyedArchiver *arc = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [arc encodeRootObject:self];
//    [arc finishEncoding];
////    [arc release];
//    return data;
//}
@end
