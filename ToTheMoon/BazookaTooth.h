//
//  BazookaTooth.h
//  bleBasics
//
//  Created by zenko on 9/28/13.
//  Copyright (c) 2013 Zen&Ko, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BazookaToothDelegate
@optional
-(void) bleDidReceiveData:(unsigned char *) data length:(int) length;
@required
@end

@interface BazookaTooth : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
}

@property (nonatomic,assign) id <BazookaToothDelegate> delegate;

-(void) connectDevice;
-(void) scanDevices;

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2;
-(int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2;
-(void) write:(NSData *) theDatas;

@end
