//
//  PBLEConnectionProvider.h
//  BLEManagerDemonstrator
//
//  Created by saha on 10/12/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PBLEConnectionProvider <NSObject>
-(void)connectToCBPeripheral:(CBPeripheral*)peripheral;
-(void)disConnectFromCBPeripheral:(CBPeripheral*)peripheral;
@end
