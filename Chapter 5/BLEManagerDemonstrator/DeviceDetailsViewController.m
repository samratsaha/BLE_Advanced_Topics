//
//  DeviceDetailsViewController.m
//  BLEManagerDemonstrator
//
//  Created by saha on 10/13/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import "DeviceDetailsViewController.h"
#import "BLEDevice.h"
#import "CharacteristicDetailsViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface DeviceDetailsViewController ()

@end

@implementation DeviceDetailsViewController
@synthesize device;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.device == nil)
    {
        NSLog(@"Device is nil...wtf?");
        return;
    }
    [self.device addListener:self];
    _deviceNameLabel.text = [@"Peripheral Name: " stringByAppendingString:
                             [self.device getPeripheralName]==nil?
                             @"No Name Found For Peripheral":
                             [self.device getPeripheralName]];
    _deviceUUIDLabel.text = [@"Peripheral UUID/Identifier: " stringByAppendingString:
                             [self.device getPeripheralUUID].UUIDString];
    _deviceRSSIValueLabel.text = [@"Peripheral RSSI: " stringByAppendingString: self.device.RSSI.stringValue];
    
    [_activityIndicatorView startAnimating];
    
    _statusTextLabel.text = @"Connecting To Peripheral";
    _services = [[NSMutableArray alloc]init];
    [self.device connect];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
NSString *SEGUE_BACK_TO_HOME = @"K_BackToHomeFromDeviceSegue";
-(IBAction)logoTapGestureRecognizerHandler:(UIGestureRecognizer *)recognizer
{
    [self performSegueWithIdentifier:SEGUE_BACK_TO_HOME sender:self];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _services.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //get the servicewrapper for the section
    CBService *service = [_services objectAtIndex:section];
    //the trick lies here. Treat the service as the first row and the characteristics
    //as rows below it inside the same section
    //since service itself exsists so its count is 1
    //number of rows is service + num of characteristics in service
    return service.characteristics.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *serviceCellIdentifier = @"K_ServicesTableViewCell";
    static NSString *characteristicCellIdentifier = @"K_CharacteristicTableViewCell";
    CBService *service = [_services objectAtIndex:indexPath.section];
    UITableViewCell *cell;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:serviceCellIdentifier];
        ((ServicesTableViewCell*)cell).service = service;
        ((ServicesTableViewCell*)cell).findCharacteristicsClickedHandler = self;
        [((ServicesTableViewCell*)cell) render];
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:characteristicCellIdentifier];
        ((CharacteristicTableViewCell*)cell).characteristic = [service.characteristics objectAtIndex:indexPath.row-1];
        ((CharacteristicTableViewCell*)cell).isOddRow = ((indexPath.row-1)%2!=0);
        ((CharacteristicTableViewCell*)cell).clickHandler = self;
        [((CharacteristicTableViewCell*)cell) render];
        
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - PFindCharacteristicsClickhandler
-(void)handleFindCharacteristicsClicked:(CBService *)service
{
    [self.device discoverCharacteristicsForService:service];
}
#pragma mark - Handles Describe Characteristic Clicked
static NSString *SEGUE_DISPLAY_CHARACTERISTIC_DETAILS_SCREEN = @"K_DisplayCharacteristicDetailsSegue";
static CBCharacteristic *_selectedCharacteristic;
-(void)handleShowCharacteristicDetailsClicked:(CBCharacteristic*)characteristic
{
    _selectedCharacteristic = characteristic;
    [self performSegueWithIdentifier:SEGUE_DISPLAY_CHARACTERISTIC_DETAILS_SCREEN sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.device removeListener:self];
    if ([segue.identifier isEqualToString:SEGUE_DISPLAY_CHARACTERISTIC_DETAILS_SCREEN]) {
        CharacteristicDetailsViewController *controller = (CharacteristicDetailsViewController*)segue.destinationViewController;
        controller.device = self.device;
        controller.characteristic = _selectedCharacteristic;
        _selectedCharacteristic = nil;
    }
}
#pragma mark - PBLEDeviceEventListener message implementation
-(void) informDeviceConnected
{
    _statusTextLabel.text = @"Connected To Peripheral...Discovering Services";
    [self.device discoverServices];
}
-(void) informDeviceDisconnected
{
    
}
-(void) informDeviceConnectionFailed
{
    
}
-(void) informDiscoveredServices:(NSArray*)services;
{
    _services = services;
    _statusTextLabel.text=[@"Connected To Peripheral...Discovered Services...Number: " stringByAppendingFormat:@"%lu",(unsigned long)_services.count];
    [_servicesAndCharacteristicsTableView reloadData];
    [_activityIndicatorView stopAnimating];
    _activityIndicatorView.hidden=YES;
}

-(void) informDiscoveredCharacteristicsForService:(CBService*)service
{
    _statusTextLabel.text=[@"Connected To Peripheral...Discovered Characteristics for Service: " stringByAppendingString:[service.UUID UUIDString]];
    [_servicesAndCharacteristicsTableView reloadData];
}
-(void) informReadCharacteristic:(CBCharacteristic*)characteristic withError:(NSError *)error
{
    
}
-(void) informWroteCharacteristic:(CBCharacteristic*)characteristic withError:(NSError *)error
{
    
}
-(void) informCharcteristicNotificationReceived:(CBCharacteristic*)characteristic
{
    
}
-(void) informReadRSSIValue
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
