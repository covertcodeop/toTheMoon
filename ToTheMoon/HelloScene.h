//
//  HelloScene.h
//  ToTheMoon
//
//  Created by Zenko Klapko on 3/29/14.
//  Copyright (c) 2014 Zenko Klapko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ConnectViewController.h"
#import "RFduino.h"
#import "RFduinoManager.h"

static const int spaceShipCategory = 1;
static const int meteoriteCategory = 2;

@interface HelloScene : SKScene <RFduinoManagerDelegate, RFduinoDelegate, SKPhysicsContactDelegate>
@property BOOL contentCreated;

-(void) setBleRadio: (RFduinoManager *) value withController: (RFduino *) rfduino from:(UIViewController *) connectScreen;

@end
