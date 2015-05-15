//
//  ServicesTableViewCell.m
//  BLEManagerDemonstrator
//
//  Created by saha on 10/21/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import "ServicesTableViewCell.h"
#import <CoreBluetooth/CoreBluetooth.h>
@implementation ServicesTableViewCell
@synthesize service,findCharacteristicsClickedHandler;

- (void)awakeFromNib {
    // Initialization code
    
}
-(void)render
{
    _uuidLabel.text = [@"Service UUID: " stringByAppendingString:[self.service.UUID UUIDString]];
    _isPrimaryLabel.text = [@"Is Primary? " stringByAppendingString:self.service.isPrimary?@"true":@"false"];
}
-(IBAction)findCharacteristicsClicked:(id)sender
{
    [self.findCharacteristicsClickedHandler handleFindCharacteristicsClicked:self.service];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
