//
//  PBLEManagerEventListener.h
//  BLEManagerDemonstrator
//
//  Created by saha on 9/21/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLEDevice;
//@enum CBCentralManagerState;
@protocol PBLEManagerEventListener <NSObject>
@required
-(void) informScanStarted;
-(void) informScanStopped;
-(void) informScanFinished;
-(void) informDeviceFound:(BLEDevice*)device;
//@optional
//-(void)informBTStateChanged:(CBCentralManagerState)state;
@end