//
//  Sheep.m
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/28/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import "Sheep.h"

@implementation Sheep{
}

-(void) setName: (NSString *)name {
    _name = name;
}

-(NSString *) getName{
    return _name;
}

-(void) setPrice: (float)priceReceived {
    _price = [NSNumber numberWithFloat:priceReceived];
}

-(float) getPrice {
    return [_price floatValue];
}

-(void) setActivated:(BOOL) activated {
    _activated = [NSNumber numberWithBool:activated];
}

-(BOOL) isActivated {
    return [_activated boolValue];
}

-(void) setImage:(NSString *)image{
    _image = image;
}

-(NSString *) getImage{
    return _image;
}

-(void) setImageLeft:(NSString *)imageLeft{
    _imageLelft = imageLeft;
}

-(NSString *) getImageLeft{
    return _imageLelft;
}
-(void) setImageRigh:(NSString *)imageRight{
    _imageRight = imageRight;
}

-(NSString *) getImageRight{
    return _imageRight;
}

-(void) setImageUP:(NSString *)imageUp{
    _imageUp = imageUp;
}

-(NSString *) getImageUp{
    return _imageUp;
}

- (id)init
{
    if ((self = [super init])) {
        self.name = @"Some default name";
        // initialize any other properties here
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        // decode any other properties here
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"Name"];
    // encode any other properties here
}
@end
