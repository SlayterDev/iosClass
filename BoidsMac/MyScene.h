//
//  MyScene.h
//  BoidsMac
//

//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Flock.h"

@interface MyScene : SKScene {
    Flock *flock;
    
    int keyTimer;
}

@end
