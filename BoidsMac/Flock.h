//
//  Flock.h
//  BoidsMac
//
//  Created by iD Student on 7/23/14.
//  Copyright (c) 2014 iD Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Boid.h"

@interface Flock : NSObject

@property (nonatomic, assign) int scatter;
@property (nonatomic, strong) NSMutableArray *boids;
@property (nonatomic, strong) SKSpriteNode *predator;

-(void) moveAllBoidsToNewPositons;
-(void) setupFlock:(SKScene *)theScene;

@end
