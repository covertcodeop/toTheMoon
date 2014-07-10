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
#import "RBL_BLE.h"
#import "RBL_BLE_Delegate.h"

@interface HelloScene : SKScene <RBL_BLE_Delegate>
@property BOOL contentCreated;

-(void) setBleRadio: (RBL_BLE *) value forDevice: (NSUUID *) identifier from:(UIViewController *) connectScreen;

@end
