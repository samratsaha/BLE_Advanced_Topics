//
//  DeviceTableViewCell.m
//  BLEManagerDemonstrator
//
//  Created by saha on 10/12/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import "DeviceTableViewCell.h"

@implementation DeviceTableViewCell
@synthesize device,isOddRow,delegate;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)connectToDeviceClicked:(id)sender
{
    [self.delegate informConnectToDeviceClicked:self.device];
}
-(void)render
{
    [_deviceNameLabel setText:
            [@"Peripheral Name: " stringByAppendingString:
                [self.device getPeripheralName]==nil?
                        @"No Name Found For Peripheral":
                        [self.device getPeripheralName]]];
    [_deviceUUIDLabel setText:
                [@"Peripheral UUID/Identifier: " stringByAppendingString:
                    [self.device getPeripheralUUID].UUIDString]];
    [_deviceRSSIValueLabel setText:
                [@"Peripheral RSSI: " stringByAppendingString: self.device.RSSI.stringValue]];
    self.backgroundColor = self.isOddRow?
                        [UIColor lightGrayColor ]:
                        [UIColor orangeColor];
}

@end
