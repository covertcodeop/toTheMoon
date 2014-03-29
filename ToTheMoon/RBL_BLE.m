//
//  RBL_BLE.m
//  bleBasics
//
//  Created by zenko on 10/12/13.
//  Copyright (c) 2013 Zen&Ko, LLC. All rights reserved.
//

#import "RBL_BLE.h"
#import "RBL_BLE_Defines.h"
#import "Sensibot.h"

@implementation RBL_BLE
{
    CBCentralManager *bleRadio;
}

@synthesize sensibots;

-(void) startup
{
    if(bleRadio == nil)
    {
        NSLog(@"Initializing CBCM for the first time");
        bleRadio =  [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    }
}

- (BOOL) findBLEPeripherals:(int) timeout
{
    if(bleRadio.state == CBCentralManagerStatePoweredOn)
    {
        NSLog(@"Scanning for peripherals with service UUID %@", @BLE_DEVICE_SERVICE_UUID);
        
        [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
        
        [bleRadio scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@BLE_DEVICE_SERVICE_UUID]] options:nil];
        return YES;
    }
    
    // else pop up dialog about not enabled/missing/dysfunctional bluetooth?
    return NO;
}

/*
 * CBCentralManagerDelegate
 */

//Monitoring Connections with Peripherals
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connecting peripheral [%@] to CBCM [%@]", peripheral, central);
    [[self list_delegate] bleDidConnect:peripheral.identifier];
    [[self detail_delegate] bleDidConnect:peripheral.identifier];
    
    [peripheral discoverServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@BLE_DEVICE_SERVICE_UUID]]];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral [%@] disconnected from CBCM [%@] with error [%@]", peripheral, central, error);
    [[self list_delegate] bleDidDisconnect:peripheral.identifier];
    [[self detail_delegate] bleDidDisconnect:peripheral.identifier];
    [sensibots removeObjectForKey:peripheral.identifier];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"CBCM [%@] failed to connect to peripheral [%@] with error [%@]", central, peripheral, error);
}

//Discovering and Retrieving Peripherals
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"CBCM [%@] discovered peripheral [%@] with RSSI [%@] and advertisement [%@]", central, peripheral, RSSI, advertisementData);

    peripheral.delegate = self;
    if(sensibots == nil)
    {
        sensibots = [[NSMutableDictionary alloc] initWithCapacity:BLE_NUMBER_OF_CONCURRENT_DEVICES];
    }
    SensiBot *temp = [[SensiBot alloc] init];
    temp.peripheral = peripheral;
 //   temp.peripheral.delegate = self;
    [sensibots setObject:temp forKey:peripheral.identifier];

    [bleRadio connectPeripheral: peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"CBCM [%@] retrieved the following connected peripherals [%@]", central, peripherals);
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"CBCM [%@] found these peripherals [%@]", central, peripherals);
}

//Monitoring Changes to the Central Manager’s State
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
{
    NSLog(@"CBCM [%@] restoring state [%@]", central, dict);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"CBCM [%@] changed state to [%s]", central, [self centralManagerStateToString: central.state]);
    
    /*switch(cbcm.state)
    {
        case CBCentralManagerStateUnknown:
            //hardware may be broken?
            break;
        case CBCentralManagerStateUnsupported:
            //your device is not supported
            break;
        case CBCentralManagerStateResetting:
            //please wait for CB to reset
            break;
        case CBCentralManagerStatePoweredOff:
            //alert UI layer & pop up dialog stating to go to settings and turn on bluetooth
            break;
        case CBCentralManagerStatePoweredOn:
            //do nothing
            break;
    }*/
}

/*
 * CBPeripheralDelegate
 */

