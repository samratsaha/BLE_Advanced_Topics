//
//  CharacteristicDetailsViewController.h
//  BLEManagerDemonstrator
//
//  Created by saha on 11/1/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import "ViewController.h"
#import "PBLEDeviceEventListener.h"

@class BLEDevice;
@class CBService;
@class CBCharacteristic;

@interface CharacteristicDetailsViewController : ViewController<PBLEDeviceEventListener>
{
@private IBOutlet UIButton *_backToPeripheralButton;
@private IBOutlet UIButton *_readValueButton;
@private IBOutlet UILabel *_deviceNameLabel;
@private IBOutlet UILabel *_serviceNameLabel;
@private IBOutlet UILabel *_characteristicNameLabel;
@private IBOutlet UITextView *_characteristicDetailsTextView;
@private IBOutlet UITextField *_characteristicValueTextField;
@private IBOutlet UISegmentedControl *_dataTypeSegmentedControl;
@private IBOutlet UIButton *_writeCharacteristicValueButton;
@private IBOutlet UITextView *_statusTextView;
}
-(IBAction)backToPeripheralButtonClicked:(id)sender;
-(IBAction)readValueClicked:(id)sender;
-(IBAction)writeToCharacteristicClicked:(id)sender;
-(IBAction)handleLogoClickedTapGestureRecognizer:(UIGestureRecognizer*)recognizer;
@property(nonatomic,readwrite,weak)BLEDevice* device;
@property(nonatomic,readwrite,weak)CBCharacteristic *characteristic;
#pragma mark - PBLEDeviceEventListener message declarations
-(void) informDeviceConnected;
-(void) informDeviceDisconnected;
-(void) informDeviceConnectionFailed;
-(void) informDiscoveredServices:(NSArray*)services;
-(void) informDiscoveredCharacteristicsForService:(CBService*)service;
-(void) informReadCharacteristic:(CBCharacteristic*)characteristic withError:(NSError *)error;
-(void) informWroteCharacteristic:(CBCharacteristic*)characteristic withError:(NSError *)error;
-(void) informCharcteristicNotificationReceived:(CBCharacteristic*)characteristic;
-(void) informReadRSSIValue;
@end
