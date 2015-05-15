//
//  ViewController.m
//  BLEManagerDemonstrator
//
//  Created by saha on 9/21/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import "ViewController.h"
#import "BLEManager.h"
#import "BLEDevice.h"
#import "DeviceTableViewCell.h"
#import "DeviceDetailsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[BLEManager GetInstance]addListener:self];
    _currentStatusTextView.scrollEnabled = YES;
}
#pragma mark interface related actions
static bool scanClicked = NO;
static NSString *buttonTextForStartScan = @"Scan for Devices";
static NSString *buttonTextForStopScan = @"Stop Scan";
static NSString *statusTextForStartingScan = @"Start Scan Clicked... calling on BLEManager to start scan\n";
static NSString *statusTextForStoppingScan = @"Stop Scan Clicked... calling on BLEManager to stop scan\n";
-(IBAction)scanButtonClicked:(id)sender
{
    if(scanClicked)
    {
        [[BLEManager GetInstance]stopScan];
        [_scanButton setTitle:buttonTextForStartScan forState:UIControlStateNormal];
        [_currentStatusTextView insertText:statusTextForStoppingScan];
        
    }else
    {
        [[BLEManager GetInstance]startScan];
        [_scanButton setTitle:buttonTextForStopScan forState:UIControlStateNormal];
        [_currentStatusTextView insertText:statusTextForStartingScan];
    }
    [self toggleScanButtonState];
    scanClicked=!scanClicked;
}
-(void)toggleScanButtonState
{
    if(scanClicked)
    {
        [_scanButton setTitle:buttonTextForStartScan forState:UIControlStateNormal];
        [_currentStatusTextView insertText:statusTextForStoppingScan];
        
    }else
    {
        [_scanButton setTitle:buttonTextForStopScan forState:UIControlStateNormal];
        [_currentStatusTextView insertText:statusTextForStartingScan];
    }
}
#pragma mark - DeviceTableViewCellDelegate
static NSString *SEGUE_DISPLAY_DEVICE_DETAILS_SCREEN = @"K_DisplayDeviceDetailsSegue";
-(void) informConnectToDeviceClicked:(BLEDevice *)device
{
    _selectedDevice = device;
    [[BLEManager GetInstance]stopScan];
    scanClicked = YES;
    [self toggleScanButtonState];
    scanClicked = NO;
    [self performSegueWithIdentifier:SEGUE_DISPLAY_DEVICE_DETAILS_SCREEN sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_DISPLAY_DEVICE_DETAILS_SCREEN]) {
        DeviceDetailsViewController *controller = (DeviceDetailsViewController *)segue.destinationViewController;
        controller.device = _selectedDevice;
    }
}
#pragma mark - All devices Table View stuff
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [BLEManager GetInstance].devices.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"K_DeviceTableViewCell";
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.device = [[BLEManager GetInstance].devices objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.isOddRow = indexPath.row%2!=0;
    [cell render];
    return cell;
}
#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
#pragma mark BLEManagerEventListener Implementation
-(void) informScanStarted
{
}
-(void) informScanStopped
{
    
}
-(void) informScanFinished
{
    
}
-(void) informDeviceFound:(BLEDevice*)device
{
    [_currentStatusTextView insertText:[[device getPeripheralUUID]UUIDString]];
    [_allDevicesTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
