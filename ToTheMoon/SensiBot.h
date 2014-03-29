//
//  SensiBot.h
//  bleBasics
//
//  Created by zenko on 10/13/13.
//  Copyright (c) 2013 Zen&Ko, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

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
