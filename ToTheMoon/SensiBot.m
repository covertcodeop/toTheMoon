//
//  SensiBot.m
//  bleBasics
//
//  Created by zenko on 10/13/13.
//  Copyright (c) 2013 Zen&Ko, LLC. All rights reserved.
//

#import "SensiBot.h"
#import "RBL_BLE_Defines.h"

@implementation SensiBot
{
    
}

@synthesize peripheral, vendorName, deviceLibVersion, enableRSSI, characteristics;


//General SensiBot methods
-(void) toggleRSSIupdates: (BOOL) enable
{
    enableRSSI = enable;
    if(enableRSSI)
        [peripheral readRSSI];
}
-(void) toggleBackLight: (BOOL) enable
{
    UInt8 buf[3] = {0x01, 0x00, 0x00};
    
    if (enable)
        buf[1] = 0x01;
    else
        buf[1] = 0x00;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    CBUUID *temp = [CBUUID UUIDWithString:@TX_TO_BLE_DEVICE_UUID];
    [peripheral writeValue:data forCharacteristic:[characteristics objectForKey:temp] type:CBCharacteristicWriteWithoutResponse];
}
-(void) buzzer: (float) frequency
{
    UInt8 buf[3] = {0x02, 0x00, 0x00};
    
    //buf[2] = frequency;
    NSLog(@"Frequency: %f", frequency);
    buf[1] = frequency;
    buf[2] = (int)frequency >> 8;
    //NSLog(@"Dimness: %f", dimness);

    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    CBUUID *temp = [CBUUID UUIDWithString:@TX_TO_BLE_DEVICE_UUID];
    [peripheral writeValue:data forCharacteristic:[characteristics objectForKey:temp] type:CBCharacteristicWriteWithoutResponse];
}
-(void) toggleLED: (BOOL) enable
{
    UInt8 buf[3] = {0x03, 0x00, 0x00};
    
    if(enable)
        buf[1] = 0x01;
    else
        buf[1] = 0x00;
    
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    CBUUID *temp = [CBUUID UUIDWithString:@TX_TO_BLE_DEVICE_UUID];
    [peripheral writeValue:data forCharacteristic:[characteristics objectForKey:temp] type:CBCharacteristicWriteWithoutResponse];
}
-(void) playSong
{
    UInt8 buf[3] = {0x05, 0x00, 0x00};
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    CBUUID *temp = [CBUUID UUIDWithString:@TX_TO_BLE_DEVICE_UUID];
    [peripheral writeValue:data forCharacteristic:[characteristics objectForKey:temp] type:CBCharacteristicWriteWithoutResponse];
}
-(void) flashLEDs
{
    UInt8 buf[3] = {0x06, 0x01, 0x00};
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    CBUUID *temp = [CBUUID UUIDWithString:@TX_TO_BLE_DEVICE_UUID];
    [peripheral writeValue:data forCharacteristic:[characteristics objectForKey:temp] type:CBCharacteristicWriteWithoutResponse];
}
-(void) convertResponse: (CBCharacteristic *) response
{
    int data_len;
    //turn CBUUIDs into statics....
    if ([response.UUID isEqual:[CBUUID UUIDWithString:@BLE_DEVICE_VENDOR_NAME_UUID]])
    {
        data_len = response.value.length;
        NSLog(@"Length of the Vendor name: %i", data_len);
        vendorName = [[NSString alloc] initWithData:response.value encoding:NSUTF8StringEncoding];
    }
    else if ([response.UUID isEqual:[CBUUID UUIDWithString:@BLE_DEVICE_LIB_VERSION_UUID]])
    {
        data_len = response.value.length;
        NSLog(@"Length of the Lib version: %i", data_len);
        ushort libver;
        [response.value getBytes:&libver length:2];
        deviceLibVersion = [[NSString alloc] initWithFormat:@"%X", libver];
    }
    else if ([response.UUID isEqual:[CBUUID UUIDWithString:@RX_FROM_BLE_DEVICE_UUID]])
    {
        //improve length handling
        static unsigned char buffer[512];
        [response.value getBytes:buffer length:response.value.length];
        UInt16 value;

        switch(buffer[0])
        {
            case 0x0B:
                value = buffer[2] | buffer[1] << 8;
                self.temperature = value;
                NSLog(@"Temp Value: %i or %f", value, self.temperature);
                break;
            case 0x0C:
                value = buffer[2] | buffer[1] << 8;
                self.lux = value;
                NSLog(@"Light Value: %i or %f", value, self.lux);
                break;
            case 0x0D:
                value = buffer[2] | buffer[1] << 8;
                self.db = value;
                NSLog(@"Sound Value: %i or %f", value, self.db);
                break;
            case 0x0E:
                value = buffer[2] | buffer[1] << 8;
                self.accelX = value/1000.0;
                NSLog(@"X accelerator: %i or %f", value, self.accelX);
                break;
            case 0x0F:
                value = buffer[2] | buffer[1] << 8;
                self.accelY = value/1000.0;
                NSLog(@"Y accelerator: %i or %f", value, self.accelY);
                break;
            case 0x10:
                value = buffer[2] | buffer[1] << 8;
                self.accelZ = value/1000.0;
                NSLog(@"Z accelerator: %i or %f", value, self.accelZ);
                break;
            default:
                NSLog(@"Did not recognize byte header");
                break;
        }
    }
        
}

-(void) toggleTemp: (BOOL) enable
{
    UInt8 buf[3] = {0xA0, 0x00, 0x00};
    
     if (enable)
         buf[1] = 0x01;
     else
         buf[1] = 0x00;
     
     NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    CBUUID *temp = [CBUUID UUIDWithString:@TX_TO_BLE_DEVICE_UUID];
    [peripheral writeValue:data forCharacteristic:[characteristics objectForKey:temp] type:CBCharacteristicWriteWithoutResponse];
}
-(void) toggleLight: (BOOL) enable
{
    UInt8 buf[3] = {0xA1, 0x00, 0x00};
    
    if (enable)
        buf[1] = 0x01;
    else
        buf[1] = 0x00;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    CBUUID *temp = [CBUUID UUIDWithString:@TX_TO_BLE_DEVICE_UUID];
    [peripheral writeValue:data forCharacteristic:[characteristics objectForKey:temp] type:CBCharacteristicWriteWithoutResponse];
    
}
-(void) toggleSound: (BOOL) enable
{
    UInt8 buf[3] = {0xA2, 0x00, 0x00};
    
    if (enable)
        buf[1] = 0x01;
    else
        buf[1] = 0x00;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    CBUUID *temp = [CBUUID UUIDWithString:@TX_TO_BLE_DEVICE_UUID];
    [peripheral writeValue:data forCharacteristic:[characteristics objectForKey:temp] type:CBCharacteristicWriteWithoutResponse];

}
-(void) toggleAccelerometer: (BOOL) enable
{
    NSLog(@"About to toggleAccelerometer!");
    UInt8 buf[3] = {0xA3, 0x00, 0x00};
    
    if (enable)
        buf[1] = 0x01;
    else
        buf[1] = 0x00;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    CBUUID *temp = [CBUUID UUIDWithString:@TX_TO_BLE_DEVICE_UUID];
    [peripheral writeValue:data forCharacteristic:[characteristics objectForKey:temp] type:CBCharacteristicWriteWithoutResponse];
    
}
@end
