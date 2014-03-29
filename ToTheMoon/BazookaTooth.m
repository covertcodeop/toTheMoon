//
//  BazookaTooth.m
//  bleBasics
//
//  Created by zenko on 9/28/13.
//  Copyright (c) 2013 Zen&Ko, LLC. All rights reserved.
//

#import "BazookaTooth.h"

@implementation BazookaTooth
{
    CBCentralManager *bleRadio;
    CBPeripheral *biscuit1;
    CBPeripheral *biscuit2;
    CBCharacteristic *read_pipe1;
    CBCharacteristic *read_pipe2;
    CBUUID *characteristic_identifier;
    NSData *theDatasLongTime;
}
static unsigned char vendor_str[20] = {0};

-(void) connectDevice
{
    NSLog(@"Connecting device...");
    bleRadio = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];

}
-(void) scanDevices
{
    NSLog(@"Scanning for Peripherals");
    [bleRadio scanForPeripheralsWithServices:nil options:nil];
}

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2
{
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}

-(void) write:(NSData *) theDatas
{
//    @BLE_DEVICE_TX_UUID
//    "713D0003-503E-4C75-BA94-3148F18D941E"
    characteristic_identifier = [CBUUID UUIDWithString:@"713D0003-503E-4C75-BA94-3148F18D941E"];
    NSLog(@"Alerting BLE to turn on Temp Sensor");
    theDatasLongTime = theDatas;
//    NSLog(@"The Datas: %i*%i*%i", theDatasLongTime, theDatasLongTime[1], theDatasLongTime[2]);
    
    if(biscuit1 != nil)
    {
        NSLog(@"Peripheral: %@*%@*", biscuit1, characteristic_identifier);
        [biscuit1 writeValue:theDatasLongTime forCharacteristic:read_pipe1 type:CBCharacteristicWriteWithoutResponse];
    }
    
    if(biscuit2 != nil)
    {
        NSLog(@"Peripheral: %@*%@*", biscuit2, characteristic_identifier);
        [biscuit2 writeValue:theDatasLongTime forCharacteristic:read_pipe2 type:CBCharacteristicWriteWithoutResponse];
    }
}

//required:
-(void)centralManagerDidUpdateState:(CBCentralManager *) central
{
    NSLog(@"Got here");
    NSLog(@"Current state: %li",[central state]);
}

//optional:
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect to a peripheral");
    peripheral.delegate = self;
    [peripheral readRSSI];
    [peripheral discoverServices:nil];
}
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral: (CBPeripheral *)peripheral error:(NSError *) error
{
    NSLog(@"Disconnected from a peripheral");
}
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:error
{
    NSLog(@"Failed to connect to a peripheral");
}
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Found something");
    NSLog(@"Name: %@",[peripheral name]);
    NSLog(@"Identifer [NSUUID]: %@", [[peripheral identifier] UUIDString]);
    NSLog(@"RSSI Value: %@", [RSSI stringValue]);
    
    if([[peripheral name] isEqualToString:@"Biscuit"])
    {
        if(biscuit1 == nil)
        {
            biscuit1 = peripheral;
            [bleRadio connectPeripheral: biscuit1 options:nil];
        }
        else if(biscuit2 == nil)
        {
            biscuit2 = peripheral;
            [bleRadio connectPeripheral: biscuit2 options:nil];

        }
    }
}

//CBPeripheral Delegate methods
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for(CBService *service in peripheral.services)
    {
        //NSString *str = [[NSString alloc] initWithFormat:@"%@",  CFUUIDCreateString(nil, CFBridgingRetain(service.UUID)) ];
        //NSLog(@"Discovered service UUID 1: %@", str);
        NSLog(@"Discovered service UUID 2: %s",[[service.UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
        [peripheral discoverCharacteristics:nil forService: service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    CBCharacteristic *vendor_char;
    for(CBCharacteristic *characteristic in service.characteristics)
    {
        
        NSLog(@"Discovered Characteristic: %s", [[characteristic.UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
        CBUUID *vendor_name = [CBUUID UUIDWithString:@"713D0001-503E-4C75-BA94-3148F18D941E"];
        CBUUID *read_service = [CBUUID UUIDWithString:@"713D0003-503E-4C75-BA94-3148F18D941E"];
        CBUUID *write_service = [CBUUID UUIDWithString:@"713D0002-503E-4C75-BA94-3148F18D941E"];

        //@BLE_DEVICE_TX_UUID
        
        // will have to determine if isEqual compares the underlying byte data..., might be easier than compareCBUUID
        if([self compareCBUUID:characteristic.UUID UUID2:vendor_name])
        {
            vendor_char = characteristic;
            NSLog(@"********Compared CBUUIDs successfully");
        }
        else if([self compareCBUUID:characteristic.UUID UUID2:read_service])
        {
            NSLog(@"Squirreled away the characteristic");
            //[p setNotifyValue:on forCharacteristic:characteristic];
            if([self UUIDSAreEqual:peripheral.UUID u2:biscuit1.UUID])
            {
                read_pipe1 = characteristic;
            }
            if([self UUIDSAreEqual:peripheral.UUID u2:biscuit2.UUID])
            {
                read_pipe2 = characteristic;
            }
        }
        else if([self compareCBUUID:characteristic.UUID UUID2:write_service])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        NSLog(@"Value: %@", characteristic.value);
        NSLog(@"Property: %li", characteristic.properties);
        NSLog(@"\n");
    }
    [peripheral readValueForCharacteristic:vendor_char];
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"RSSI of %@ is %i", peripheral.name, peripheral.RSSI.intValue);
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Got here: didUpdateValueForCharacteristics");
    CBUUID *vendor_name = [CBUUID UUIDWithString:@"713D0001-503E-4C75-BA94-3148F18D941E"];
    //@BLE_DEVICE_RX_UUID
    //"713D0002-503E-4C75-BA94-3148F18D941E"

    CBUUID *read_service = [CBUUID UUIDWithString:@"713D0002-503E-4C75-BA94-3148F18D941E"];
    CBUUID *write_service = [CBUUID UUIDWithString:@"713D0002-503E-4C75-BA94-3148F18D941E"];

    // will have to determine if isEqual compares the underlying byte data..., might be easier than compareCBUUID
    if([self compareCBUUID:characteristic.UUID UUID2:vendor_name])
    {
        NSLog(@"%@", peripheral.UUID);
        NSLog(@"**RETURN**Compared CBUUIDs successfully");
        int data_len = characteristic.value.length;
        NSLog(@"Length of the Datas: %i", data_len);
        [characteristic.value getBytes:vendor_str length:data_len];
        NSLog(@"%@", [NSString stringWithFormat:@"%s", vendor_str]);
    }
    else if([self compareCBUUID:characteristic.UUID UUID2:read_service])
    {
        NSLog(@"%@", peripheral.UUID);
        NSLog(@"Temp Returning");
        int data_len = characteristic.value.length;
        NSLog(@"Data length %i", data_len);
        
        static unsigned char buffer[512];
        [characteristic.value getBytes:buffer length:characteristic.value.length];
        
        [[self delegate] bleDidReceiveData:buffer length:characteristic.value.length];
    }
    
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Am I over here?");
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Is this getting tapped at all?");
}
- (int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2
{
    CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
    CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
    
    if (memcmp(&b1, &b2, 16) == 0) {
        return 1;
    }
    else
        return 0;
}
@end
