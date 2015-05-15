//
//  DeviceDetailsViewController.h
//  BLEManagerDemonstrator
//
//  Created by saha on 10/13/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import "ViewController.h"
#import "PBLEDeviceEventListener.h"
#import "ServicesTableViewCell.h"
#import "CharacteristicTableViewCell.h"
@class BLEDevice;
@class CBService;
@class CBCharacteristic;

@interface DeviceDetailsViewController : ViewController<PBLEDeviceEventListener,
                                                        UITableViewDataSource,UITableViewDelegate,
                                                        P_FindCharacteristicsClickedHandler,P_ShowCharacteristicDetailsClickHandler>
{
@private IBOutlet UIActivityIndicatorView *_activityIndicatorView;
@private IBOutlet UILabel *_statusTextLabel;
@private IBOutlet UILabel *_deviceNameLabel;
@private IBOutlet UILabel *_deviceUUIDLabel;
@private IBOutlet UILabel *_deviceRSSIValueLabel;
@private IBOutlet UITableView *_servicesAndCharacteristicsTableView;
    //reference to services
@private NSArray *_services;
}

@property(nonatomic,retain)BLEDevice* device;
-(IBAction)logoTapGestureRecognizerHandler:(UIGestureRecognizer*)recognizer;
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath;

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

#pragma mark - PFindCharacteristicsClickhandler
-(void)handleFindCharacteristicsClicked:(CBService*)service;

#pragma mark - P_ShowCharacteriticDetailsClickHandler
-(void)handleShowCharacteristicDetailsClicked:(CBCharacteristic*)characteristic;
@end
