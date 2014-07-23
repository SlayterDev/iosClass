//
//  Flock.m
//  BoidsMac
//
//  Created by iD Student on 7/23/14.
//  Copyright (c) 2014 iD Student. All rights reserved.
//

#import "Flock.h"

@implementation Flock

- (instancetype)init
{
    self = [super init];
    if (self) {
        _boids = [[NSMutableArray alloc] init];
        _scatter = 1;
    }
    return self;
}

CGPoint addPoint(CGPoint p1, CGPoint p2) { // add two points
    return CGPointMake(p1.x+p2.x, p1.y+p2.y);
}

CGPoint subPoint(CGPoint p1, CGPoint p2) { // subtract two points
    return CGPointMake(p1.x-p2.x, p1.y-p2.y);
}

CGPoint multPoint(CGPoint p1, CGPoint p2) { // multiply two points
    return CGPointMake(p1.x*p2.x, p1.y*p2.y);
}

CGPoint divPoint(CGPoint p1, CGPoint p2) { // divide two points
    return CGPointMake(p1.x/p2.x, p1.y/p2.y);
}

CGPoint multPointByFactor(CGPoint p1, CGFloat n) { // multiply a point by a number n
    return CGPointMake(p1.x*n, p1.y*n);
}

CGPoint divPointByFactor(CGPoint p1, CGFloat n) { // divide a point by a number n
    return CGPointMake(p1.x/n, p1.y/n);
}

CGPoint addPointByFactor(CGPoint p1, CGFloat n) { // add a factor n to a point
    return CGPointMake(p1.x+n, p1.y+n);
}

CGPoint absPoint(CGPoint p) { // absolute value of a point
    return CGPointMake(ABS(p.x), ABS(p.y));
}

-(void) setupFlock:(SKScene *)theScene {
    for (int i = 0; i < 15; i++) {
        Boid *b = [Boid spriteNodeWithImageNamed:@"Spaceship.png"];
        
        CGPoint pos;
        if (i < 5) {
            pos.x = CGRectGetMidX(theScene.frame) - 300;
            pos.y = i * 100 + 100;
            //b.velocity = CGPointMake(20, 0);
        } else if (i >= 5 < 10) {
            pos.x = CGRectGetMidX(theScene.frame) + 300;
            pos.y = (i-5) * 100 + 100;
            //b.velocity = CGPointMake(-20, 0);
        } else {
            pos.x = CGRectGetMidX(theScene.frame) - 600;
            pos.y = (i-10) * 100 + 100;
        }
        b.velocity = CGPointZero;
        b.position = pos;
        b.scale = 0.115;
        [theScene addChild:b];
        [_boids addObject:b];
    }
    
    _predator = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship.png"];
    _predator.scale = 0.15;
    _predator.position = CGPointMake(CGRectGetMidX(theScene.frame), CGRectGetMidY(theScene.frame));
    //[theScene addChild:_predator];
    _predator.color = [NSColor redColor];
}

-(void) moveAllBoidsToNewPositons {
    CGPoint v1, v2, v3, v4, v5;
    
    for (Boid *b in self.boids) {
        v1 = multPointByFactor([self rule1:b], self.scatter);
        v2 = [self rule2:b];
        v3 = [self rule3:b];
        v4 = [self boundPosition:b];
        v5 = multPointByFactor([self tendToPlace:b], -1);
        
        b.velocity = addPoint(b.velocity, v1); // add v's
        b.velocity = addPoint(b.velocity, v2);
        b.velocity = addPoint(b.velocity, v3);
        b.velocity = addPoint(b.velocity, v4);
        //b.velocity = addPoint(b.velocity, v5);
        
        //if ([_boids indexOfObject:b] == 0)
        //    NSLog(@"Vel: %f, %f", b.velocity.x, b.velocity.y);
        
        // roatation attempt
        CGPoint diff = subPoint(b.position, addPoint(b.position, b.velocity));
        float angle = atan2f(diff.y, diff.x);
        b.zRotation = angle - ((3*M_PI)/2);
        
        [self limitVelocity:b];
        
        b.position = addPoint(b.position, b.velocity);
    }
}

-(CGPoint) rule1:(Boid *)j { // move to center
    CGPoint pcj = CGPointZero; // perceived center of boid j
    
    for (Boid *b in _boids) {
        if (b != j) {
            pcj = addPoint(pcj, b.position);
        }
    }
    
    pcj = divPointByFactor(pcj, _boids.count - 1);
    
    return divPointByFactor(subPoint(pcj, j.position), 100);
}

-(CGPoint) rule2:(Boid *)j { // keep distance from others and objects
    CGPoint c = CGPointZero;
    
    for (Boid *b in _boids) {
        if (b != j) {
            if (absPoint(subPoint(b.position, j.position)).x < 65 && absPoint(subPoint(b.position, j.position)).y < 65) {
                c = subPoint(c, subPoint(b.position, j.position));
            }
        }
    }
    
    return c;
}

-(CGPoint) rule3:(Boid *)j { // match velocity of neighbors
    CGPoint pvj = CGPointZero; // perceived velocity of boid j
    
    for (Boid *b in _boids) {
        if (b != j) {
            pvj = addPoint(pvj, b.velocity);
        }
    }
    
    pvj = divPointByFactor(pvj, _boids.count-1);
    
    return divPointByFactor(subPoint(pvj, j.velocity), 8);
}

-(CGPoint) boundPosition:(Boid *)j {
    int Xmin = 0, Xmax = 1150, Ymin = 0, Ymax = 918;
    CGPoint v = CGPointZero;
    
    if (j.position.x < Xmin) {
        v.x = 100;
    } else if (j.position.x > Xmax) {
        v.x = -100;
    }
    
    if (j.position.y < Ymin) {
        v.y = 100;
    } else if (j.position.y > Ymax) {
        v.y = -100;
    }
    
    return v;
}

-(void) limitVelocity:(Boid *)j {
    int vLim = 2;
    
    if (absPoint(j.velocity).x > vLim || absPoint(j.velocity).y > vLim) {
        j.velocity = multPointByFactor(divPoint(j.velocity, absPoint(j.velocity)), vLim);
    }
}

-(CGPoint) tendToPlace:(Boid *)b {
    return divPointByFactor(subPoint(_predator.position, b.position), 100);
}

@end
