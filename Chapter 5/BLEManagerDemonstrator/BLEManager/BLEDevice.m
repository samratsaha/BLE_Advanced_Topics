//
//  BLEDevice.m
//  BLEManagerDemonstrator
//
//  Created by saha on 9/21/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import "BLEDevice.h"
@interface BLEDevice()
@property(nonatomic,strong,readwrite) NSDictionary *advertisementData;
@property(nonatomic,strong,readwrite)NSNumber *RSSI;
@property(nonatomic,strong,readwrite)CBPeripheral *peripheral;
@property(nonatomic,strong,readwrite)id<PBLEConnectionProvider> provider;
@end
@implementation BLEDevice
@synthesize advertisementData,RSSI,peripheral,provider;
#pragma mark - Main Functionality
- (id)init {
    self = [super init];
    if (self) {
        _listeners = [[NSMutableArray alloc]init];
    }
    return self;
}
+(BLEDevice*)CreateFromCBPeripheral:(CBPeripheral *)peripheral andAdvertisementData:(NSDictionary*)adData
                            andRSSI:(NSNumber*)RSSI andConnectionProvider:(id<PBLEConnectionProvider>)provider
{
    BLEDevice *device = [[BLEDevice alloc]init];
    device.peripheral = peripheral;
    device.advertisementData = adData;
    device.RSSI = RSSI;
    device.provider = provider;
    //wire up CBPeripherals delegate in this factory
    peripheral.delegate = device;
    return device;
}

-(NSString*)getPeripheralName
{
    return  self.peripheral.name;
}
-(NSUUID*)getPeripheralUUID
{
    if(self.peripheral==nil) return nil;
    return self.peripheral.identifier;
}
-(void)connect
{
    [self.provider connectToCBPeripheral:self.peripheral];
}
-(void)disConnect
{
    [self.provider disConnectFromCBPeripheral:self.peripheral];
}
-(void)discoverServices
{
    [self.peripheral discoverServices:nil];
}

-(void)discoverCharacteristicsForService:(CBService*)service
{
    NSLog(@"Discovering Characteristics for service");
    [self.peripheral discoverCharacteristics:nil forService:service];
}
-(void)readCharacteristicValue:(CBCharacteristic *)characteristic
{
    [self.peripheral readValueForCharacteristic:characteristic];
}
-(void)writeToCharacteristic:(CBCharacteristic *)characteristic withValue:(NSData *)data
{
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

-(void) addListener:(id<PBLEDeviceEventListener>)listener
{
    if(![listener conformsToProtocol:@protocol(PBLEDeviceEventListener)]||
       [_listeners indexOfObject:listener]!=NSNotFound) return;
    [_listeners addObject:listener];
}
-(void) removeListener:(id<PBLEDeviceEventListener>)listener
{
    if(![listener conformsToProtocol:@protocol(PBLEDeviceEventListener)]||
       [_listeners indexOfObject:listener]==NSNotFound) return;
    [_listeners removeObject:listener];
}
#pragma mark - connect/disconnect callback implementation
-(void)informPeripheralConnected
{
    for (id<PBLEDeviceEventListener> listener in _listeners) {
        [listener informDeviceConnected];
    }
}
-(void)informPeripheralDisconnected
{
    
}
-(void)informPeripheralConnectionAttemptFailed
{
    
}
-(void)informPeripheralDisConnectionAttemptFailed
{
    
}
#pragma mark CBPeripheralDelegate declarations
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if(error!=nil)
    {
        NSLog(@"Error in discovering characteristics");
        return;
    }
    for (id<PBLEDeviceEventListener> listener in _listeners) {
        [listener informDiscoveredServices:self.peripheral.services];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"Didi discover characteristics");
    for (id<PBLEDeviceEventListener> listener in _listeners) {
        [listener informDiscoveredCharacteristicsForService:service];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    for (id<PBLEDeviceEventListener> listener in _listeners) {
        [listener informReadCharacteristic:characteristic withError:error];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    for (id<PBLEDeviceEventListener> listener in _listeners) {
        [listener informWroteCharacteristic:characteristic withError:error];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
}
@end
