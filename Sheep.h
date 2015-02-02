//
//  Sheep.h
//  Challenge07-Sheep
//
//  Created by Douglas Mandarino on 1/28/15.
//  Copyright (c) 2015 Douglas Mandarino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sheep : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSNumber* price;
@property (nonatomic, copy) NSNumber *activated;

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *imageLelft;
@property (nonatomic, copy) NSString *imageRight;
@property (nonatomic, copy) NSString *imageUp;

-(void) setName: (NSString *)name;

-(NSString *) getName;

-(void) setPrice: (float)priceReceived;

-(float) getPrice;

-(void) setActivated:(BOOL) activated;

-(BOOL) isActivated;

-(void) setImage:(NSString *)image;

-(NSString *) getImage;

-(void) setImageLeft:(NSString *)imageLeft;

-(NSString *) getImageLeft;

-(void) setImageRigh:(NSString *)imageRight;

-(NSString *) getImageRight;

-(void) setImageUP:(NSString *)imageUp;

-(NSString *) getImageUp;


@end
