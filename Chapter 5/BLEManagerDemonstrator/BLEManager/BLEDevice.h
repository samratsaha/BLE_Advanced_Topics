//
//  BLEDevice.h
//  BLEManagerDemonstrator
//
//  Created by saha on 9/21/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PBLEConnectionProvider.h"
#import "PBLEDeviceEventListener.h"

@interface BLEDevice : NSObject<CBPeripheralDelegate>
{
@private NSMutableArray *_listeners;
}
@property(nonatomic,readonly) NSDictionary *advertisementData;
@property(nonatomic,readonly)NSNumber *RSSI;

#pragma mark - main functionality
+(BLEDevice*)CreateFromCBPeripheral:(CBPeripheral *)peripheral andAdvertisementData:(NSDictionary*)adData
                            andRSSI:(NSNumber*)RSSI andConnectionProvider:(id<PBLEConnectionProvider>)provider;
-(NSString*)getPeripheralName;
-(NSUUID*)getPeripheralUUID;
-(void)connect;
-(void)disConnect;
-(void)discoverServices;
-(void)discoverCharacteristicsForService:(CBService*)service;
-(void)readCharacteristicValue:(CBCharacteristic*)characteristic;
-(void)writeToCharacteristic:(CBCharacteristic*)characteristic withValue:(NSData*)data;
-(void) addListener:(id<PBLEDeviceEventListener>)listener;
-(void) removeListener:(id<PBLEDeviceEventListener>)listener;

#pragma mark - connect/disconnect callbacks
-(void)informPeripheralConnected;
-(void)informPeripheralDisconnected;
-(void)informPeripheralConnectionAttemptFailed;
-(void)informPeripheralDisConnectionAttemptFailed;

#pragma mark CBPeripheralDelegate declarations
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral;
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error;
@end