//
//  CharacteristicTableViewCell.h
//  BLEManagerDemonstrator
//
//  Created by saha on 10/21/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBCharacteristic;

@protocol P_ShowCharacteristicDetailsClickHandler
-(void)handleShowCharacteristicDetailsClicked:(CBCharacteristic*)characteristic;
@end

@interface CharacteristicTableViewCell : UITableViewCell
{
@private IBOutlet UILabel *_uuidLabel;
}
@property(nonatomic,readwrite,weak)CBCharacteristic *characteristic;
@property(nonatomic,readwrite)bool isOddRow;
@property(nonatomic,readwrite,weak)id<P_ShowCharacteristicDetailsClickHandler> clickHandler;
-(void)render;
-(IBAction)showChracteristicDetailsClicked:(id)sender;
@end