//Discovering Services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"Discovered Services for peripheral [%@] with error [%@]", peripheral, error);
    
    for(CBService *service in peripheral.services)
    {
        //NSString *str = [[NSString alloc] initWithFormat:@"%@",  CFUUIDCreateString(nil, CFBridgingRetain(service.UUID)) ];
        //NSLog(@"Discovered service UUID 1: %@", str);
        NSLog(@"Discovered service UUID: %s",[[service.UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
        [peripheral discoverCharacteristics:nil forService: service];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"Peripheral [%@] discovered included services for service [%@] with error [%@]", peripheral, service, error);
}
//Discovering Characteristics and Characteristic Descriptors
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"Peripheral [%@] discovered characteristics for service [%@] with error [%@]", peripheral, service, error);

    SensiBot *temp = [sensibots objectForKey:peripheral.identifier];
    if(temp.characteristics == nil)
    {
        // 5 Services from RBL_BLE DEFINES
        temp.characteristics = [[NSMutableDictionary alloc] initWithCapacity:5];
    }

    for(CBCharacteristic *characteristic in service.characteristics)
    {
        [temp.characteristics setObject:characteristic forKey:characteristic.UUID];
    }

    [peripheral setNotifyValue:YES forCharacteristic:[temp.characteristics objectForKey:[CBUUID UUIDWithString:@RX_FROM_BLE_DEVICE_UUID]]];
    
    [peripheral readValueForCharacteristic:[temp.characteristics objectForKey:[CBUUID UUIDWithString:@BLE_DEVICE_VENDOR_NAME_UUID]]];
    [peripheral readValueForCharacteristic:[temp.characteristics objectForKey:[CBUUID UUIDWithString:@BLE_DEVICE_LIB_VERSION_UUID]]];
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Peripheral [%@] discovered descriptors for characteristic [%@] with error [%@]", peripheral, characteristic, error);
}
//Retrieving Characteristic and Characteristic Descriptor Values
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Peripheral [%@] updated value for characteristic [%@] with error [%@]", peripheral, characteristic, error);
    
    SensiBot *temp = [sensibots objectForKey:peripheral.identifier];
    [temp convertResponse:characteristic];
    //[[self list_delegate] bleDidReceiveData];
    [[self detail_delegate] bleDidReceiveData];
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"Peripheral [%@] updated value for descriptor [%@] with error [%@]", peripheral, descriptor, error);
}
//Writing Characteristic and Characteristic Descriptor Values
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Peripheral [%@] wrote value for characteristic [%@] with error [%@]", peripheral, characteristic, error);
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"Peripheral [%@] wrote value for descriptor [%@] with error [%@]", peripheral, descriptor, error);
}
//Managing Notifications for a Characteristic’s Value
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Peripheral [%@] updated notification for characteristic [%@] with error [%@]", peripheral, characteristic, error);
}
//Retrieving a Peripheral’s Received Signal Strength Indicator (RSSI) Data
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral [%@] changed name to [%@]", peripheral, peripheral.name);
}
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    //NSLog(@"Peripheral updated RSSI %i", [peripheral.RSSI intValue]);
    [[self list_delegate] bleDidUpdateRSSI:peripheral.RSSI];
    [[self detail_delegate] bleDidUpdateRSSI:peripheral.RSSI];
    
    SensiBot *bot = [sensibots objectForKey:peripheral.identifier];
    if(bot.enableRSSI)
        [peripheral readRSSI];
}
//Monitoring Changes to a Peripheral’s Name or Services
- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices
{
    NSLog(@"Peripheral [%@] modified services [%@]", peripheral, invalidatedServices);
}

/*
 * Utility methods
 */
- (const char *) centralManagerStateToString: (int)state
{
    switch(state)
    {
        case CBCentralManagerStateUnknown:
            return "State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return "State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return "State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return "State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return "State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return "State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return "State unknown";
    }
    
    return "Unknown state";
}

-(void) scanTimer:(NSTimer *)timer
{
    [bleRadio stopScan];
    NSLog(@"Stopped Scanning for peripherals");
    [[self list_delegate] bleFinishedScanning];
    [[self detail_delegate] bleFinishedScanning];
    //NSLog(@"Known peripherals : %d", [self.peripherals count]);
    //[self printKnownPeripherals];

}
@end
