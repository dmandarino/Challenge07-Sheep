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

-(void) setPrice: (NSNumber *)priceReceived {
    _price = priceReceived;
}
-(NSNumber *) getPrice {
    return _price;
}

-(void) setMainSheep:(NSNumber *) activated {
    _activated = activated;
}
-(NSNumber *) isMainSheep {
    return _activated;
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
        self.name = @"viking";
        // initialize any other properties here
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.price = [aDecoder decodeObjectForKey:@"Price"];
        self.activated = [aDecoder decodeObjectForKey:@"Activated"];
        self.image = [aDecoder decodeObjectForKey:@"Image"];
        self.imageLelft = [aDecoder decodeObjectForKey:@"ImageLeft"];
        self.imageRight = [aDecoder decodeObjectForKey:@"ImageRight"];
        self.imageUp = [aDecoder decodeObjectForKey:@"ImageUp"];
        // decode any other properties here
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.price forKey:@"Price"];
    [aCoder encodeObject:self.activated forKey:@"Activated"];
    [aCoder encodeObject:self.image forKey:@"Image"];
    [aCoder encodeObject:self.imageLelft forKey:@"ImageLeft"];
    [aCoder encodeObject:self.imageRight forKey:@"ImageRight"];
    [aCoder encodeObject:self.imageUp forKey:@"ImageUp"];
    
    // encode any other properties here
}
@end
