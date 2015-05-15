//
//  PBLEDeviceEventListener.h
//  BLEManagerDemonstrator
//
//  Created by saha on 9/22/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBPeripheral;
@class CBService;
@class CBCharacteristic;

@protocol PBLEDeviceEventListener <NSObject>
@required
-(void) informDeviceConnected;
-(void) informDeviceDisconnected;
-(void) informDeviceConnectionFailed;
-(void) informDiscoveredServices:(NSArray*)services;
-(void) informDiscoveredCharacteristicsForService:(CBService*)service;
-(void) informReadCharacteristic:(CBCharacteristic*)characteristic withError:(NSError*)error;
-(void) informWroteCharacteristic:(CBCharacteristic*)characteristic withError:(NSError*)error;
-(void) informCharcteristicNotificationReceived:(CBCharacteristic*)characteristic;
-(void) informReadRSSIValue;
@end
