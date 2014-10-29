//
//  Controller.m
//  ToTheMoon
//
//  Created by Zenko Klapko on 10/28/14.
//  Copyright (c) 2014 Zenko Klapko. All rights reserved.
//

#import "Controller.h"

@implementation Controller

+(void) buzzer: (RFduino *) controller
{
    NSLog(@"Buzzing");
    UInt8 buf[3] = {0x02, 0x00, 0x00};
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [controller send:data];
}
+(void) hapticShock: (RFduino *) controller
{
    NSLog(@"Shocking!");
    UInt8 buf[3] = {0x03, 0x00, 0x00};
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [controller send:data];
}
+(void) toggleAccel: (RFduino *) controller enable:(BOOL) accelOn
{
    NSLog(@"Toggling accelerometer!");
    UInt8 buf[3] = {0x04, 0x00, 0x00};
    if(accelOn)
        buf[1] = 0x01;
    else
        buf[1] = 0x00;
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [controller send:data];
}
+(AccelPoint) parseDatas: (NSData *) rawDatas
{
    NSLog(@"Datas length %lu", (unsigned long)[rawDatas length]);
//    dataFloat(rawDatas);
    
//    value = buffer[header+2] | buffer[header+1] << 8;

    AccelPoint x;
    x.x = 0;
    x.y = 1;
    x.z = 2;
    return x;
}
@end
