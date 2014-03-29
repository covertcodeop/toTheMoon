//
//  RBL_BLE.h
//  bleBasics
//
//  Created by zenko on 10/12/13.
//  Copyright (c) 2013 Zen&Ko, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "RBL_BLE_Delegate.h"

@interface RBL_BLE : NSObject  <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic,assign) id <RBL_BLE_Delegate> list_delegate;
@property (nonatomic,assign) id <RBL_BLE_Delegate> detail_delegate;

@property (readonly) NSMutableDictionary *sensibots;


-(void) startup;
-(BOOL) findBLEPeripherals:(int) timeout;

//Utility methods
-(const char *) centralManagerStateToString:(int)state;
-(void) scanTimer:(NSTimer *)timer;

@end
