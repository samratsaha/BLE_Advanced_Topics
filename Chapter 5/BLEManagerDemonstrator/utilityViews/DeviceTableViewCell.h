//
//  DeviceTableViewCell.h
//  BLEManagerDemonstrator
//
//  Created by saha on 10/12/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEDevice.h"
@protocol PDeviceTableViewCellDelegate
-(void)informConnectToDeviceClicked:(BLEDevice*)device;
@end
@interface DeviceTableViewCell : UITableViewCell
{
@private IBOutlet UILabel *_deviceNameLabel;
@private IBOutlet UILabel *_deviceUUIDLabel;
@private IBOutlet UILabel *_deviceRSSIValueLabel;
@private IBOutlet UIButton *_connectToDeviceButton;
}
@property(nonatomic,strong)BLEDevice *device;
@property(nonatomic,readwrite)BOOL isOddRow;
@property(nonatomic,readwrite)id<PDeviceTableViewCellDelegate> delegate;
-(IBAction)connectToDeviceClicked:(id)sender;
-(void)render;
@end

