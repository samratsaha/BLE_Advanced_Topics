//
//  ServicesTableViewCell.h
//  BLEManagerDemonstrator
//
//  Created by saha on 10/21/14.
//  Copyright (c) 2014 samratsaha. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBService;
@protocol P_FindCharacteristicsClickedHandler
-(void)handleFindCharacteristicsClicked:(CBService*)service;
@end
@interface ServicesTableViewCell : UITableViewCell
{
@private IBOutlet UILabel *_uuidLabel;
@private IBOutlet UILabel *_isPrimaryLabel;
@private IBOutlet UIButton *_findCharacteristicsButton;
}
@property(readwrite,nonatomic,weak)CBService *service;
@property(readwrite,nonatomic,weak)id<P_FindCharacteristicsClickedHandler> findCharacteristicsClickedHandler;
-(void)render;
-(IBAction)findCharacteristicsClicked:(id)sender;
@end
