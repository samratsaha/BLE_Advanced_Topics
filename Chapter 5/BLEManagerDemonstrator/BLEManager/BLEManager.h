//
//  BLEManager.h
//  BLEManagerDemonstrator
//
//  Created by saha on 9/21/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PBLEManagerEventListener.h"
#import "PBLEConnectionProvider.h"
@interface BLEManager : NSObject<CBCentralManagerDelegate,PBLEConnectionProvider>
{
@private CBCentralManager *_manager;
@private NSMutableArray *_listeners;
}
@property(nonatomic,readonly) NSMutableArray *devices;
#pragma mark - Main Method Declarations for Application
+(BLEManager*) GetInstance;
-(void) startScan;
-(void) stopScan;
-(void) addListener:(id<PBLEManagerEventListener>)listener;
-(void) removeListener:(id<PBLEManagerEventListener>)listener;
#pragma mark - CBCentralManagerDelegate message declarations
- (void)centralManagerDidUpdateState:(CBCentralManager *)central;
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals;
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals;
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;
- (void)centralManager:(CBCentralManager *)central
        didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
#pragma mark - PConnectionProvider message declarations
-(void)connectToCBPeripheral:(CBPeripheral*)peripheral;
-(void)disConnectFromCBPeripheral:(CBPeripheral*)peripheral;
@end
