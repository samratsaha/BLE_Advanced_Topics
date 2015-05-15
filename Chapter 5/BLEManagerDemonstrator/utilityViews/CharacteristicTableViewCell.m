//
//  CharacteristicTableViewCell.m
//  BLEManagerDemonstrator
//
//  Created by saha on 10/21/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import "CharacteristicTableViewCell.h"
#import <CoreBluetooth/CoreBluetooth.h>

static NSString *CHARACTERISTIC_CAN_READ = @"Can Read";
@implementation CharacteristicTableViewCell
@synthesize characteristic,clickHandler,isOddRow;
- (void)awakeFromNib {
    // Initialization code
}
-(void)render
{
    _uuidLabel.text = [@"Characteristic UUID: " stringByAppendingString:[self.characteristic.UUID UUIDString]];
    //NSLog(@"Is od??? %d",self.isOddRow);
    self.backgroundColor = self.isOddRow?
    [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0f]:
    [UIColor orangeColor];
}
-(IBAction)showChracteristicDetailsClicked:(id)sender
{
    [self.clickHandler handleShowCharacteristicDetailsClicked:self.characteristic];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
