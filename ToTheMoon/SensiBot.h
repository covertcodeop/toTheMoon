//
//  SensiBot.h
//  bleBasics
//
//  Created by zenko on 10/13/13.
//  Copyright (c) 2013 Zen&Ko, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//SpaceShip Controller
//#define SPACE_SHIP_BOT            "25FD5F63-4EAB-292F-9AEC-3D6840FBD8A4" //Elizabeth's space ship
#define SPACE_SHIP_BOT            "D325D9C4-4835-805C-865D-2BE9DAACDC53" //Zenko's bot


@interface SensiBot : NSObject

//BLE Values on call
@property CBPeripheral *peripheral;
@property NSString *vendorName;
@property NSString *deviceLibVersion;
@property BOOL enableRSSI;
@property NSMutableDictionary *characteristics;

//SensiBot component properties
@property BOOL buttonStatus;
@property double temperature;
@property double lux;
@property double db;
@property double accelX;
@property double accelY;
@property double accelZ;

//General SensiBot methods
-(void) toggleRSSIupdates: (BOOL) enable;
-(void) toggleBackLight: (BOOL) enable;
-(void) buzzer: (int) frequency;
-(void) toggleLED: (BOOL) enable;
-(void) playSong;
-(void) flashLEDs;
-(void) convertResponse: (CBCharacteristic *) response;

-(void) toggleTemp: (BOOL) enable;
-(void) toggleLight: (BOOL) enable;
-(void) toggleSound: (BOOL) enable;
-(void) toggleAccelerometer: (BOOL) enable;

@end
