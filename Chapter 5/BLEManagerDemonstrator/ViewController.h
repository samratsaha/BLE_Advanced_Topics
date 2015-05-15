//
//  ViewController.h
//  BLEManagerDemonstrator
//
//  Created by saha on 9/21/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBLEManagerEventListener.h"
#import "DeviceTableViewCell.h"
@class BLEDevice;
@interface ViewController : UIViewController<PBLEManagerEventListener,
                                                UITableViewDataSource,UITableViewDelegate,
                                                PDeviceTableViewCellDelegate>
{
    //state variables
@private BOOL _currentState;
    //selected device
@private BLEDevice *_selectedDevice;
    //Interface elements
@private IBOutlet UITableView *_allDevicesTableView;
@private IBOutlet UITextView *_currentStatusTextView;
@private IBOutlet UIButton *_scanButton;
}
-(IBAction)scanButtonClicked:(id)sender;
#pragma mark - PBLEManagerEventListener method declarations
-(void) informScanStarted;
-(void) informScanStopped;
-(void) informScanFinished;
-(void) informDeviceFound:(BLEDevice*)device;
#pragma mark - DeviceTableViewCellDelegate 
-(void) informConnectToDeviceClicked:(BLEDevice *)device;
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
@end

