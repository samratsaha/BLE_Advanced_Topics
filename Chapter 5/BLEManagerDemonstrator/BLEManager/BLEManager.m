//
//  BLEManager.m
//  BLEManagerDemonstrator
//
//  Created by saha on 9/21/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import "BLEManager.h"
#import "BLEDevice.h"

@interface BLEManager()
@property(nonatomic,readwrite,strong)NSMutableArray *devices;
-(void)informBLEDeviceThatPeripheralHasConnected:(CBPeripheral*)peripheral;
-(void)informBLEDeviceThatPeripheralHasDisconnected:(CBPeripheral*)peripheral;
@end
@implementation BLEManager
@synthesize devices;
-(void)finishInit
{
    static BOOL initialized = NO;
    if(initialized) return;
    self.devices = [[NSMutableArray alloc]init];
    _listeners = [[NSMutableArray alloc]init];
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    initialized = YES;
}

#pragma mark - Main Methods For Application
+(BLEManager*)GetInstance
{
    static dispatch_once_t lock;
    static BLEManager *_instance = nil;
    dispatch_once(&lock,
                  ^{
                      _instance = [[BLEManager alloc]init];
                      [_instance finishInit];
                  });
    return _instance;
}
-(void) startScan
{
    NSLog(@"Starting Scan");
    [_manager scanForPeripheralsWithServices:nil options:nil];
}
-(void) stopScan
{
    [_manager stopScan];
}
-(void) addListener:(id<PBLEManagerEventListener>)listener
{
    if(![listener conformsToProtocol:@protocol(PBLEManagerEventListener)]||
       [_listeners indexOfObject:listener]!=NSNotFound) return;
    [_listeners addObject:listener];
    
}
-(void) removeListener:(id<PBLEManagerEventListener>)listener
{
    if(![listener conformsToProtocol:@protocol(PBLEManagerEventListener)]||
       [_listeners indexOfObject:listener]==NSNotFound) return;
    [_listeners removeObject:listener];
    
}
#pragma mark - PConnectionProvider implementation
-(void)connectToCBPeripheral:(CBPeripheral*)peripheral
{
    if(peripheral.state==CBPeripheralStateConnected)
    {
        [self informBLEDeviceThatPeripheralHasConnected:peripheral];
    }
    [_manager connectPeripheral:peripheral options:nil];
}
-(void)disConnectFromCBPeripheral:(CBPeripheral*)peripheral
{
    if(peripheral.state==CBPeripheralStateDisconnected)
    {
        [self informBLEDeviceThatPeripheralHasDisconnected:peripheral];
        return;
    }
    [_manager cancelPeripheralConnection:peripheral];
}
#pragma mark - internal implementation of private methods
-(void)informBLEDeviceThatPeripheralHasConnected:(CBPeripheral*)peripheral
{
    for(BLEDevice *device in self.devices)
    {
        if([[device getPeripheralUUID]isEqual:peripheral.identifier])
        {
            [device informPeripheralConnected];
        }
    }
}
-(void)informBLEDeviceThatPeripheralHasDisconnected:(CBPeripheral*)peripheral
{
    for(BLEDevice *device in self.devices)
    {
        if([[device getPeripheralUUID]isEqual:peripheral.identifier])
        {
            [device informPeripheralDisconnected];
        }
    }
}
#pragma mark - CBCentralManagerDelegate Protocol Implementation
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch ([_manager state]) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CBCentralManagerStatePoweredOn");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        default:
            break;
    }
}
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"Peripherals retrieved");
    
}
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"Retrieved Connected Peripherals");
    
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //check if this is a duplicate entry
    for(BLEDevice *device in self.devices)
    {
        if([[device getPeripheralUUID]isEqual:peripheral.identifier])
        {
            return;
        }
    }
    BLEDevice *device = [BLEDevice CreateFromCBPeripheral:peripheral andAdvertisementData:advertisementData
                                                  andRSSI:RSSI andConnectionProvider:self];
    //NSLog(@"Found device in BLEManager: %@",[device getPeripheralName]);
    [self.devices addObject:device];
    //delegate to provider
    for(id<PBLEManagerEventListener> listener in _listeners)
    {
        [listener informDeviceFound:device];
    }
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    for(BLEDevice *device in self.devices)
    {
        if([[device getPeripheralUUID]isEqual:peripheral.identifier])
        {
            [device informPeripheralConnected];
        }
    }
    
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Disconnected from peripheral");
}

@end
