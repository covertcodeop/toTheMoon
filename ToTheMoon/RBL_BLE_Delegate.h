//
//  RBL_BLE_Delegate.h
//  bleBasics
//
//  Created by zenko on 10/12/13.
//  Copyright (c) 2013 Zen&Ko, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RBL_BLE_Delegate <NSObject>

@required
-(void) bleFinishedScanning;
-(void) bleDidConnect:(NSUUID *) identifier;
-(void) bleDidDisconnect:(NSUUID *) identifier;

@optional
-(void) bleDidUpdateRSSI:(NSNumber *) rssi;
-(void) bleDidReceiveData;

@end
