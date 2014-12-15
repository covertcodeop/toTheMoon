//
//  Controller.h
//  ToTheMoon
//
//  Created by Zenko Klapko on 10/28/14.
//  Copyright (c) 2014 Zenko Klapko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFduino.h"

struct AccelPoint { BOOL ready; CGFloat x; CGFloat y; CGFloat z; }; typedef struct AccelPoint AccelPoint;

@interface Controller : NSObject


+(void) buzzer: (RFduino *) controller;
+(void) hapticShock: (RFduino *) controller;
+(void) toggleAccel: (RFduino *) controller enable:(BOOL) accelOn;
+(AccelPoint) parseDatas: (NSData *) rawDatas;
@end
