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

    static unsigned int step = 0;
    static AccelPoint xyz;
    // may be losing bytes when sending too quickly
    //if([rawDatas length] == 1)
    //    step = 0;
    if((step%4) != 0 && [rawDatas length] == 1)
    {
        step = 1;
        xyz.ready = NO;
        return xyz;
    }
    
    if (step%4 == 1)
    {
        xyz.ready = NO;
        xyz.x = dataFloat(rawDatas);
    }
    else if (step%4 == 2)
    {
        xyz.ready = NO;
        xyz.y = dataFloat(rawDatas);
    }
    else if (step%4 == 3)
    {
        xyz.ready = NO;
        xyz.z = dataFloat(rawDatas);
    }
    else if(step%4 == 0)
    {
        xyz.ready = YES;
    }
    step++;

    return xyz;
}
@end
